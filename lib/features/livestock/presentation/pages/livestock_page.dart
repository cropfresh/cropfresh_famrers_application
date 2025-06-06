import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import 'animal_profile_page.dart';
import 'health_tracking_page.dart';

/// * LIVESTOCK MANAGEMENT PAGE
/// * Comprehensive animal inventory and health management
/// * Features: Animal registry, health tracking, breeding records
class LivestockPage extends StatefulWidget {
  const LivestockPage({super.key});

  @override
  State<LivestockPage> createState() => _LivestockPageState();
}

class _LivestockPageState extends State<LivestockPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'Livestock Management',
        backgroundColor: CropFreshColors.green30Primary,
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
        onPressed: _addNewAnimal,
        backgroundColor: CropFreshColors.green30Primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = ['Animals', 'Health', 'Breeding', 'Production'];
    
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
        return _buildAnimalsTab();
      case 1:
        return _buildHealthTab();
      case 2:
        return _buildBreedingTab();
      case 3:
        return _buildProductionTab();
      default:
        return _buildAnimalsTab();
    }
  }

  Widget _buildAnimalsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // * Statistics Overview
          _buildStatisticsOverview(),
          
          // * Animal List
          _buildAnimalList(),
        ],
      ),
    );
  }

  Widget _buildStatisticsOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
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
          const Text(
            'Livestock Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Total', '12', Icons.pets),
              const SizedBox(width: 16),
              _buildStatCard('Healthy', '10', Icons.favorite),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Milking', '6', Icons.water_drop),
              const SizedBox(width: 16),
              _buildStatCard('Pregnant', '2', Icons.pregnant_woman),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon, [Color? color]) {
    Color effectiveColor;
    if (color != null) {
      effectiveColor = color;
    } else {
      switch (label) {
        case 'Healthy':
        case 'Healthy Animals':
          effectiveColor = CropFreshColors.green30Primary;
          break;
        case 'Milking':
          effectiveColor = CropFreshColors.orange10Primary;
          break;
        case 'Pregnant':
          effectiveColor = CropFreshColors.green30Primary;
          break;
        default:
          effectiveColor = CropFreshColors.onBackground60Secondary;
      }
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color != null ? color.withValues(alpha: 0.1) : CropFreshColors.green30Container,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: effectiveColor,
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: effectiveColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: CropFreshColors.onBackground60Secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: 5, // Mock data
      itemBuilder: (context, index) {
        return _buildAnimalCard(index);
      },
    );
  }

  Widget _buildAnimalCard(int index) {
    final animals = [
      {'id': 'COW001', 'type': 'Cow', 'breed': 'Jersey', 'age': '4y', 'health': 'Healthy'},
      {'id': 'COW002', 'type': 'Cow', 'breed': 'HF', 'age': '3y', 'health': 'Healthy'},
      {'id': 'BUF001', 'type': 'Buffalo', 'breed': 'Murrah', 'age': '5y', 'health': 'Pregnant'},
      {'id': 'COW003', 'type': 'Cow', 'breed': 'Local', 'age': '2y', 'health': 'Treatment'},
      {'id': 'BUF002', 'type': 'Buffalo', 'breed': 'Local', 'age': '6y', 'health': 'Healthy'},
    ];

    final animal = animals[index];
    
    Color statusColor;
    switch (animal['health']) {
      case 'Healthy':
        statusColor = CropFreshColors.green30Primary;
        break;
      case 'Pregnant':
        statusColor = CropFreshColors.orange10Primary;
        break;
      case 'Treatment':
        statusColor = CropFreshColors.errorPrimary;
        break;
      default:
        statusColor = CropFreshColors.onBackground60Secondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToAnimalProfile(animal['id']!),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // * Animal Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: CropFreshColors.green30Container,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getAnimalIcon(animal['type']!),
                    color: CropFreshColors.green30Primary,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // * Animal Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            animal['id']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              animal['health']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${animal['type']} • ${animal['breed']} • ${animal['age']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // * Action Buttons
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _navigateToHealthTracking(animal['id']!),
                      icon: Icon(
                        Icons.health_and_safety,
                        color: CropFreshColors.green30Primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: CropFreshColors.onBackground60Tertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAnimalIcon(String type) {
    switch (type.toLowerCase()) {
      case 'cow':
        return Icons.pets;
      case 'buffalo':
        return Icons.pets;
      case 'goat':
        return Icons.pets;
      case 'sheep':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }

  Widget _buildHealthTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // * Health Summary
        Container(
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
              const Text(
                'Health Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard('Total Animals', '3', Icons.pets, CropFreshColors.green30Primary),
                  const SizedBox(width: 16),
                  _buildStatCard('Healthy Animals', '2', Icons.favorite, CropFreshColors.green30Primary),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // * Recent Health Events
        Container(
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
              const Text(
                'Recent Health Events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildHealthEventCard('COW001', 'Vaccination', '2 days ago'),
              _buildHealthEventCard('BUF001', 'Health Checkup', '1 week ago'),
              _buildHealthEventCard('COW002', 'Treatment', '2 weeks ago'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthEventCard(String animalId, String event, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.health_and_safety,
            color: CropFreshColors.green30Primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$animalId - $event',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingTab() {
    return const Center(
      child: Text('Breeding records will be implemented here'),
    );
  }

  Widget _buildProductionTab() {
    return const Center(
      child: Text('Production data will be implemented here'),
    );
  }

  void _addNewAnimal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Animal'),
        content: const Text('Animal registration form will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToAnimalProfile(String animalId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalProfilePage(animalId: animalId),
      ),
    );
  }

  void _navigateToHealthTracking(String animalId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HealthTrackingPage(animalId: animalId),
      ),
    );
  }
} 