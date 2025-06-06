import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// * HEALTH TRACKING PAGE
/// * Complete animal health monitoring and medical records
/// * Features: Health logs, vaccination tracking, treatment records
class HealthTrackingPage extends StatefulWidget {
  final String animalId;
  
  const HealthTrackingPage({
    super.key,
    required this.animalId,
  });

  @override
  State<HealthTrackingPage> createState() => _HealthTrackingPageState();
}

class _HealthTrackingPageState extends State<HealthTrackingPage> {
  int _selectedTabIndex = 0;

  // Mock data for health records
  final List<Map<String, dynamic>> _healthRecords = [
    {
      'type': 'Vaccination',
      'description': 'FMD Vaccination',
      'date': '2024-12-10',
      'vet': 'Dr. Suresh Kumar',
      'notes': 'Annual FMD vaccination completed successfully',
      'status': 'Completed',
    },
    {
      'type': 'Checkup',
      'description': 'Routine Health Checkup',
      'date': '2024-12-08',
      'vet': 'Dr. Priya Sharma',
      'notes': 'General health is good, recommended increased nutrition',
      'status': 'Completed',
    },
    {
      'type': 'Treatment',
      'description': 'Minor Wound Treatment',
      'date': '2024-12-05',
      'vet': 'Dr. Ravi Patel',
      'notes': 'Small cut on leg, applied antiseptic and bandage',
      'status': 'Ongoing',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: AppBar(
        title: Text('Health Tracking - ${widget.animalId}'),
        backgroundColor: CropFreshColors.green30Primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHealthRecord,
        backgroundColor: CropFreshColors.green30Primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Overview', 'Records', 'Vaccinations', 'Treatments'];
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildRecordsTab();
      case 2:
        return _buildVaccinationsTab();
      case 3:
        return _buildTreatmentsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHealthStatusOverview(),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildHealthStatusOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pets,
                size: 24,
                color: CropFreshColors.green30Primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Animal #${widget.animalId}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // * Health Status Cards
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Overall Health',
                  'Healthy',
                  Icons.favorite,
                  CropFreshColors.green30Primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Last Checkup',
                  '5 days ago',
                  Icons.calendar_today,
                  CropFreshColors.orange10Primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Vaccinations',
                  'Up to date',
                  Icons.vaccines,
                  CropFreshColors.green30Primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Treatments',
                  '3 this month',
                  Icons.medical_services,
                  CropFreshColors.orange10Primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._healthRecords.take(3).map((record) => _buildActivityItem(record)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> record) {
    IconData icon;
    Color iconColor;
    
    switch (record['type']) {
      case 'Vaccination':
        icon = Icons.vaccines;
        iconColor = CropFreshColors.green30Primary;
        break;
      case 'Checkup':
        icon = Icons.medical_services;
        iconColor = CropFreshColors.orange10Primary;
        break;
      case 'Treatment':
        icon = Icons.healing;
        iconColor = CropFreshColors.orange10Primary;
        break;
      default:
        icon = Icons.health_and_safety;
        iconColor = CropFreshColors.onBackground60Secondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record['type']} • ${record['date']}',
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

  Widget _buildRecordsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _healthRecords.length,
      itemBuilder: (context, index) {
        final record = _healthRecords[index];
        return _buildHealthRecordCard(record);
      },
    );
  }

  Widget _buildHealthRecordCard(Map<String, dynamic> record) {
    IconData icon;
    Color iconColor;
    
    switch (record['type']) {
      case 'Vaccination':
        icon = Icons.vaccines;
        iconColor = CropFreshColors.green30Primary;
        break;
      case 'Checkup':
        icon = Icons.medical_services;
        iconColor = CropFreshColors.orange10Primary;
        break;
      case 'Treatment':
        icon = Icons.healing;
        iconColor = CropFreshColors.orange10Primary;
        break;
      default:
        icon = Icons.health_and_safety;
        iconColor = CropFreshColors.onBackground60Secondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showHealthRecordDetail(record),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record['description'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${record['type']} • ${record['date']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: CropFreshColors.onBackground60Secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By ${record['vet']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: CropFreshColors.onBackground60Tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CropFreshColors.green30Primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  record['status'],
                  style: TextStyle(
                    color: CropFreshColors.green30Primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVaccinationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVaccinationCard('FMD Vaccine', 'Due in 2 weeks', false),
        _buildVaccinationCard('Deworming', 'Completed', true),
        _buildVaccinationCard('HS Vaccine', 'Due in 6 weeks', false),
      ],
    );
  }

  Widget _buildVaccinationCard(String vaccine, String status, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.schedule,
            color: isCompleted 
                ? CropFreshColors.green30Primary 
                : CropFreshColors.orange10Primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccine,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsTab() {
    return const Center(
      child: Text('Treatment records will be implemented here'),
    );
  }

  void _showHealthRecordDetail(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record['description']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${record['type']}'),
            Text('Date: ${record['date']}'),
            Text('Veterinarian: ${record['vet']}'),
            const SizedBox(height: 8),
            Text('Notes: ${record['notes']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addHealthRecord() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Health Record'),
        content: const Text('Health record form will be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement add health record
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 