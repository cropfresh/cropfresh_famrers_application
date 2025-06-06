import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';

/// * VETERINARY MAIN PAGE
/// * Features: Vet discovery, service selection, appointment booking
class VeterinaryMainPage extends StatefulWidget {
  const VeterinaryMainPage({super.key});

  @override
  State<VeterinaryMainPage> createState() => _VeterinaryMainPageState();
}

class _VeterinaryMainPageState extends State<VeterinaryMainPage>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Surface,
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVetDiscovery(),
          _buildMyAppointments(),
          _buildEmergencyServices(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bookEmergencyService,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.emergency),
        label: const Text('Emergency'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Veterinary Services',
        style: TextStyle(
          color: CropFreshColors.green30Forest,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: CropFreshColors.background60Surface,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        labelColor: CropFreshColors.green30Forest,
        unselectedLabelColor: CropFreshColors.onBackground60Secondary,
        indicatorColor: CropFreshColors.green10Primary,
        tabs: const [
          Tab(text: 'Find Vet', icon: Icon(Icons.local_hospital_outlined)),
          Tab(text: 'Appointments', icon: Icon(Icons.schedule_outlined)),
          Tab(text: 'Emergency', icon: Icon(Icons.emergency_outlined)),
        ],
      ),
    );
  }

  Widget _buildVetDiscovery() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchFilters(),
          const SizedBox(height: 16),
          Text(
            'Available Veterinarians',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockVets.length,
              itemBuilder: (context, index) {
                return _buildVetCard(_mockVets[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CropFreshColors.outline30Variant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Service',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Consultation', Icons.chat_outlined),
              _buildFilterChip('Vaccination', Icons.vaccines_outlined),
              _buildFilterChip('AI Services', Icons.pets_outlined),
              _buildFilterChip('Surgery', Icons.healing_outlined),
              _buildFilterChip('Emergency', Icons.emergency_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        // TODO: Implement filter logic
      },
      backgroundColor: CropFreshColors.outline30Variant.withValues(alpha: 0.1),
      selectedColor: CropFreshColors.green10Container,
      checkmarkColor: CropFreshColors.green30Forest,
    );
  }

  Widget _buildVetCard(Map<String, dynamic> vet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: CropFreshColors.green10Container,
                  child: Icon(
                    Icons.local_hospital,
                    color: CropFreshColors.green30Forest,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vet['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vet['qualification'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: CropFreshColors.orange10Primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${vet['rating']} (${vet['reviews']} reviews)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (vet['isAvailable'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CropFreshColors.green10Container,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Available',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: CropFreshColors.green30Forest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Specialization: ${vet['specialization']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: CropFreshColors.onBackground60Secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${vet['distance']} km away',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Consultation: ₹${vet['consultationFee']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.orange10Primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: (vet['services'] as List<String>).map((service) {
                return Chip(
                  label: Text(service),
                  backgroundColor: CropFreshColors.outline30Variant.withValues(alpha: 0.1),
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewVetProfile(vet),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CropFreshColors.green10Primary,
                      side: BorderSide(color: CropFreshColors.green10Primary),
                    ),
                    child: const Text('View Profile'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _bookAppointment(vet),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CropFreshColors.green10Primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyAppointments() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Appointments',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _mockAppointments.isEmpty
                ? _buildEmptyAppointments()
                : ListView.builder(
                    itemCount: _mockAppointments.length,
                    itemBuilder: (context, index) {
                      return _buildAppointmentCard(_mockAppointments[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment['vetName'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(appointment['status']),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Service: ${appointment['serviceType']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: CropFreshColors.onBackground60Secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  appointment['dateTime'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (appointment['animals'] != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.pets,
                    size: 16,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Animals: ${appointment['animals']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CropFreshColors.onBackground60Secondary,
                    ),
                  ),
                ],
              ),
            ],
            if (appointment['status'] == 'Completed') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _viewConsultationNotes(appointment),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CropFreshColors.green10Primary,
                    side: BorderSide(color: CropFreshColors.green10Primary),
                  ),
                  child: const Text('View Notes'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = CropFreshColors.green10Primary;
        break;
      case 'Scheduled':
        color = CropFreshColors.orange10Primary;
        break;
      case 'In Progress':
        color = Colors.blue;
        break;
      default:
        color = CropFreshColors.onBackground60Secondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmergencyServices() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.emergency,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                Text(
                  'Emergency Veterinary Services',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '24/7 emergency services available for critical animal health situations',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _bookEmergencyService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Call Emergency Vet'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Emergency Contacts',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _emergencyContacts.length,
              itemBuilder: (context, index) {
                return _buildEmergencyContactCard(_emergencyContacts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(Map<String, dynamic> contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade100,
          child: Icon(Icons.emergency, color: Colors.red),
        ),
        title: Text(
          contact['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact['location']),
        trailing: IconButton(
          onPressed: () => _callEmergencyContact(contact['phone']),
          icon: const Icon(Icons.phone, color: Colors.green),
        ),
      ),
    );
  }

  Widget _buildEmptyAppointments() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 64,
            color: CropFreshColors.onBackground60Secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first veterinary consultation',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _viewVetProfile(Map<String, dynamic> vet) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to vet profile screen
  }

  void _bookAppointment(Map<String, dynamic> vet) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to appointment booking screen
    Navigator.pushNamed(context, '/veterinary/book', arguments: vet);
  }

  void _viewConsultationNotes(Map<String, dynamic> appointment) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to consultation notes screen
  }

  void _bookEmergencyService() {
    HapticFeedback.heavyImpact();
    // TODO: Show emergency booking dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Service'),
        content: const Text('Are you sure you need emergency veterinary service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Book emergency service
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Emergency'),
          ),
        ],
      ),
    );
  }

  void _callEmergencyContact(String phone) {
    HapticFeedback.lightImpact();
    // TODO: Launch phone dialer
  }

  // * MOCK DATA
  final List<Map<String, dynamic>> _mockVets = [
    {
      'id': '1',
      'name': 'Dr. Rajesh Kumar',
      'qualification': 'BVSc & AH, MVSc',
      'specialization': 'Large Animals, AI Specialist',
      'rating': 4.8,
      'reviews': 125,
      'distance': 3.2,
      'consultationFee': 300,
      'isAvailable': true,
      'services': ['Consultation', 'Vaccination', 'AI Services'],
    },
    {
      'id': '2',
      'name': 'Dr. Priya Sharma',
      'qualification': 'BVSc & AH',
      'specialization': 'Small Animals, Surgery',
      'rating': 4.6,
      'reviews': 89,
      'distance': 5.8,
      'consultationFee': 250,
      'isAvailable': false,
      'services': ['Surgery', 'Consultation', 'Emergency'],
    },
  ];

  final List<Map<String, dynamic>> _mockAppointments = [
    {
      'vetName': 'Dr. Rajesh Kumar',
      'serviceType': 'Vaccination',
      'dateTime': '25 Jan 2024, 2:00 PM',
      'animals': 'Cow #C001, Cow #C002',
      'status': 'Scheduled',
    },
    {
      'vetName': 'Dr. Priya Sharma',
      'serviceType': 'Health Checkup',
      'dateTime': '20 Jan 2024, 10:00 AM',
      'animals': 'Buffalo #B001',
      'status': 'Completed',
    },
  ];

  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'name': 'Emergency Vet Clinic',
      'location': 'City Center',
      'phone': '+91-9876543210',
    },
    {
      'name': '24/7 Animal Hospital',
      'location': 'Highway Road',
      'phone': '+91-9876543211',
    },
  ];
} 