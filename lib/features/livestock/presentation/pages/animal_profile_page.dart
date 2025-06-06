import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// * ANIMAL PROFILE PAGE
/// * Displays detailed information about a specific animal
/// * Includes health records, breeding history, and production data
class AnimalProfilePage extends StatefulWidget {
  final String animalId;

  const AnimalProfilePage({
    super.key,
    required this.animalId,
  });

  @override
  State<AnimalProfilePage> createState() => _AnimalProfilePageState();
}

class _AnimalProfilePageState extends State<AnimalProfilePage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: CustomAppBar(
        title: 'Animal Profile',
        backgroundColor: CropFreshColors.green30Primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // * Animal Header Information
          _buildAnimalHeader(),
          
          // * Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: CropFreshColors.green30Primary,
              labelColor: CropFreshColors.green30Primary,
              unselectedLabelColor: CropFreshColors.onBackground60Tertiary,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Health'),
                Tab(text: 'Breeding'),
                Tab(text: 'Production'),
              ],
            ),
          ),
          
          // * Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildHealthTab(),
                _buildBreedingTab(),
                _buildProductionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // * Animal Photo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CropFreshColors.green30Container,
            ),
            child: Icon(
              Icons.pets,
              size: 40,
              color: CropFreshColors.green30Primary,
            ),
          ),
          const SizedBox(width: 16),
          
          // * Animal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cow #${widget.animalId}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jersey Cross • 4 years old',
                  style: TextStyle(
                    fontSize: 14,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: CropFreshColors.green30Container,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Healthy',
                    style: TextStyle(
                      fontSize: 12,
                      color: CropFreshColors.green30Primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // * Actions
          IconButton(
            onPressed: () {
              // TODO: Implement edit functionality
            },
            icon: const Icon(Icons.edit),
            color: CropFreshColors.green30Primary,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Basic Information Card
          _buildInfoCard(
            'Basic Information',
            [
              _buildInfoRow('Tag Number', widget.animalId),
              _buildInfoRow('Breed', 'Jersey Cross'),
              _buildInfoRow('Age', '4 years'),
              _buildInfoRow('Weight', '450 kg'),
              _buildInfoRow('Purchase Date', '15 Jan 2020'),
              _buildInfoRow('Purchase Price', '₹35,000'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // * Current Status Card
          _buildInfoCard(
            'Current Status',
            [
              _buildInfoRow('Health', 'Healthy'),
              _buildInfoRow('Vaccination', 'Up to date'),
              _buildInfoRow('Last Checkup', '5 days ago'),
              _buildInfoRow('Milk Production', '12 L/day'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Records',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // TODO: Implement health records list
          const Center(
            child: Text('Health records will be displayed here'),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breeding History',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // TODO: Implement breeding history
          const Center(
            child: Text('Breeding history will be displayed here'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production Data',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // TODO: Implement production data charts
          const Center(
            child: Text('Production data will be displayed here'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 