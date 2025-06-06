// ===================================================================
// * FARMER PROFILE PAGE
// * Purpose: User profile management and account information
// * Features: Profile display, edit options, settings, achievements
// * Security Level: HIGH - Personal user information
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/fade_in_animation.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // * Load user profile data when page initializes
    context.read<ProfileBloc>().add(const LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            onPressed: () => context.push('/main/profile/settings'),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const LoadingWidget();
          }
          
          if (state is ProfileError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ProfileBloc>().add(const LoadUserProfile());
              },
            );
          }
          
          if (state is ProfileLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(const RefreshUserProfile());
              },
              child: _buildProfileContent(state),
            );
          }
          
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildProfileContent(ProfileLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // * Profile Header
          FadeInAnimation(
            child: _buildProfileHeader(state.profile),
          ),
          
          const SizedBox(height: 24),
          
          // * Quick Stats
          FadeInAnimation(
            delay: const Duration(milliseconds: 200),
            child: _buildQuickStats(state.stats),
          ),
          
          const SizedBox(height: 24),
          
          // * Profile Actions
          FadeInAnimation(
            delay: const Duration(milliseconds: 400),
            child: _buildProfileActions(),
          ),
          
          const SizedBox(height: 24),
          
          // * Farm Information
          FadeInAnimation(
            delay: const Duration(milliseconds: 600),
            child: _buildFarmInformation(state.farmDetails),
          ),
          
          const SizedBox(height: 24),
          
          // * Achievement Section
          if (state.achievements.isNotEmpty) ...[
            FadeInAnimation(
              delay: const Duration(milliseconds: 800),
              child: _buildAchievements(state.achievements),
            ),
            const SizedBox(height: 24),
          ],
          
          // * Recent Activity
          FadeInAnimation(
            delay: const Duration(milliseconds: 1000),
            child: _buildRecentActivity(state.recentActivity),
          ),
          
          const SizedBox(height: 24),
          
          // * Account Actions
          FadeInAnimation(
            delay: const Duration(milliseconds: 1200),
            child: _buildAccountActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // * Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: CropFreshColors.green30Container,
                  backgroundImage: profile['profilePicture'] != null
                      ? NetworkImage(profile['profilePicture'])
                      : null,
                  child: profile['profilePicture'] == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: CropFreshColors.green30Primary,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: CropFreshColors.green30Primary,
                    child: IconButton(
                      onPressed: () => _showImagePicker(),
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // * Name and Basic Info
            Text(
              profile['name'] ?? 'Farmer Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              profile['phoneNumber'] ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // * Verification Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getVerificationColor(profile['verificationStatus']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getVerificationColor(profile['verificationStatus']),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getVerificationIcon(profile['verificationStatus']),
                    size: 16,
                    color: _getVerificationColor(profile['verificationStatus']),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getVerificationText(profile['verificationStatus']),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getVerificationColor(profile['verificationStatus']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // * Member Since
            Text(
              'Member since ${_formatDate(profile['memberSince'])}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Products Listed',
                    stats['totalProducts']?.toString() ?? '0',
                    Icons.inventory,
                    CropFreshColors.green30Primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Orders Completed',
                    stats['completedOrders']?.toString() ?? '0',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Revenue',
                    '₹${stats['totalRevenue'] ?? 0}',
                    Icons.account_balance_wallet,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Rating',
                    '${stats['rating'] ?? 0.0} ⭐',
                    Icons.star,
                    Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildActionTile(
              'Edit Profile',
              'Update your personal information',
              Icons.edit,
              () => context.push('/main/profile/edit'),
            ),
            
            _buildActionTile(
              'Farm Details',
              'Manage your farm information',
              Icons.agriculture,
              () => context.push('/main/profile/farm-details'),
            ),
            
            _buildActionTile(
              'Documents',
              'View and upload documents',
              Icons.description,
              () => context.push('/main/profile/documents'),
            ),
            
            _buildActionTile(
              'Payment Methods',
              'Manage payment and bank details',
              Icons.payment,
              () => context.push('/main/profile/payment-methods'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    String title, 
    String subtitle, 
    IconData icon, 
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : CropFreshColors.green30Primary;
    
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFarmInformation(Map<String, dynamic> farmDetails) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Farm Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/main/profile/farm-details'),
                  child: const Text('Edit'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoRow('Location', farmDetails['location'] ?? 'Not specified'),
            _buildInfoRow('Farm Size', '${farmDetails['farmSize'] ?? 0} acres'),
            _buildInfoRow('Primary Crops', farmDetails['primaryCrops']?.join(', ') ?? 'Not specified'),
            _buildInfoRow('Farming Experience', '${farmDetails['experience'] ?? 0} years'),
            _buildInfoRow('Irrigation Type', farmDetails['irrigationType'] ?? 'Not specified'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(List<Map<String, dynamic>> achievements) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return _buildAchievementCard(achievement);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            achievement['title'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            achievement['description'] ?? '',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<Map<String, dynamic>> activities) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length > 5 ? 5 : activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(activity);
              },
            ),
            
            if (activities.length > 5)
              Center(
                child: TextButton(
                  onPressed: () => context.push('/main/profile/activity'),
                  child: const Text('View All Activities'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getActivityColor(activity['type']).withOpacity(0.1),
        child: Icon(
          _getActivityIcon(activity['type']),
          color: _getActivityColor(activity['type']),
        ),
      ),
      title: Text(activity['title'] ?? ''),
      subtitle: Text(activity['description'] ?? ''),
      trailing: Text(
        _formatTimeAgo(activity['timestamp']),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildAccountActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildActionTile(
              'Privacy & Security',
              'Manage your privacy settings',
              Icons.security,
              () => context.push('/main/profile/privacy'),
            ),
            
            _buildActionTile(
              'Notifications',
              'Configure notification preferences',
              Icons.notifications,
              () => context.push('/main/profile/notifications'),
            ),
            
            _buildActionTile(
              'Help & Support',
              'Get help or contact support',
              Icons.help,
              () => context.push('/main/profile/support'),
            ),
            
            _buildActionTile(
              'Logout',
              'Sign out of your account',
              Icons.logout,
              () => _showLogoutDialog(),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  // * HELPER METHODS

  Color _getVerificationColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getVerificationIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return Icons.verified;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String _getVerificationText(String? status) {
    switch (status?.toLowerCase()) {
      case 'verified':
        return 'Verified Farmer';
      case 'pending':
        return 'Verification Pending';
      case 'rejected':
        return 'Verification Failed';
      default:
        return 'Not Verified';
    }
  }

  Color _getActivityColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Colors.blue;
      case 'product':
        return Colors.green;
      case 'payment':
        return Colors.orange;
      case 'review':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Icons.shopping_cart;
      case 'product':
        return Icons.inventory;
      case 'payment':
        return Icons.payment;
      case 'review':
        return Icons.star;
      default:
        return Icons.info;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatTimeAgo(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement camera image picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery image picker
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement logout functionality
                context.read<ProfileBloc>().add(const LogoutUser());
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
} 