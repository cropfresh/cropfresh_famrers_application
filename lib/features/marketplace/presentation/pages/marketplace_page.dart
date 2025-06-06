// ===================================================================
// * MARKETPLACE PAGE
// * Purpose: Main marketplace interface for browsing and managing products
// * Features: Product listing, search, filters, quick actions
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/marketplace_bloc.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'Recent';

  @override
  void initState() {
    super.initState();
    // * Load marketplace data when page initializes
    context.read<MarketplaceBloc>().add(const LoadMarketplaceData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Marketplace',
        actions: [
          IconButton(
            onPressed: () => context.push('/marketplace/notifications'),
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () => context.push('/marketplace/search'),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const LoadingWidget();
          }
          
          if (state is MarketplaceError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<MarketplaceBloc>().add(const LoadMarketplaceData());
              },
            );
          }
          
          if (state is MarketplaceLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MarketplaceBloc>().add(const RefreshMarketplace());
              },
              child: _buildMarketplaceContent(state),
            );
          }
          
          return const LoadingWidget();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/marketplace/create-product'),
        icon: const Icon(Icons.add),
        label: const Text('Sell Product'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildMarketplaceContent(MarketplaceLoaded state) {
    return CustomScrollView(
      slivers: [
        // * Search and Filter Section
        SliverToBoxAdapter(
          child: _buildSearchAndFilters(),
        ),
        
        // * Quick Actions
        SliverToBoxAdapter(
          child: _buildQuickActions(),
        ),
        
        // * My Products Section
        if (state.myProducts.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader('My Products', () {
              context.push('/marketplace/my-products');
            }),
          ),
          SliverToBoxAdapter(
            child: _buildMyProductsList(state.myProducts),
          ),
        ],
        
        // * Browse Products Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Browse Products', null),
        ),
        
        // * Products Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = state.allProducts[index];
                return _buildProductCard(product);
              },
              childCount: state.allProducts.length,
            ),
          ),
        ),
        
        // * Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // * Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              // TODO: Implement search functionality
            },
          ),
          
          const SizedBox(height: 12),
          
          // * Category and Sort Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  'Category: $_selectedCategory',
                  Icons.category,
                  () => _showCategoryFilter(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterChip(
                  'Sort: $_sortBy',
                  Icons.sort,
                  () => _showSortOptions(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              'My Products',
              Icons.inventory,
              AppColors.primary,
              () => context.push('/marketplace/my-products'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              'Orders',
              Icons.shopping_cart,
              AppColors.secondary,
              () => context.push('/marketplace/orders'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              'Negotiations',
              Icons.chat_bubble,
              AppColors.accent,
              () => context.push('/marketplace/negotiations'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onViewAll) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All'),
            ),
        ],
      ),
    );
  }

  Widget _buildMyProductsList(List<Map<String, dynamic>> products) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: _buildMyProductCard(product),
          );
        },
      ),
    );
  }

  Widget _buildMyProductCard(Map<String, dynamic> product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '₹${product['price']}/kg',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${product['quantity']} kg available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(product['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product['status'] ?? '',
                    style: TextStyle(
                      fontSize: 10,
                      color: _getStatusColor(product['status']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/marketplace/product/${product['id']}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: product['image'] != null
                    ? Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image, size: 40);
                        },
                      )
                    : const Icon(Icons.agriculture, size: 40),
              ),
            ),
            
            // * Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${product['price']}/kg',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${product['location']}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.orange.shade400,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product['rating'] ?? 0.0}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        const Spacer(),
                        Text(
                          '${product['quantity']}kg',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'sold':
        return Colors.blue;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['All', 'Vegetables', 'Fruits', 'Grains', 'Spices', 'Others']
                  .map((category) => ListTile(
                        title: Text(category),
                        leading: Radio<String>(
                          value: category,
                          groupValue: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...['Recent', 'Price: Low to High', 'Price: High to Low', 'Distance', 'Rating']
                  .map((sortOption) => ListTile(
                        title: Text(sortOption),
                        leading: Radio<String>(
                          value: sortOption,
                          groupValue: _sortBy,
                          onChanged: (value) {
                            setState(() {
                              _sortBy = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }
} 