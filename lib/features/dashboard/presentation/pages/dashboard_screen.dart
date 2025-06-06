import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/localization_service.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/weather_card.dart';
import '../widgets/market_prices_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/farm_summary_card.dart';
import '../widgets/greeting_header.dart';

/// Main Dashboard Screen - Heart of the CropFresh Farmers App
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Load dashboard data
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardContent(),
          _buildMarketplaceScreen(),
          _buildLogisticsScreen(),
          _buildKnowledgeScreen(),
          _buildSettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Build main dashboard content
  Widget _buildDashboardContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return _buildLoadingState();
        } else if (state is DashboardError) {
          return _buildErrorState(state.message);
        } else if (state is DashboardLoaded) {
          return _buildLoadedState(state);
        }
        return _buildInitialState();
      },
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your dashboard...'),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                context.read<DashboardBloc>().add(LoadDashboardData());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build initial state
  Widget _buildInitialState() {
    return const Center(
      child: Text('Welcome to CropFresh!'),
    );
  }

  /// Build loaded state with dashboard content
  Widget _buildLoadedState(DashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(RefreshDashboard());
        // Wait for refresh to complete
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          // App Bar with greeting
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: GreetingHeader(
                farmerName: state.farmerName,
                onNotificationTap: () => _showNotifications(state.notifications),
                notificationCount: state.notifications.length,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showNotifications(state.notifications),
                icon: Badge(
                  count: state.notifications.length,
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
              IconButton(
                onPressed: () => context.go(AppConstants.settingsRoute),
                icon: const Icon(Icons.person_outline),
              ),
            ],
          ),

          // Dashboard content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Farm Summary Card
                FarmSummaryCard(farmData: state.farmSummary),
                
                const SizedBox(height: 16),
                
                // Weather Card
                WeatherCard(weatherData: state.weatherData),
                
                const SizedBox(height: 16),
                
                // Quick Actions Grid
                QuickActionsGrid(
                  onActionTap: _handleQuickAction,
                ),
                
                const SizedBox(height: 16),
                
                // Market Prices Card
                MarketPricesCard(
                  marketPrices: state.marketPrices,
                  onViewAll: () => _currentIndex = 1,
                ),
                
                const SizedBox(height: 16),
                
                // Recent Activity Card
                RecentActivityCard(
                  activities: state.recentActivity,
                  onViewAll: () => _showAllActivity(state.recentActivity),
                ),
                
                const SizedBox(height: 100), // Bottom padding for navigation bar
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle quick action taps
  void _handleQuickAction(String action) {
    switch (action) {
      case 'sell_produce':
        context.go(AppConstants.marketplaceRoute);
        break;
      case 'buy_inputs':
        context.go(AppConstants.inputProcurementRoute);
        break;
      case 'book_logistics':
        context.go(AppConstants.logisticsRoute);
        break;
      case 'soil_test':
        context.go(AppConstants.soilTestingRoute);
        break;
      case 'call_vet':
        context.go(AppConstants.vetServicesRoute);
        break;
      case 'livestock':
        context.go(AppConstants.livestockRoute);
        break;
      case 'knowledge_hub':
        context.go(AppConstants.knowledgeHubRoute);
        break;
      case 'nursery':
        context.go(AppConstants.nurseryServicesRoute);
        break;
    }
  }

  /// Show notifications bottom sheet
  void _showNotifications(List<Map<String, dynamic>> notifications) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      // Mark all as read
                      Navigator.pop(context);
                    },
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
            ),
            
            // Notifications list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getNotificationColor(notification['type']),
                        child: Icon(
                          _getNotificationIcon(notification['type']),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        notification['title'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification['message']),
                          const SizedBox(height: 4),
                          Text(
                            notification['time'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      trailing: notification['priority'] == 'high'
                          ? Icon(
                              Icons.priority_high,
                              color: Theme.of(context).colorScheme.error,
                            )
                          : null,
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show all recent activity
  void _showAllActivity(List<Map<String, dynamic>> activities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            
            // Activities list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                        child: Icon(
                          _getActivityIcon(activity['icon']),
                          color: AppTheme.primaryGreen,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        activity['title'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activity['description']),
                          const SizedBox(height: 4),
                          Text(
                            activity['time'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get notification color based on type
  Color _getNotificationColor(String type) {
    switch (type) {
      case 'weather':
        return Colors.orange;
      case 'market':
        return Colors.green;
      case 'marketplace':
        return Colors.blue;
      default:
        return AppTheme.primaryGreen;
    }
  }

  /// Get notification icon based on type
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'weather':
        return Icons.wb_sunny;
      case 'market':
        return Icons.trending_up;
      case 'marketplace':
        return Icons.store;
      default:
        return Icons.notifications;
    }
  }

  /// Get activity icon based on icon name
  IconData _getActivityIcon(String iconName) {
    switch (iconName) {
      case 'agriculture':
        return Icons.agriculture;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'medical_services':
        return Icons.medical_services;
      default:
        return Icons.circle;
    }
  }

  /// Placeholder screens for other tabs
  Widget _buildMarketplaceScreen() {
    return const Center(
      child: Text(
        'Marketplace Screen\n(Under Development)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildLogisticsScreen() {
    return const Center(
      child: Text(
        'Logistics Screen\n(Under Development)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildKnowledgeScreen() {
    return const Center(
      child: Text(
        'Knowledge Hub Screen\n(Under Development)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return const Center(
      child: Text(
        'Settings Screen\n(Under Development)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  /// Build bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Logistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Knowledge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
