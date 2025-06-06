import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// * EDIT PROFILE PAGE
/// * Allows farmers to edit their personal and farm information
/// * Includes profile photo, contact details, and farm details
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _farmAreaController = TextEditingController();
  final _experienceController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedOwnership = 'Owner';
  String _selectedLanguage = 'English';
  List<String> _selectedCrops = ['Tomato', 'Rice'];

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _ownershipTypes = ['Owner', 'Tenant', 'Sharecropper'];
  final List<String> _languages = ['English', 'ಕನ್ನಡ', 'తెలుగు', 'हिंदी'];
  final List<String> _availableCrops = [
    'Rice', 'Wheat', 'Tomato', 'Onion', 'Potato', 'Cotton', 'Sugarcane',
    'Maize', 'Groundnut', 'Soybean', 'Chili', 'Banana', 'Mango'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // TODO: Load actual user data from storage/API
    _nameController.text = 'Rajesh Kumar';
    _phoneController.text = '+91 9876543210';
    _emailController.text = 'rajesh.kumar@example.com';
    _addressController.text = 'Village Hunsur, Mysore District, Karnataka';
    _farmAreaController.text = '2.5';
    _experienceController.text = '8';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _farmAreaController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        backgroundColor: CropFreshColors.green30Primary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Profile Photo Section
              _buildProfilePhotoSection(),
              
              // * Personal Information
              _buildSection('Personal Information', [
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                _buildDropdownField(
                  label: 'Gender',
                  value: _selectedGender,
                  options: _genders,
                  icon: Icons.wc,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildDropdownField(
                  label: 'Preferred Language',
                  value: _selectedLanguage,
                  options: _languages,
                  icon: Icons.language,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                ),
              ]),
              
              // * Farm Information
              _buildSection('Farm Information', [
                _buildTextField(
                  controller: _addressController,
                  label: 'Farm Address',
                  icon: Icons.location_on,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your farm address';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _farmAreaController,
                  label: 'Farm Area (Hectares)',
                  icon: Icons.landscape,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your farm area';
                    }
                    return null;
                  },
                ),
                _buildDropdownField(
                  label: 'Land Ownership',
                  value: _selectedOwnership,
                  options: _ownershipTypes,
                  icon: Icons.home,
                  onChanged: (value) {
                    setState(() {
                      _selectedOwnership = value!;
                    });
                  },
                ),
                _buildTextField(
                  controller: _experienceController,
                  label: 'Farming Experience (Years)',
                  icon: Icons.timeline,
                  keyboardType: TextInputType.number,
                ),
                _buildCropSelector(),
              ]),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CropFreshColors.green10Container,
                  border: Border.all(
                    color: CropFreshColors.green10Primary,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: CropFreshColors.green10Primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePhoto,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CropFreshColors.green10Primary,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to change profile photo',
            style: TextStyle(
              fontSize: 14,
              color: CropFreshColors.neutral50,
            ),
          ),
        ],
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: CropFreshColors.green10Primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: CropFreshColors.outline30Variant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: CropFreshColors.green10Primary),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: CropFreshColors.green10Primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: CropFreshColors.outline30Variant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: CropFreshColors.green10Primary),
          ),
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCropSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grass, color: CropFreshColors.green10Primary),
              const SizedBox(width: 12),
              const Text(
                'Primary Crops',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _availableCrops.map((crop) {
              final isSelected = _selectedCrops.contains(crop);
              return FilterChip(
                label: Text(crop),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCrops.add(crop);
                    } else {
                      _selectedCrops.remove(crop);
                    }
                  });
                },
                selectedColor: CropFreshColors.green10Container,
                checkmarkColor: CropFreshColors.green10Primary,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera functionality will be implemented')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery functionality will be implemented')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
} 