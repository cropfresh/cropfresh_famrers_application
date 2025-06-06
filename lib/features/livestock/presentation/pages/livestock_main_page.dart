import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';

/// * LIVESTOCK MAIN PAGE
/// * Features: Animal inventory, health tracking, breeding management
class LivestockMainPage extends StatefulWidget {
  const LivestockMainPage({super.key});

  @override
  State<LivestockMainPage> createState() => _LivestockMainPageState();
}

class _LivestockMainPageState extends State<LivestockMainPage>
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
          _buildAnimalInventory(),
          _buildHealthTracking(),
          _buildBreedingManagement(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewAnimal,
        backgroundColor: CropFreshColors.green10Primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Livestock Management',
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
          Tab(text: 'Animals', icon: Icon(Icons.pets_outlined)),
          Tab(text: 'Health', icon: Icon(Icons.health_and_safety_outlined)),
          Tab(text: 'Breeding', icon: Icon(Icons.favorite_outline)),
        ],
      ),
    );
  }

  Widget _buildAnimalInventory() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInventorySummary(),
          const SizedBox(height: 16),
          _buildAnimalTypeFilter(),
          const SizedBox(height: 16),
          Text(
            'Your Animals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockAnimals.length,
              itemBuilder: (context, index) {
                return _buildAnimalCard(_mockAnimals[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CropFreshColors.green10Container,
            CropFreshColors.green30Container,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventory Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Total Animals', '25', Icons.pets),
              ),
              Expanded(
                child: _buildSummaryItem('Healthy', '23', Icons.health_and_safety),
              ),
              Expanded(
                child: _buildSummaryItem('Need Care', '2', Icons.medical_services),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: CropFreshColors.green30Forest,
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: CropFreshColors.green30Forest,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.green30Forest,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnimalTypeFilter() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', true),
          _buildFilterChip('Cattle', false),
          _buildFilterChip('Buffalo', false),
          _buildFilterChip('Goats', false),
          _buildFilterChip('Poultry', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // TODO: Implement filter logic
        },
        backgroundColor: CropFreshColors.outline30Variant.withValues(alpha: 0.1),
        selectedColor: CropFreshColors.green10Container,
        checkmarkColor: CropFreshColors.green30Forest,
      ),
    );
  }

  Widget _buildAnimalCard(Map<String, dynamic> animal) {
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
                  radius: 25,
                  backgroundColor: CropFreshColors.green10Container,
                  child: Icon(
                    _getAnimalIcon(animal['type']),
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
                        animal['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${animal['type']} • ${animal['breed']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                      Text(
                        'Tag: ${animal['tagNumber']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildHealthStatusChip(animal['healthStatus']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem('Age', animal['age']),
                ),
                Expanded(
                  child: _buildInfoItem('Weight', '${animal['weight']} kg'),
                ),
                Expanded(
                  child: _buildInfoItem('Gender', animal['gender']),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewAnimalProfile(animal),
                    icon: const Icon(Icons.visibility),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CropFreshColors.green10Primary,
                      side: BorderSide(color: CropFreshColors.green10Primary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _recordHealthEvent(animal),
                    icon: const Icon(Icons.health_and_safety),
                    label: const Text('Health'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CropFreshColors.green10Primary,
                      foregroundColor: Colors.white,
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

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.onBackground60Secondary,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Healthy':
        color = CropFreshColors.green10Primary;
        break;
      case 'Sick':
        color = Colors.red;
        break;
      case 'Under Treatment':
        color = CropFreshColors.orange10Primary;
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

  Widget _buildHealthTracking() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthSummary(),
          const SizedBox(height: 16),
          Text(
            'Recent Health Records',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockHealthRecords.length,
              itemBuilder: (context, index) {
                return _buildHealthRecordCard(_mockHealthRecords[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummary() {
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
            'Health Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHealthSummaryItem('Vaccinations Due', '3', Colors.orange),
              ),
              Expanded(
                child: _buildHealthSummaryItem('Under Treatment', '2', Colors.red),
              ),
              Expanded(
                child: _buildHealthSummaryItem('Health Checkups', '5', Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHealthRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getHealthRecordColor(record['type']).withValues(alpha: 0.1),
          child: Icon(
            _getHealthRecordIcon(record['type']),
            color: _getHealthRecordColor(record['type']),
          ),
        ),
        title: Text(
          record['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Animal: ${record['animalName']}'),
            Text('Date: ${record['date']}'),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _viewHealthRecord(record),
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  Widget _buildBreedingManagement() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breeding Management',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildBreedingSummary(),
          const SizedBox(height: 16),
          Text(
            'Breeding Records',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockBreedingRecords.length,
              itemBuilder: (context, index) {
                return _buildBreedingRecordCard(_mockBreedingRecords[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.orange10Container.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CropFreshColors.orange10Primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildBreedingSummaryItem('Pregnant', '4', Icons.pregnant_woman),
          ),
          Expanded(
            child: _buildBreedingSummaryItem('Expected Calving', '2', Icons.calendar_today),
          ),
          Expanded(
            child: _buildBreedingSummaryItem('Ready for AI', '3', Icons.favorite),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingSummaryItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: CropFreshColors.orange10Primary,
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: CropFreshColors.orange10Primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.orange10Primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBreedingRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: CropFreshColors.orange10Container,
          child: Icon(
            Icons.favorite,
            color: CropFreshColors.orange10Primary,
          ),
        ),
        title: Text(
          record['animalName'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${record['status']}'),
            Text('Date: ${record['date']}'),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _viewBreedingRecord(record),
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  IconData _getAnimalIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cattle':
        return Icons.pets;
      case 'buffalo':
        return Icons.pets;
      case 'goat':
        return Icons.pets;
      case 'poultry':
        return Icons.flutter_dash;
      default:
        return Icons.pets;
    }
  }

  IconData _getHealthRecordIcon(String type) {
    switch (type) {
      case 'vaccination':
        return Icons.vaccines;
      case 'treatment':
        return Icons.medical_services;
      case 'checkup':
        return Icons.health_and_safety;
      default:
        return Icons.medical_information;
    }
  }

  Color _getHealthRecordColor(String type) {
    switch (type) {
      case 'vaccination':
        return CropFreshColors.green10Primary;
      case 'treatment':
        return Colors.red;
      case 'checkup':
        return Colors.blue;
      default:
        return CropFreshColors.onBackground60Secondary;
    }
  }

  void _addNewAnimal() {
    HapticFeedback.lightImpact();
    // TODO: Navigate to add animal screen
    Navigator.pushNamed(context, '/livestock/add-animal');
  }

  void _viewAnimalProfile(Map<String, dynamic> animal) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to animal profile screen
    Navigator.pushNamed(context, '/livestock/animal-profile', arguments: animal);
  }

  void _recordHealthEvent(Map<String, dynamic> animal) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to health record screen
    Navigator.pushNamed(context, '/livestock/health-record', arguments: animal);
  }

  void _viewHealthRecord(Map<String, dynamic> record) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to health record detail screen
  }

  void _viewBreedingRecord(Map<String, dynamic> record) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to breeding record detail screen
  }

  // * MOCK DATA
  final List<Map<String, dynamic>> _mockAnimals = [
    {
      'id': '1',
      'name': 'Lakshmi',
      'type': 'Cattle',
      'breed': 'Holstein Friesian',
      'tagNumber': 'C001',
      'age': '3 years',
      'weight': 450,
      'gender': 'Female',
      'healthStatus': 'Healthy',
    },
    {
      'id': '2',
      'name': 'Ganga',
      'type': 'Buffalo',
      'breed': 'Murrah',
      'tagNumber': 'B001',
      'age': '4 years',
      'weight': 520,
      'gender': 'Female',
      'healthStatus': 'Under Treatment',
    },
    {
      'id': '3',
      'name': 'Raja',
      'type': 'Goat',
      'breed': 'Boer',
      'tagNumber': 'G001',
      'age': '2 years',
      'weight': 35,
      'gender': 'Male',
      'healthStatus': 'Healthy',
    },
  ];

  final List<Map<String, dynamic>> _mockHealthRecords = [
    {
      'title': 'FMD Vaccination',
      'type': 'vaccination',
      'animalName': 'Lakshmi',
      'date': '20 Jan 2024',
    },
    {
      'title': 'Mastitis Treatment',
      'type': 'treatment',
      'animalName': 'Ganga',
      'date': '18 Jan 2024',
    },
    {
      'title': 'Health Checkup',
      'type': 'checkup',
      'animalName': 'Raja',
      'date': '15 Jan 2024',
    },
  ];

  final List<Map<String, dynamic>> _mockBreedingRecords = [
    {
      'animalName': 'Lakshmi',
      'status': 'Pregnant',
      'date': '15 Dec 2023',
    },
    {
      'animalName': 'Ganga',
      'status': 'AI Scheduled',
      'date': '25 Jan 2024',
    },
  ];
} 