import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// * NURSERY SERVICES PAGE
/// * Features: Plant discovery, quality verification, nursery booking
class NurseryServicesPage extends StatefulWidget {
  const NurseryServicesPage({super.key});

  @override
  State<NurseryServicesPage> createState() => _NurseryServicesPageState();
}

class _NurseryServicesPageState extends State<NurseryServicesPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Secondary,
      appBar: AppBar(
        title: const Text('Nursery Services'),
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
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = ['Find Nurseries', 'Plant Catalog', 'My Orders', 'Care Guide'];
    
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
        return _buildFindNurseriesTab();
      case 1:
        return _buildPlantCatalogTab();
      case 2:
        return _buildMyOrdersTab();
      case 3:
        return _buildCareGuideTab();
      default:
        return _buildFindNurseriesTab();
    }
  }

  Widget _buildFindNurseriesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildNurseryCard(
          name: 'Green Valley Nursery',
          type: 'Government Certified',
          rating: 4.8,
          distance: '2.5 km',
          speciality: 'Fruit Saplings',
          isVerified: true,
        ),
        _buildNurseryCard(
          name: 'Krishna Plant House',
          type: 'Private',
          rating: 4.6,
          distance: '5.2 km',
          speciality: 'Vegetable Seedlings',
          isVerified: true,
        ),
        _buildNurseryCard(
          name: 'Agri Nursery Center',
          type: 'Government',
          rating: 4.9,
          distance: '8.1 km',
          speciality: 'All Plants',
          isVerified: true,
        ),
      ],
    );
  }

  Widget _buildNurseryCard({
    required String name,
    required String type,
    required double rating,
    required String distance,
    required String speciality,
    required bool isVerified,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isVerified) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: CropFreshColors.green30Container,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified, size: 12, color: CropFreshColors.green30Primary),
                                const SizedBox(width: 2),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: CropFreshColors.green30Primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$type • $distance • $speciality',
                      style: TextStyle(
                        color: CropFreshColors.onBackground60Secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: CropFreshColors.green30Primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 12, color: CropFreshColors.green30Primary),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(color: CropFreshColors.green30Primary),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _viewNurseryDetails(name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CropFreshColors.green30Primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCatalogTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final plants = [
          {'name': 'Mango Sapling', 'price': '₹150', 'nursery': 'Green Valley'},
          {'name': 'Tomato Seedlings', 'price': '₹25', 'nursery': 'Krishna Plant'},
          {'name': 'Rose Plant', 'price': '₹80', 'nursery': 'Agri Center'},
          {'name': 'Lemon Tree', 'price': '₹120', 'nursery': 'Green Valley'},
          {'name': 'Chili Seedlings', 'price': '₹20', 'nursery': 'Krishna Plant'},
          {'name': 'Coconut Sapling', 'price': '₹200', 'nursery': 'Agri Center'},
          {'name': 'Brinjal Seedlings', 'price': '₹30', 'nursery': 'Green Valley'},
          {'name': 'Guava Plant', 'price': '₹100', 'nursery': 'Krishna Plant'},
        ];
        
        final plant = plants[index];
        return _buildPlantCard(plant);
      },
    );
  }

  Widget _buildPlantCard(Map<String, String> plant) {
    return Container(
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
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: CropFreshColors.green30Container,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.eco,
                size: 40,
                color: CropFreshColors.green30Primary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant['name']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plant['nursery']!,
                    style: TextStyle(
                      color: CropFreshColors.onBackground60Secondary,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plant['price']!,
                        style: TextStyle(
                          color: CropFreshColors.green30Primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CropFreshColors.green30Container,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: CropFreshColors.green30Primary,
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

  Widget _buildMyOrdersTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOrderCard(
          orderId: 'ORD-2024-001',
          nurseryName: 'Green Valley Nursery',
          plantName: 'Mango Saplings (5 qty)',
          orderDate: '15 Jan 2024',
          status: 'Delivered',
          amount: '₹750',
        ),
        _buildOrderCard(
          orderId: 'ORD-2024-002',
          nurseryName: 'Krishna Plant House',
          plantName: 'Tomato Seedlings (20 qty)',
          orderDate: '18 Jan 2024',
          status: 'In Transit',
          amount: '₹500',
        ),
      ],
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String nurseryName,
    required String plantName,
    required String orderDate,
    required String status,
    required String amount,
  }) {
    Color statusColor;
    switch (status) {
      case 'Delivered':
        statusColor = CropFreshColors.green30Primary;
        break;
      case 'In Transit':
        statusColor = CropFreshColors.orange10Primary;
        break;
      case 'Processing':
        statusColor = CropFreshColors.orange10Primary;
        break;
      default:
        statusColor = CropFreshColors.onBackground60Secondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CropFreshColors.onBackground60Tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            nurseryName,
            style: TextStyle(
              color: CropFreshColors.onBackground60Secondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            plantName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderDate,
                style: TextStyle(
                  color: CropFreshColors.onBackground60Secondary,
                  fontSize: 12,
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: CropFreshColors.green30Primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCareGuideTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCareGuideCard(
          title: 'Watering Schedule',
          description: 'Learn optimal watering frequency for different plants',
          icon: Icons.water_drop,
        ),
        _buildCareGuideCard(
          title: 'Fertilizer Application',
          description: 'Understand when and how to apply fertilizers',
          icon: Icons.grass,
        ),
        _buildCareGuideCard(
          title: 'Pest Control',
          description: 'Identify and treat common plant pests naturally',
          icon: Icons.bug_report,
        ),
        _buildCareGuideCard(
          title: 'Pruning Techniques',
          description: 'Proper pruning methods for healthy plant growth',
          icon: Icons.content_cut,
        ),
      ],
    );
  }

  Widget _buildCareGuideCard({
    required String title,
    required String description,
    required IconData icon,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CropFreshColors.green30Container,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: CropFreshColors.green30Primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: CropFreshColors.onBackground60Tertiary,
          ),
        ],
      ),
    );
  }

  void _viewNurseryDetails(String nurseryName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for $nurseryName')),
    );
  }
} 