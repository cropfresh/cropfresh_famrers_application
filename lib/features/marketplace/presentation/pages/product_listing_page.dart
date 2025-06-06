// ===================================================================
// * PRODUCT LISTING PAGE
// * Purpose: Display list of products in marketplace
// * Features: Product grid, filters, search
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/marketplace_bloc.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(const LoadMarketplaceData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'All Products',
      ),
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const LoadingWidget();
          }
          
          if (state is MarketplaceError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<MarketplaceBloc>().add(const LoadMarketplaceData());
              },
            );
          }
          
          if (state is MarketplaceLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.allProducts.length,
              itemBuilder: (context, index) {
                final product = state.allProducts[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.agriculture, size: 40),
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
                                product['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${product['price']}/kg',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${product['location']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          
          return const LoadingWidget();
        },
      ),
    );
  }
} 