// ===================================================================
// * BOOKING DETAILS PAGE
// * Purpose: Allow farmers to specify booking details for logistics
// * Features: Location selection, scheduling, load details, pricing
// * Security Level: Medium - Contains booking information
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Form controllers
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _deliveryAddressController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specialInstructionsController = TextEditingController();

  // Selected values
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedVehicleType = 'Pickup Truck';
  bool _requiresLoading = false;
  bool _requiresPackaging = false;
  bool _isFragile = false;

  final List<String> _vehicleTypes = [
    'Pickup Truck',
    'Mini Truck', 
    'Truck',
    'Tractor',
    'Reefer Truck',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Book Logistics',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // * Progress Indicator
          _buildProgressIndicator(),
          
          // * Form Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildLocationStep(),
                _buildScheduleStep(),
                _buildLoadDetailsStep(),
                _buildConfirmationStep(),
              ],
            ),
          ),
          
          // * Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(4, (index) {
          bool isActive = index <= _currentStep;
          bool isCurrent = index == _currentStep;
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getStepTitle(index),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                      color: isActive ? AppColors.primary : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  String _getStepTitle(int index) {
    switch (index) {
      case 0: return 'Location';
      case 1: return 'Schedule';
      case 2: return 'Details';
      case 3: return 'Confirm';
      default: return '';
    }
  }

  Widget _buildLocationStep() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pickup & Delivery Locations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // * Pickup Location
            const Text(
              'Pickup Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _pickupAddressController,
              decoration: InputDecoration(
                hintText: 'Enter pickup address',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pickup location';
                }
                return null;
              },
              maxLines: 2,
            ),
            
            const SizedBox(height: 24),
            
            // * Delivery Location
            const Text(
              'Delivery Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _deliveryAddressController,
              decoration: InputDecoration(
                hintText: 'Enter delivery address',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter delivery location';
                }
                return null;
              },
              maxLines: 2,
            ),
            
            const SizedBox(height: 24),
            
            // * Distance and Estimated Cost
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.route, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Estimated Distance: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Text('25.5 km'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Estimated Cost: ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '₹400 - ₹600',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Pickup',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // * Date Selection
          const Text(
            'Pickup Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select pickup date',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate != null ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // * Time Selection
          const Text(
            'Pickup Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectTime,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 12),
                  Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select pickup time',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedTime != null ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // * Vehicle Type Selection
          const Text(
            'Vehicle Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedVehicleType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            items: _vehicleTypes.map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            )).toList(),
            onChanged: (value) => setState(() => _selectedVehicleType = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Load Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // * Weight
          const Text(
            'Estimated Weight (kg)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter weight in kg',
              suffixText: 'kg',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // * Description
          const Text(
            'Load Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Describe what you are shipping',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
          
          const SizedBox(height: 24),
          
          // * Additional Services
          const Text(
            'Additional Services',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          CheckboxListTile(
            title: const Text('Loading Assistance'),
            subtitle: const Text('Help with loading at pickup'),
            value: _requiresLoading,
            onChanged: (value) => setState(() => _requiresLoading = value!),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          CheckboxListTile(
            title: const Text('Packaging Service'),
            subtitle: const Text('Professional packaging for fragile items'),
            value: _requiresPackaging,
            onChanged: (value) => setState(() => _requiresPackaging = value!),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          CheckboxListTile(
            title: const Text('Fragile Items'),
            subtitle: const Text('Special care required'),
            value: _isFragile,
            onChanged: (value) => setState(() => _isFragile = value!),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          const SizedBox(height: 24),
          
          // * Special Instructions
          const Text(
            'Special Instructions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _specialInstructionsController,
            decoration: InputDecoration(
              hintText: 'Any special handling instructions',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm Booking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // * Booking Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow('Pickup', _pickupAddressController.text),
                  const Divider(),
                  _buildSummaryRow('Delivery', _deliveryAddressController.text),
                  const Divider(),
                  _buildSummaryRow('Date & Time', 
                    _selectedDate != null && _selectedTime != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at ${_selectedTime!.format(context)}'
                        : 'Not selected'),
                  const Divider(),
                  _buildSummaryRow('Vehicle Type', _selectedVehicleType),
                  const Divider(),
                  _buildSummaryRow('Weight', '${_weightController.text} kg'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // * Cost Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cost Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCostRow('Base Rate (25.5 km)', '₹400'),
                  if (_requiresLoading) _buildCostRow('Loading Assistance', '₹100'),
                  if (_requiresPackaging) _buildCostRow('Packaging Service', '₹150'),
                  const Divider(),
                  _buildCostRow('Total', '₹${_calculateTotal()}', isTotal: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(String item, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Previous'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_currentStep == 3 ? 'Confirm Booking' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitBooking();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _getCurrentLocation() {
    // TODO: Implement GPS location detection
    _pickupAddressController.text = 'Current Location - Sample Address';
  }

  String _calculateTotal() {
    int total = 400; // Base rate
    if (_requiresLoading) total += 100;
    if (_requiresPackaging) total += 150;
    return total.toString();
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    
    try {
      // TODO: Submit booking to API
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _weightController.dispose();
    _descriptionController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }
} 