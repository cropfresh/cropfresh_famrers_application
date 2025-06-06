// ===================================================================
// * PRODUCT DETAIL PAGE
// * Purpose: Display detailed product information
// * Features: Product details, images, seller info, actions
// ===================================================================

import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_app_bar.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Product Details',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Product Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.agriculture, size: 80),
            ),
          ),
          const SizedBox(height: 16),
          
          // Product Name
          const Text(
            'Fresh Tomatoes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Price
          const Text(
            '₹25/kg',
            style: TextStyle(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Premium quality tomatoes from organic farm. Fresh and nutritious, perfect for cooking.',
          ),
          const SizedBox(height: 16),
          
          // Seller Info
          const Text(
            'Seller Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('Rajesh Kumar'),
            subtitle: Text('Bangalore, Karnataka'),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement contact seller
                  },
                  child: const Text('Contact Seller'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement buy now
                  },
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 