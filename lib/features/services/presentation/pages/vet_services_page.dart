import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// * VETERINARY SERVICES PAGE
/// * Features: Vet discovery, appointment booking, animal health records
class VetServicesPage extends StatefulWidget {
  const VetServicesPage({super.key});

  @override
  State<VetServicesPage> createState() => _VetServicesPageState();
}

class _VetServicesPageState extends State<VetServicesPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: AppBar(
        title: const Text('Veterinary Services'),
        backgroundColor: CropFreshColors.green30Primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: _buildTabContent(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bookEmergencyConsultation,
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = ['Find Vets', 'Book Appointment', 'My Appointments', 'Emergency'];
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = _selectedTabIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? CropFreshColors.green30Primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : CropFreshColors.onBackground60Secondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildFindVetsTab();
      case 1:
        return _buildBookAppointmentTab();
      case 2:
        return _buildMyAppointmentsTab();
      case 3:
        return _buildEmergencyTab();
      default:
        return _buildFindVetsTab();
    }
  }

  Widget _buildFindVetsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVetCard(
          name: 'Dr. Suresh Kumar',
          specialization: 'Large Animals',
          rating: 4.8,
          distance: '3.5 km',
          experience: '15 years',
          consultationFee: '₹500',
          isAvailable: true,
        ),
        _buildVetCard(
          name: 'Dr. Priya Sharma',
          specialization: 'Poultry & Small Animals',
          rating: 4.7,
          distance: '7.2 km',
          experience: '12 years',
          consultationFee: '₹400',
          isAvailable: false,
        ),
        _buildVetCard(
          name: 'Dr. Ravi Patel',
          specialization: 'AI Specialist',
          rating: 4.9,
          distance: '5.8 km',
          experience: '20 years',
          consultationFee: '₹600',
          isAvailable: true,
        ),
      ],
    );
  }

  Widget _buildVetCard({
    required String name,
    required String specialization,
    required double rating,
    required String distance,
    required String experience,
    required String consultationFee,
    required bool isAvailable,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization,
                      style: TextStyle(
                        color: CropFreshColors.onBackground60Secondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAvailable 
                      ? CropFreshColors.green30Container 
                      : CropFreshColors.orange10Container,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAvailable ? 'Available' : 'Busy',
                  style: TextStyle(
                    color: isAvailable 
                        ? CropFreshColors.green30Primary 
                        : CropFreshColors.orange10Primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              Icon(Icons.location_on, size: 16, color: CropFreshColors.onBackground60Secondary),
              const SizedBox(width: 4),
              Text(
                distance,
                style: TextStyle(
                  color: CropFreshColors.onBackground60Secondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.work, size: 16, color: CropFreshColors.onBackground60Secondary),
              const SizedBox(width: 4),
              Text(
                experience,
                style: TextStyle(
                  color: CropFreshColors.onBackground60Secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultation Fee',
                    style: TextStyle(
                      color: CropFreshColors.onBackground60Secondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    consultationFee,
                    style: TextStyle(
                      color: CropFreshColors.green30Primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: isAvailable ? () {
                  // ! TODO: Navigate to appointment booking
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CropFreshColors.green30Primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Book Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookAppointmentTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book Veterinary Appointment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildServiceTypeSelector(),
          const SizedBox(height: 20),
          _buildAnimalSelector(),
          const SizedBox(height: 20),
          _buildUrgencySelector(),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                // ! TODO: Navigate to vet selection with filters
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CropFreshColors.green30Primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Find Available Vets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeSelector() {
    final services = [
      'General Consultation',
      'Vaccination',
      'Artificial Insemination',
      'Emergency Care',
      'Surgery',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: services.map((service) => FilterChip(
            label: Text(service),
            selected: false,
            onSelected: (selected) {
              // ! TODO: Handle service selection
            },
            backgroundColor: CropFreshColors.background60Card,
            selectedColor: CropFreshColors.green30Container,
            checkmarkColor: CropFreshColors.green30Primary,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildAnimalSelector() {
    final animals = [
      'Cattle',
      'Buffalo',
      'Goat',
      'Sheep',
      'Poultry',
      'Other',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Animal Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: animals.map((animal) => FilterChip(
            label: Text(animal),
            selected: false,
            onSelected: (selected) {
              // ! TODO: Handle animal selection
            },
            backgroundColor: CropFreshColors.background60Card,
            selectedColor: CropFreshColors.green30Container,
            checkmarkColor: CropFreshColors.green30Primary,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildUrgencySelector() {
    final urgencies = [
      'Normal',
      'Urgent',
      'Emergency',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Urgency Level',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: urgencies.map((urgency) {
            Color color = CropFreshColors.green30Primary;
            if (urgency == 'Urgent') color = CropFreshColors.orange10Primary;
            if (urgency == 'Emergency') color = Colors.red;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(urgency),
                  selected: false,
                  onSelected: (selected) {
                    // ! TODO: Handle urgency selection
                  },
                  backgroundColor: CropFreshColors.background60Card,
                  selectedColor: color.withValues(alpha: 0.2),
                  checkmarkColor: color,
                  labelStyle: TextStyle(color: color),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMyAppointmentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAppointmentCard(
          appointmentId: 'VET001',
          vetName: 'Dr. Suresh Kumar',
          date: '20 Dec 2024',
          time: '10:00 AM',
          service: 'General Consultation',
          animal: 'Cattle',
          status: 'Confirmed',
        ),
        _buildAppointmentCard(
          appointmentId: 'VET002',
          vetName: 'Dr. Priya Sharma',
          date: '18 Dec 2024',
          time: '2:00 PM',
          service: 'Vaccination',
          animal: 'Goat',
          status: 'Completed',
        ),
        _buildAppointmentCard(
          appointmentId: 'VET003',
          vetName: 'Dr. Ravi Patel',
          date: '22 Dec 2024',
          time: '9:00 AM',
          service: 'Artificial Insemination',
          animal: 'Buffalo',
          status: 'Pending',
        ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required String appointmentId,
    required String vetName,
    required String date,
    required String time,
    required String service,
    required String animal,
    required String status,
  }) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'Confirmed':
        statusColor = CropFreshColors.green30Primary;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = CropFreshColors.orange10Primary;
        statusIcon = Icons.pending;
        break;
      case 'Completed':
        statusColor = Colors.blue;
        statusIcon = Icons.task_alt;
        break;
      default:
        statusColor = CropFreshColors.onBackground60Secondary;
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: $appointmentId',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Vet: $vetName',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Date: $date at $time',
            style: TextStyle(
              color: CropFreshColors.onBackground60Secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Service: $service',
            style: TextStyle(
              color: CropFreshColors.onBackground60Secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Animal: $animal',
            style: TextStyle(
              color: CropFreshColors.onBackground60Secondary,
              fontSize: 14,
            ),
          ),
          if (status == 'Confirmed') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ! TODO: Cancel appointment
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ! TODO: Reschedule appointment
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CropFreshColors.orange10Primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: const Column(
              children: [
                Icon(Icons.emergency, size: 48, color: Colors.red),
                SizedBox(height: 12),
                Text(
                  'Emergency Veterinary Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '24/7 Emergency care for your animals',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Emergency Contacts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildEmergencyContact(
            name: 'Dr. Emergency Clinic',
            phone: '+91 9876543210',
            availability: '24/7',
            distance: '2.1 km',
          ),
          _buildEmergencyContact(
            name: 'Animal Hospital Emergency',
            phone: '+91 9876543211',
            availability: '24/7',
            distance: '4.5 km',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _bookEmergencyConsultation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Book Emergency Consultation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact({
    required String name,
    required String phone,
    required String availability,
    required String distance,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Available: $availability',
                  style: TextStyle(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Distance: $distance',
                  style: TextStyle(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // ! TODO: Make phone call
            },
            icon: const Icon(Icons.phone, size: 16),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bookEmergencyConsultation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Consultation'),
        content: const Text(
          'Are you sure you need emergency veterinary care? '
          'This service is for urgent animal health issues only.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // ! TODO: Navigate to emergency booking
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
} 