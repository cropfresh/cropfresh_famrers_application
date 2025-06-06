import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// * SETTINGS PAGE
/// * Application settings and user preferences
/// * Language, notifications, security, and app configuration
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _biometricAuth = false;
  bool _darkMode = false;
  bool _offlineMode = true;
  String _selectedLanguage = 'English';
  String _selectedRegion = 'Karnataka';

  final List<String> _languages = ['English', 'ಕನ್ನಡ', 'తెలుగు', 'हिंदी'];
  final List<String> _regions = ['Karnataka', 'Andhra Pradesh', 'Telangana', 'Tamil Nadu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'Settings',
        backgroundColor: CropFreshColors.green30Primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Account Settings
            _buildSection(
              'Account Settings',
              [
                _buildListTile(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildListTile(
                  icon: Icons.security,
                  title: 'Privacy & Security',
                  subtitle: 'Manage your privacy settings',
                  onTap: () => _showPrivacySettings(),
                ),
                _buildListTile(
                  icon: Icons.verified_user,
                  title: 'Account Verification',
                  subtitle: 'Verify your farmer credentials',
                  onTap: () => _showVerificationDialog(),
                ),
              ],
            ),

            // * App Preferences
            _buildSection(
              'App Preferences',
              [
                _buildDropdownTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'Choose your preferred language',
                  value: _selectedLanguage,
                  options: _languages,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
                _buildDropdownTile(
                  icon: Icons.location_on,
                  title: 'Region',
                  subtitle: 'Select your farming region',
                  value: _selectedRegion,
                  options: _regions,
                  onChanged: (value) {
                    setState(() {
                      _selectedRegion = value!;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Enable dark theme',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.offline_bolt,
                  title: 'Offline Mode',
                  subtitle: 'Download content for offline use',
                  value: _offlineMode,
                  onChanged: (value) {
                    setState(() {
                      _offlineMode = value;
                    });
                  },
                ),
              ],
            ),

            // * Notifications
            _buildSection(
              'Notifications',
              [
                _buildSwitchTile(
                  icon: Icons.notifications,
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.email,
                  title: 'Email Notifications',
                  subtitle: 'Receive updates via email',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.sms,
                  title: 'SMS Notifications',
                  subtitle: 'Receive SMS alerts',
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() {
                      _smsNotifications = value;
                    });
                  },
                ),
                _buildListTile(
                  icon: Icons.tune,
                  title: 'Notification Preferences',
                  subtitle: 'Customize notification categories',
                  onTap: () => _showNotificationPreferences(),
                ),
              ],
            ),

            // * Security
            _buildSection(
              'Security',
              [
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face ID',
                  value: _biometricAuth,
                  onChanged: (value) {
                    setState(() {
                      _biometricAuth = value;
                    });
                  },
                ),
                _buildListTile(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your login password',
                  onTap: () => _showChangePasswordDialog(),
                ),
                _buildListTile(
                  icon: Icons.phonelink_lock,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security to your account',
                  onTap: () => _showTwoFactorSetup(),
                ),
              ],
            ),

            // * Support & Help
            _buildSection(
              'Support & Help',
              [
                _buildListTile(
                  icon: Icons.help,
                  title: 'Help Center',
                  subtitle: 'Find answers to common questions',
                  onTap: () => _openHelpCenter(),
                ),
                _buildListTile(
                  icon: Icons.chat,
                  title: 'Contact Support',
                  subtitle: 'Get help from our support team',
                  onTap: () => _contactSupport(),
                ),
                _buildListTile(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the app',
                  onTap: () => _showFeedbackDialog(),
                ),
                _buildListTile(
                  icon: Icons.star_rate,
                  title: 'Rate App',
                  subtitle: 'Rate CropFresh on app store',
                  onTap: () => _rateApp(),
                ),
              ],
            ),

            // * About
            _buildSection(
              'About',
              [
                _buildListTile(
                  icon: Icons.info,
                  title: 'App Version',
                  subtitle: '1.0.0 (Build 1)',
                  onTap: () => _showVersionInfo(),
                ),
                _buildListTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () => _showTermsOfService(),
                ),
                _buildListTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => _showPrivacyPolicy(),
                ),
                _buildListTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  onTap: () => _showSignOutDialog(),
                  isDestructive: true,
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? CropFreshColors.errorPrimary : CropFreshColors.green30Primary;
    
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? CropFreshColors.errorPrimary : Colors.black,
                          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: CropFreshColors.onBackground60Secondary,
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: CropFreshColors.onBackground60Tertiary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: CropFreshColors.green30Primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: CropFreshColors.onBackground60Secondary,
          fontSize: 12,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: CropFreshColors.green30Primary,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: CropFreshColors.green30Primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: CropFreshColors.onBackground60Secondary,
          fontSize: 12,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: CropFreshColors.onBackground60Tertiary),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _showPrivacySettings() {
    // TODO: Implement privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings will be implemented')),
    );
  }

  void _showVerificationDialog() {
    // TODO: Implement account verification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account verification will be implemented')),
    );
  }

  void _showNotificationPreferences() {
    // TODO: Implement notification preferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification preferences will be implemented')),
    );
  }

  void _showChangePasswordDialog() {
    // TODO: Implement change password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password will be implemented')),
    );
  }

  void _showTwoFactorSetup() {
    // TODO: Implement 2FA setup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Two-factor authentication will be implemented')),
    );
  }

  void _openHelpCenter() {
    // TODO: Implement help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center will be implemented')),
    );
  }

  void _contactSupport() {
    // TODO: Implement support contact
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact support will be implemented')),
    );
  }

  void _showFeedbackDialog() {
    // TODO: Implement feedback form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback form will be implemented')),
    );
  }

  void _rateApp() {
    // TODO: Implement app rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App rating will be implemented')),
    );
  }

  void _showVersionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Version'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CropFresh Farmers App'),
            Text('Version: 1.0.0'),
            Text('Build: 1'),
            Text('Last Updated: January 2024'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    // TODO: Implement terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of service will be implemented')),
    );
  }

  void _showPrivacyPolicy() {
    // TODO: Implement privacy policy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy will be implemented')),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement sign out functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign out functionality will be implemented')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: CropFreshColors.errorPrimary),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
} 