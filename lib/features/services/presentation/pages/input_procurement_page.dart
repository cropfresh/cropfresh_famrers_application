// ===================================================================
// * INPUT PROCUREMENT PAGE
// * Purpose: Allow farmers to browse and order agricultural inputs
// * Features: Product catalog, dealer listings, bulk orders, delivery tracking
// * Security Level: Medium - Contains order and payment information
// ===================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';

class InputProcurementPage extends StatefulWidget {
  const InputProcurementPage({super.key});

  @override
  State<InputProcurementPage> createState() => _InputProcurementPageState();
}

class _InputProcurementPageState extends State<InputProcurementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _selectedCategory = 'All';
  
  final List<String> _categories = [
    'All',
    'Seeds',
    'Fertilizers',
    'Pesticides',
    'Organic',
    'Equipment',
  ];

  // ! Mock data - replace with actual API calls
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Hybrid Tomato Seeds',
      'category': 'Seeds',
      'price': 150.0,
      'unit': '10g pack',
      'dealer': 'Ravi Seeds Store',
      'rating': 4.5,
      'image': null,
      'inStock': true,
      'discount': 10,
    },
    {
      'id': '2',
      'name': 'NPK Fertilizer 19:19:19',
      'category': 'Fertilizers',
      'price': 450.0,
      'unit': '1kg',
      'dealer': 'Krishi Fertilizers',
      'rating': 4.2,
      'image': null,
      'inStock': true,
      'discount': 0,
    },
    {
      'id': '3',
      'name': 'Neem Oil Pesticide',
      'category': 'Organic',
      'price': 250.0,
      'unit': '500ml',
      'dealer': 'Organic Farm Supplies',
      'rating': 4.8,
      'image': null,
      'inStock': false,
      'discount': 15,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Input Procurement',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // * Search Bar
          _buildSearchBar(),
          
          // * Category Tabs
          _buildCategoryTabs(),
          
          // * Products Grid
          Expanded(
            child: _isLoading 
                ? const LoadingWidget()
                : _buildProductsGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _viewCart,
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Cart (0)'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for seeds, fertilizers, pesticides...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey.shade600,
        tabs: _categories.map((category) => Tab(text: category)).toList(),
        onTap: (index) {
          setState(() => _selectedCategory = _categories[index]);
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    final filteredProducts = _getFilteredProducts();
    
    if (filteredProducts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final bool inStock = product['inStock'] as bool;
    final int discount = product['discount'] as int;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _viewProductDetails(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: product['image'] != null
                        ? Image.network(
                            product['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.inventory, size: 40);
                            },
                          )
                        : Icon(
                            _getCategoryIcon(product['category']),
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                  ),
                  
                  // Stock status
                  if (!inStock)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  
                  // Discount badge
                  if (discount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$discount% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // * Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    Text(
                      product['dealer'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange.shade400, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${product['rating']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          '₹${product['price']}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    Text(
                      'per ${product['unit']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    return _products.where((product) {
      bool matchesSearch = product['name']
          .toString()
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      
      bool matchesCategory = _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Seeds':
        return Icons.eco;
      case 'Fertilizers':
        return Icons.science;
      case 'Pesticides':
        return Icons.bug_report;
      case 'Organic':
        return Icons.nature;
      case 'Equipment':
        return Icons.agriculture;
      default:
        return Icons.inventory;
    }
  }

  void _viewProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildProductDetailsSheet(product),
    );
  }

  Widget _buildProductDetailsSheet(Map<String, dynamic> product) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'by ${product['dealer']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Text(
                    '₹${product['price']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'per ${product['unit']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _addToCart(product),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _buyNow(product),
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Buy Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Coming soon...'),
            const SizedBox(height: 16),
            const Text('Price range, availability, and dealer filters will be added here.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _buyNow(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to buy ${product['name']}'),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.pop(context);
  }

  void _viewCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cart functionality coming soon')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
} 