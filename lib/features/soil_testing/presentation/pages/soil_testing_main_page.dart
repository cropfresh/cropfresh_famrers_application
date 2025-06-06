import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../../shared/widgets/loading_indicator.dart';

/// * SOIL TESTING MAIN PAGE
/// * Features: Lab discovery, test packages, booking management
class SoilTestingMainPage extends StatefulWidget {
  const SoilTestingMainPage({super.key});

  @override
  State<SoilTestingMainPage> createState() => _SoilTestingMainPageState();
}

class _SoilTestingMainPageState extends State<SoilTestingMainPage>
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
      appBar: _buildAppBar(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLabDiscovery(),
          _buildTestPackages(), 
          _buildMyTests(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Soil Testing',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
          Tab(text: 'Labs', icon: Icon(Icons.science_outlined)),
          Tab(text: 'Test Packages', icon: Icon(Icons.analytics_outlined)),
          Tab(text: 'My Tests', icon: Icon(Icons.assignment_outlined)),
        ],
      ),
    );
  }

  Widget _buildLabDiscovery() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Available Labs Near You'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockLabs.length,
              itemBuilder: (context, index) {
                return _buildLabCard(_mockLabs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestPackages() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Choose Test Package'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockPackages.length,
              itemBuilder: (context, index) {
                return _buildPackageCard(_mockPackages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTests() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Your Test History'),
          const SizedBox(height: 16),
          Expanded(
            child: _mockTests.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _mockTests.length,
                  itemBuilder: (context, index) {
                    return _buildTestCard(_mockTests[index]);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: CropFreshColors.green30Forest,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLabCard(Map<String, dynamic> lab) {
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
                  backgroundColor: CropFreshColors.green10Container,
                  child: Icon(
                    Icons.science,
                    color: CropFreshColors.green30Forest,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lab['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        lab['type'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRatingChip(lab['rating']),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              lab['specialization'],
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
                  '${lab['distance']} km away',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Turnaround: ${lab['turnaround']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.orange10Primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package) {
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
                    package['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CropFreshColors.green10Container,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹${package['price']}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: CropFreshColors.green30Forest,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              package['description'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (package['parameters'] as List<String>).map((param) {
                return Chip(
                  label: Text(param),
                  backgroundColor: CropFreshColors.outline30Variant.withValues(alpha: 0.1),
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _bookTestPackage(package),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CropFreshColors.green10Primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Book Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
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
                    test['packageName'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(test['status']),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Lab: ${test['labName']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Booked: ${test['bookedDate']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CropFreshColors.onBackground60Secondary,
              ),
            ),
            if (test['status'] == 'Results Ready') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _viewResults(test),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CropFreshColors.green10Primary,
                    side: BorderSide(color: CropFreshColors.green10Primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Results'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CropFreshColors.orange10Container,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 14,
            color: CropFreshColors.orange10Primary,
          ),
          const SizedBox(width: 2),
          Text(
            rating.toString(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: CropFreshColors.orange10Primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Results Ready':
        color = CropFreshColors.green10Primary;
        break;
      case 'In Progress':
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.science_outlined,
            size: 64,
            color: CropFreshColors.onBackground60Secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No soil tests yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first soil test to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _bookTestPackage(Map<String, dynamic> package) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to booking flow
    Navigator.pushNamed(context, '/soil-testing/book', arguments: package);
  }

  void _viewResults(Map<String, dynamic> test) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to results screen
    Navigator.pushNamed(context, '/soil-testing/results', arguments: test);
  }

  // * MOCK DATA
  final List<Map<String, dynamic>> _mockLabs = [
    {
      'name': 'Karnataka Soil Lab',
      'type': 'Government Certified',
      'specialization': 'Comprehensive soil analysis, micronutrient testing',
      'distance': 2.5,
      'turnaround': '5-7 days',
      'rating': 4.5,
    },
    {
      'name': 'AgriTest Private Lab',
      'type': 'Private Laboratory',
      'specialization': 'Quick testing, organic certification',
      'distance': 4.2,
      'turnaround': '3-4 days',
      'rating': 4.2,
    },
  ];

  final List<Map<String, dynamic>> _mockPackages = [
    {
      'name': 'Basic Soil Test',
      'description': 'Essential parameters for general farming',
      'price': 250,
      'parameters': ['pH', 'NPK', 'Organic Carbon'],
    },
    {
      'name': 'Comprehensive Test',
      'description': 'Complete analysis including micronutrients',
      'price': 450,
      'parameters': ['pH', 'NPK', 'Micronutrients', 'Heavy Metals'],
    },
    {
      'name': 'Organic Certification',
      'description': 'For organic farming certification',
      'price': 650,
      'parameters': ['Pesticide Residue', 'Biological Activity', 'pH', 'NPK'],
    },
  ];

  final List<Map<String, dynamic>> _mockTests = [
    {
      'packageName': 'Basic Soil Test',
      'labName': 'Karnataka Soil Lab',
      'status': 'Results Ready',
      'bookedDate': '15 Jan 2024',
    },
    {
      'packageName': 'Comprehensive Test',
      'labName': 'AgriTest Private Lab',
      'status': 'In Progress',
      'bookedDate': '20 Jan 2024',
    },
  ];
} 