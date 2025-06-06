import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/fade_in_animation.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';

// * PROFILE SETUP SCREEN
// * Collects basic farmer profile information after OTP verification
// * Features: Personal info, farm details, document upload, progressive disclosure

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with TickerProviderStateMixin {
  // * Controllers
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // * Personal Information Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _farmerIdController = TextEditingController();
  
  // * Farm Details Controllers
  final TextEditingController _farmLocationController = TextEditingController();
  final TextEditingController _landAreaController = TextEditingController();
  
  // * Focus Nodes
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _farmerIdFocus = FocusNode();
  final FocusNode _farmLocationFocus = FocusNode();
  final FocusNode _landAreaFocus = FocusNode();

  // * State Variables
  int _currentStep = 0;
  String? _selectedGender;
  String? _selectedExperienceLevel;
  String? _selectedOwnershipType;
  List<String> _selectedCrops = [];
  String? _selectedIrrigationType;
  bool _isFormValid = false;

  // * Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // * Form Data
  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _experienceLevels = ['New Farmer (0-2 years)', 'Experienced (3-10 years)', 'Expert (10+ years)'];
  final List<String> _ownershipTypes = ['Owner', 'Tenant', 'Sharecropper', 'Cooperative Member'];
  final List<String> _cropOptions = [
    'Rice', 'Wheat', 'Maize', 'Sugarcane', 'Cotton', 'Soybean', 
    'Groundnut', 'Pulses', 'Vegetables', 'Fruits', 'Spices', 'Other'
  ];
  final List<String> _irrigationTypes = ['Rain-fed', 'Bore well', 'Canal', 'Drip', 'Sprinkler', 'Other'];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _farmerIdController.dispose();
    _farmLocationController.dispose();
    _landAreaController.dispose();
    _fullNameFocus.dispose();
    _ageFocus.dispose();
    _farmerIdFocus.dispose();
    _farmLocationFocus.dispose();
    _landAreaFocus.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // * Animation Setup
  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // * Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  // * Setup listeners
  void _setupListeners() {
    _fullNameController.addListener(_validateForm);
    _ageController.addListener(_validateForm);
    _farmLocationController.addListener(_validateForm);
    _landAreaController.addListener(_validateForm);
  }

  // * Form validation
  void _validateForm() {
    final isValid = _fullNameController.text.trim().isNotEmpty &&
                   _ageController.text.trim().isNotEmpty &&
                   _farmLocationController.text.trim().isNotEmpty &&
                   _landAreaController.text.trim().isNotEmpty &&
                   _selectedGender != null &&
                   _selectedExperienceLevel != null &&
                   _selectedOwnershipType != null &&
                   _selectedCrops.isNotEmpty &&
                   _selectedIrrigationType != null;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  // * Navigate to next step
  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  // * Navigate to previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // * Complete profile setup
  void _completeSetup() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save profile data to backend
      
      // * Navigate to dashboard
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
      
      // * Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile setup completed successfully!'),
          backgroundColor: CropFreshColors.green30Primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0 
            ? IconButton(
                onPressed: _previousStep,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: colorScheme.onSurface,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: colorScheme.onSurface,
                ),
              ),
        title: Text(
          'Profile Setup',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // * Progress Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                  backgroundColor: CropFreshColors.background60Secondary,
                  valueColor: AlwaysStoppedAnimation<Color>(CropFreshColors.green30Primary),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              
              // * Step Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepIndicator(0, 'Personal Info'),
                    _buildStepIndicator(1, 'Farm Details'),
                    _buildStepIndicator(2, 'Review'),
                  ],
                ),
              ),
              
              // * Form Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPersonalInfoStep(),
                      _buildFarmDetailsStep(),
                      _buildReviewStep(),
                    ],
                  ),
                ),
              ),
              
              // * Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: CropFreshColors.green30Primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Previous',
                            style: TextStyle(
                              color: CropFreshColors.green30Primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      flex: _currentStep > 0 ? 1 : 2,
                      child: GradientButton(
                        onPressed: _canProceed() ? _nextStep : null,
                        text: _currentStep < 2 ? 'Next' : 'Complete Setup',
                        isLoading: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // * Check if can proceed to next step
  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _fullNameController.text.trim().isNotEmpty &&
               _ageController.text.trim().isNotEmpty &&
               _selectedGender != null &&
               _selectedExperienceLevel != null;
      case 1:
        return _farmLocationController.text.trim().isNotEmpty &&
               _landAreaController.text.trim().isNotEmpty &&
               _selectedOwnershipType != null &&
               _selectedCrops.isNotEmpty &&
               _selectedIrrigationType != null;
      case 2:
        return true;
      default:
        return false;
    }
  }

  // * Build step indicator
  Widget _buildStepIndicator(int step, String label) {
    final isActive = step <= _currentStep;
    final isCompleted = step < _currentStep;
    
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted 
                ? CropFreshColors.green30Primary
                : isActive 
                    ? CropFreshColors.green30Primary
                    : CropFreshColors.background60Secondary,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive 
                  ? CropFreshColors.green30Primary
                  : CropFreshColors.background60Secondary,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: isActive ? Colors.white : CropFreshColors.onBackground60Disabled,
            size: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isActive 
                ? CropFreshColors.onBackground60
                : CropFreshColors.onBackground60Disabled,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // * Personal Information Step
  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: CropFreshColors.onBackground60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us know you better for personalized farming recommendations',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
          const SizedBox(height: 32),
          
          // * Full Name
          CustomTextField(
            controller: _fullNameController,
            focusNode: _fullNameFocus,
            labelText: 'Full Name *',
            hintText: 'Enter your full name',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // * Age
          CustomTextField(
            controller: _ageController,
            focusNode: _ageFocus,
            labelText: 'Age *',
            hintText: 'Enter your age',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your age';
              }
              final age = int.tryParse(value!);
              if (age == null || age < 18 || age > 100) {
                return 'Please enter a valid age (18-100)';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // * Gender Selection
          _buildDropdownField(
            label: 'Gender',
            value: _selectedGender,
            items: _genderOptions,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
              _validateForm();
            },
            hint: 'Select your gender',
          ),
          
          const SizedBox(height: 20),
          
          // * Farming Experience
          _buildDropdownField(
            label: 'Farming Experience *',
            value: _selectedExperienceLevel,
            items: _experienceLevels,
            onChanged: (value) {
              setState(() {
                _selectedExperienceLevel = value;
              });
              _validateForm();
            },
            hint: 'Select your experience level',
          ),
          
          const SizedBox(height: 20),
          
          // * Farmer ID (Optional)
          CustomTextField(
            controller: _farmerIdController,
            focusNode: _farmerIdFocus,
            labelText: 'Farmer ID (Optional)',
            hintText: 'Government farmer ID if available',
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  // * Farm Details Step
  Widget _buildFarmDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Farm Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: CropFreshColors.onBackground60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about your farm to provide location-based services',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
          const SizedBox(height: 32),
          
          // * Farm Location
          CustomTextField(
            controller: _farmLocationController,
            focusNode: _farmLocationFocus,
            labelText: 'Farm Location *',
            hintText: 'Village, Taluk, District',
            keyboardType: TextInputType.streetAddress,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your farm location';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // * Land Area
          CustomTextField(
            controller: _landAreaController,
            focusNode: _landAreaFocus,
            labelText: 'Land Area (Hectares) *',
            hintText: 'Enter land area in hectares',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter land area';
              }
              final area = double.tryParse(value!);
              if (area == null || area <= 0) {
                return 'Please enter a valid land area';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 20),
          
          // * Ownership Type
          _buildDropdownField(
            label: 'Land Ownership Type *',
            value: _selectedOwnershipType,
            items: _ownershipTypes,
            onChanged: (value) {
              setState(() {
                _selectedOwnershipType = value;
              });
              _validateForm();
            },
            hint: 'Select ownership type',
          ),
          
          const SizedBox(height: 20),
          
          // * Primary Crops
          _buildMultiSelectField(
            label: 'Primary Crops *',
            selectedItems: _selectedCrops,
            allItems: _cropOptions,
            onChanged: (selectedCrops) {
              setState(() {
                _selectedCrops = selectedCrops;
              });
              _validateForm();
            },
            hint: 'Select crops you grow',
          ),
          
          const SizedBox(height: 20),
          
          // * Irrigation Type
          _buildDropdownField(
            label: 'Irrigation Type *',
            value: _selectedIrrigationType,
            items: _irrigationTypes,
            onChanged: (value) {
              setState(() {
                _selectedIrrigationType = value;
              });
              _validateForm();
            },
            hint: 'Select irrigation method',
          ),
        ],
      ),
    );
  }

  // * Review Step
  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: CropFreshColors.onBackground60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your information before completing setup',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
          const SizedBox(height: 32),
          
          // * Personal Information Review
          _buildReviewSection(
            title: 'Personal Information',
            items: [
              'Name: ${_fullNameController.text}',
              'Age: ${_ageController.text}',
              'Gender: ${_selectedGender ?? 'Not specified'}',
              'Experience: ${_selectedExperienceLevel ?? 'Not specified'}',
              if (_farmerIdController.text.isNotEmpty)
                'Farmer ID: ${_farmerIdController.text}',
            ],
          ),
          
          const SizedBox(height: 24),
          
          // * Farm Details Review
          _buildReviewSection(
            title: 'Farm Details',
            items: [
              'Location: ${_farmLocationController.text}',
              'Land Area: ${_landAreaController.text} hectares',
              'Ownership: ${_selectedOwnershipType ?? 'Not specified'}',
              'Primary Crops: ${_selectedCrops.join(', ')}',
              'Irrigation: ${_selectedIrrigationType ?? 'Not specified'}',
            ],
          ),
        ],
      ),
    );
  }

  // * Build review section
  Widget _buildReviewSection({required String title, required List<String> items}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CropFreshColors.background60Secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CropFreshColors.onBackground60,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CropFreshColors.onBackground60Secondary,
              ),
            ),
          )),
        ],
      ),
    );
  }

  // * Build dropdown field
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CropFreshColors.onBackground60Tertiary,
            ),
            filled: true,
            fillColor: CropFreshColors.background60Secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CropFreshColors.onBackground60,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // * Build multi-select field
  Widget _buildMultiSelectField({
    required String label,
    required List<String> selectedItems,
    required List<String> allItems,
    required Function(List<String>) onChanged,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showMultiSelectDialog(selectedItems, allItems, onChanged),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: CropFreshColors.background60Secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              selectedItems.isEmpty ? hint : selectedItems.join(', '),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: selectedItems.isEmpty 
                    ? CropFreshColors.onBackground60Tertiary
                    : CropFreshColors.onBackground60,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // * Show multi-select dialog
  void _showMultiSelectDialog(
    List<String> selectedItems,
    List<String> allItems,
    Function(List<String>) onChanged,
  ) {
    List<String> tempSelected = List.from(selectedItems);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Crops'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: allItems.map((item) {
              return CheckboxListTile(
                title: Text(item),
                value: tempSelected.contains(item),
                onChanged: (bool? checked) {
                  if (checked == true) {
                    if (!tempSelected.contains(item)) {
                      tempSelected.add(item);
                    }
                  } else {
                    tempSelected.remove(item);
                  }
                  (context as Element).markNeedsBuild();
                },
                activeColor: CropFreshColors.green30Primary,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: CropFreshColors.onBackground60Secondary),
            ),
          ),
          TextButton(
            onPressed: () {
              onChanged(tempSelected);
              Navigator.of(context).pop();
            },
            child: Text(
              'Done',
              style: TextStyle(color: CropFreshColors.green30Primary),
            ),
          ),
        ],
      ),
    );
  }
} 