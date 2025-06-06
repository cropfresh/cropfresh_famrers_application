// ===================================================================
// * PROVIDER DISCOVERY PAGE
// * Purpose: Allow farmers to discover and select logistics providers
// * Features: Provider search, filtering, ratings, booking initiation
// * Security Level: Medium - Contains provider information
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';

class ProviderDiscoveryPage extends StatefulWidget {
  const ProviderDiscoveryPage({super.key});

  @override
  State<ProviderDiscoveryPage> createState() => _ProviderDiscoveryPageState();
}

class _ProviderDiscoveryPageState extends State<ProviderDiscoveryPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _selectedVehicleType = 'All';
  double _maxDistance = 50.0;

  // ! Mock data - replace with actual API calls
  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'Rajesh Transport',
      'rating': 4.5,
      'distance': 5.2,
      'vehicleTypes': ['Pickup Truck', 'Mini Truck'],
      'pricePerKm': 15.0,
      'isAvailable': true,
      'completedDeliveries': 150,
      'image': null,
    },
    {
      'id': '2', 
      'name': 'Karnataka Logistics',
      'rating': 4.2,
      'distance': 8.7,
      'vehicleTypes': ['Truck', 'Reefer Truck'],
      'pricePerKm': 20.0,
      'isAvailable': true,
      'completedDeliveries': 280,
      'image': null,
    },
    {
      'id': '3',
      'name': 'Village Transport Co-op',
      'rating': 4.8,
      'distance': 12.3,
      'vehicleTypes': ['Tractor', 'Pickup Truck'],
      'pricePerKm': 12.0,
      'isAvailable': false,
      'completedDeliveries': 95,
      'image': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredProviders {
    return _providers.where((provider) {
      bool matchesSearch = provider['name']
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      
      bool matchesVehicleType = _selectedVehicleType == 'All' ||
          provider['vehicleTypes'].contains(_selectedVehicleType);
      
      bool matchesDistance = provider['distance'] <= _maxDistance;
      
      return matchesSearch && matchesVehicleType && matchesDistance;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Logistics Providers',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // * Search and Filters Section
          _buildSearchAndFilters(),
          
          // * Providers List
          Expanded(
            child: _isLoading 
                ? const LoadingWidget()
                : _buildProvidersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // * Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search providers...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => setState(() {}),
          ),
          
          const SizedBox(height: 12),
          
          // * Filters Row
          Row(
            children: [
              // Vehicle Type Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedVehicleType,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['All', 'Pickup Truck', 'Mini Truck', 'Truck', 'Tractor', 'Reefer Truck']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedVehicleType = value!),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Distance Filter
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distance: ${_maxDistance.round()} km'),
                    Slider(
                      value: _maxDistance,
                      min: 5,
                      max: 100,
                      divisions: 19,
                      onChanged: (value) => setState(() => _maxDistance = value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    final filteredProviders = _filteredProviders;
    
    if (filteredProviders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No providers found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProviders.length,
      itemBuilder: (context, index) {
        final provider = filteredProviders[index];
        return _buildProviderCard(provider);
      },
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectProvider(provider),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Header Row
              Row(
                children: [
                  // Provider Logo/Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      provider['name'][0].toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Provider Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              provider['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!provider['isAvailable'])
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Busy',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange.shade400, size: 16),
                            const SizedBox(width: 4),
                            Text('${provider['rating']}'),
                            const SizedBox(width: 12),
                            Icon(Icons.location_on, color: Colors.grey.shade600, size: 16),
                            const SizedBox(width: 4),
                            Text('${provider['distance']} km away'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${provider['pricePerKm']}/km',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${provider['completedDeliveries']} trips',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // * Vehicle Types
              Wrap(
                spacing: 8,
                children: provider['vehicleTypes']
                    .map<Widget>((type) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectProvider(Map<String, dynamic> provider) {
    if (!provider['isAvailable']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This provider is currently busy'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Navigate to booking details with selected provider
    context.push('/main/services/logistics/booking');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 