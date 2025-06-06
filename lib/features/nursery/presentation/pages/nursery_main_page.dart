import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';

/// * NURSERY MAIN PAGE
/// * Features: Plant discovery, catalog browsing, seasonal planting guides
class NurseryMainPage extends StatefulWidget {
  const NurseryMainPage({super.key});

  @override
  State<NurseryMainPage> createState() => _NurseryMainPageState();
}

class _NurseryMainPageState extends State<NurseryMainPage>
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
          _buildNurseryDiscovery(),
          _buildPlantCatalog(),
          _buildSeasonalGuide(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Nursery Services',
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
          Tab(text: 'Nurseries', icon: Icon(Icons.store_outlined)),
          Tab(text: 'Plants', icon: Icon(Icons.local_florist_outlined)),
          Tab(text: 'Seasonal', icon: Icon(Icons.calendar_month_outlined)),
        ],
      ),
    );
  }

  Widget _buildNurseryDiscovery() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchFilters(),
          const SizedBox(height: 16),
          Text(
            'Verified Nurseries Near You',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockNurseries.length,
              itemBuilder: (context, index) {
                return _buildNurseryCard(_mockNurseries[index]);
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
            'Filter by Plant Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPlantTypeChip('Fruit Trees', Icons.apple),
              _buildPlantTypeChip('Vegetables', Icons.eco),
              _buildPlantTypeChip('Flowers', Icons.local_florist),
              _buildPlantTypeChip('Herbs', Icons.grass),
              _buildPlantTypeChip('Indoor Plants', Icons.home),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlantTypeChip(String label, IconData icon) {
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

  Widget _buildNurseryCard(Map<String, dynamic> nursery) {
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
                    Icons.store,
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
                        nursery['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nursery['type'],
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
                            '${nursery['rating']} (${nursery['reviews']} reviews)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (nursery['isVerified'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CropFreshColors.green10Container,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: CropFreshColors.green30Forest,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Verified',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: CropFreshColors.green30Forest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Specialization: ${nursery['specialization']}',
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
                  '${nursery['distance']} km away',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Quality Score: ${nursery['qualityScore']}%',
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
              children: (nursery['availablePlants'] as List<String>).map((plant) {
                return Chip(
                  label: Text(plant),
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
                    onPressed: () => _viewNurseryProfile(nursery),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CropFreshColors.green10Primary,
                      side: BorderSide(color: CropFreshColors.green10Primary),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _browsePlants(nursery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CropFreshColors.green10Primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Browse Plants'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCatalog() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlantCategories(),
          const SizedBox(height: 16),
          Text(
            'Available Plants',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _mockPlants.length,
              itemBuilder: (context, index) {
                return _buildPlantCard(_mockPlants[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCategories() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip('All Plants', true),
          _buildCategoryChip('Fruit Trees', false),
          _buildCategoryChip('Vegetables', false),
          _buildCategoryChip('Flowers', false),
          _buildCategoryChip('Herbs', false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // TODO: Implement category filter
        },
        backgroundColor: CropFreshColors.outline30Variant.withValues(alpha: 0.1),
        selectedColor: CropFreshColors.green10Container,
        checkmarkColor: CropFreshColors.green30Forest,
      ),
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: CropFreshColors.green10Container,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(
                _getPlantIcon(plant['category']),
                size: 50,
                color: CropFreshColors.green30Forest,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plant['scientificName'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CropFreshColors.onBackground60Secondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₹${plant['price']}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: CropFreshColors.orange10Primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (plant['inSeason'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: CropFreshColors.green10Container,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'In Season',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: CropFreshColors.green30Forest,
                              fontSize: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentSeasonCard(),
          const SizedBox(height: 16),
          Text(
            'Planting Calendar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CropFreshColors.green30Forest,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _seasonalGuide.length,
              itemBuilder: (context, index) {
                return _buildSeasonalCard(_seasonalGuide[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSeasonCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CropFreshColors.orange10Container,
            CropFreshColors.orange30Container,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny,
                size: 32,
                color: CropFreshColors.orange10Primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Summer Season',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: CropFreshColors.orange10Primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Best time for planting heat-resistant vegetables and setting up shade gardens.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.orange10Primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Recommended Plants: Tomatoes, Peppers, Okra, Gourds',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.orange10Primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonalCard(Map<String, dynamic> season) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ExpansionTile(
        leading: Icon(
          _getSeasonIcon(season['season']),
          color: CropFreshColors.green30Forest,
        ),
        title: Text(
          season['season'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(season['months']),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Plants to Grow:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (season['plants'] as List<String>).map((plant) {
                    return Chip(
                      label: Text(plant),
                      backgroundColor: CropFreshColors.green10Container,
                      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CropFreshColors.green30Forest,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Care Tips:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  season['tips'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlantIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruit':
        return Icons.apple;
      case 'vegetable':
        return Icons.eco;
      case 'flower':
        return Icons.local_florist;
      case 'herb':
        return Icons.grass;
      default:
        return Icons.local_florist;
    }
  }

  IconData _getSeasonIcon(String season) {
    switch (season.toLowerCase()) {
      case 'summer':
        return Icons.wb_sunny;
      case 'monsoon':
        return Icons.grain;
      case 'winter':
        return Icons.ac_unit;
      case 'spring':
        return Icons.local_florist;
      default:
        return Icons.calendar_month;
    }
  }

  void _viewNurseryProfile(Map<String, dynamic> nursery) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to nursery profile screen
  }

  void _browsePlants(Map<String, dynamic> nursery) {
    HapticFeedback.lightImpact();
    // TODO: Navigate to nursery plant catalog
  }

  // * MOCK DATA
  final List<Map<String, dynamic>> _mockNurseries = [
    {
      'id': '1',
      'name': 'Green Valley Nursery',
      'type': 'Certified Organic Nursery',
      'rating': 4.8,
      'reviews': 156,
      'distance': 2.3,
      'qualityScore': 95,
      'isVerified': true,
      'specialization': 'Fruit trees, organic vegetables, native plants',
      'availablePlants': ['Mango', 'Tomato', 'Rose', 'Neem'],
    },
    {
      'id': '2',
      'name': 'City Garden Center',
      'type': 'Commercial Plant Nursery',
      'rating': 4.5,
      'reviews': 203,
      'distance': 4.7,
      'qualityScore': 88,
      'isVerified': true,
      'specialization': 'Indoor plants, decorative flowers, landscaping',
      'availablePlants': ['Tulsi', 'Marigold', 'Bonsai', 'Fern'],
    },
  ];

  final List<Map<String, dynamic>> _mockPlants = [
    {
      'name': 'Mango Sapling',
      'scientificName': 'Mangifera indica',
      'category': 'Fruit',
      'price': 150,
      'inSeason': true,
    },
    {
      'name': 'Tomato Plant',
      'scientificName': 'Solanum lycopersicum',
      'category': 'Vegetable',
      'price': 25,
      'inSeason': true,
    },
    {
      'name': 'Rose Bush',
      'scientificName': 'Rosa gallica',
      'category': 'Flower',
      'price': 80,
      'inSeason': false,
    },
    {
      'name': 'Tulsi Plant',
      'scientificName': 'Ocimum tenuiflorum',
      'category': 'Herb',
      'price': 30,
      'inSeason': true,
    },
  ];

  final List<Map<String, dynamic>> _seasonalGuide = [
    {
      'season': 'Summer',
      'months': 'March - June',
      'plants': ['Tomato', 'Pepper', 'Okra', 'Gourd', 'Cucumber'],
      'tips': 'Provide adequate shade and water frequently. Best time for heat-resistant crops.',
    },
    {
      'season': 'Monsoon',
      'months': 'July - September',
      'plants': ['Rice', 'Ginger', 'Turmeric', 'Leafy Greens', 'Beans'],
      'tips': 'Ensure proper drainage to prevent waterlogging. Good time for transplanting.',
    },
    {
      'season': 'Winter',
      'months': 'October - February',
      'plants': ['Cabbage', 'Carrot', 'Peas', 'Spinach', 'Cauliflower'],
      'tips': 'Protect from frost. Ideal conditions for most vegetables and flowers.',
    },
  ];
} 