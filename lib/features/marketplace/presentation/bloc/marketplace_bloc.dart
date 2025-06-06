// ===================================================================
// * MARKETPLACE BLOC
// * Purpose: Manages marketplace state and business logic
// * Features: Product loading, filtering, search, CRUD operations
// ===================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// * MARKETPLACE EVENTS
abstract class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarketplaceData extends MarketplaceEvent {
  const LoadMarketplaceData();
}

class RefreshMarketplace extends MarketplaceEvent {
  const RefreshMarketplace();
}

class SearchProducts extends MarketplaceEvent {
  final String query;
  
  const SearchProducts(this.query);
  
  @override
  List<Object?> get props => [query];
}

class FilterProducts extends MarketplaceEvent {
  final String category;
  final String sortBy;
  final Map<String, dynamic>? filters;
  
  const FilterProducts({
    required this.category,
    required this.sortBy,
    this.filters,
  });
  
  @override
  List<Object?> get props => [category, sortBy, filters];
}

// * MARKETPLACE STATES
abstract class MarketplaceState extends Equatable {
  const MarketplaceState();

  @override
  List<Object?> get props => [];
}

class MarketplaceInitial extends MarketplaceState {}

class MarketplaceLoading extends MarketplaceState {}

class MarketplaceLoaded extends MarketplaceState {
  final List<Map<String, dynamic>> allProducts;
  final List<Map<String, dynamic>> myProducts;
  final List<Map<String, dynamic>> filteredProducts;
  final Map<String, dynamic> marketStats;
  final String currentCategory;
  final String currentSortBy;
  final String searchQuery;

  const MarketplaceLoaded({
    required this.allProducts,
    required this.myProducts,
    required this.filteredProducts,
    required this.marketStats,
    this.currentCategory = 'All',
    this.currentSortBy = 'Recent',
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
        allProducts,
        myProducts,
        filteredProducts,
        marketStats,
        currentCategory,
        currentSortBy,
        searchQuery,
      ];

  MarketplaceLoaded copyWith({
    List<Map<String, dynamic>>? allProducts,
    List<Map<String, dynamic>>? myProducts,
    List<Map<String, dynamic>>? filteredProducts,
    Map<String, dynamic>? marketStats,
    String? currentCategory,
    String? currentSortBy,
    String? searchQuery,
  }) {
    return MarketplaceLoaded(
      allProducts: allProducts ?? this.allProducts,
      myProducts: myProducts ?? this.myProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      marketStats: marketStats ?? this.marketStats,
      currentCategory: currentCategory ?? this.currentCategory,
      currentSortBy: currentSortBy ?? this.currentSortBy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MarketplaceError extends MarketplaceState {
  final String message;
  final String? errorCode;

  const MarketplaceError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

// * MARKETPLACE BLOC
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc() : super(MarketplaceInitial()) {
    on<LoadMarketplaceData>(_onLoadMarketplaceData);
    on<RefreshMarketplace>(_onRefreshMarketplace);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProducts>(_onFilterProducts);
  }

  // * Load marketplace data
  Future<void> _onLoadMarketplaceData(
    LoadMarketplaceData event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());

    try {
      // * Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final allProducts = _generateSampleProducts();
      final myProducts = _generateSampleMyProducts();
      final marketStats = _generateSampleMarketStats();

      emit(MarketplaceLoaded(
        allProducts: allProducts,
        myProducts: myProducts,
        filteredProducts: allProducts,
        marketStats: marketStats,
      ));
    } catch (error) {
      emit(MarketplaceError(
        message: 'Failed to load marketplace data: ${error.toString()}',
        errorCode: 'LOAD_FAILED',
      ));
    }
  }

  // * Refresh marketplace data
  Future<void> _onRefreshMarketplace(
    RefreshMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state is MarketplaceLoaded) {
      try {
        final allProducts = _generateSampleProducts();
        final myProducts = _generateSampleMyProducts();
        final marketStats = _generateSampleMarketStats();

        final currentState = state as MarketplaceLoaded;
        emit(currentState.copyWith(
          allProducts: allProducts,
          myProducts: myProducts,
          filteredProducts: _applyFiltersAndSort(
            allProducts,
            currentState.currentCategory,
            currentState.currentSortBy,
            currentState.searchQuery,
          ),
          marketStats: marketStats,
        ));
      } catch (error) {
        emit(MarketplaceError(
          message: 'Failed to refresh marketplace: ${error.toString()}',
          errorCode: 'REFRESH_FAILED',
        ));
      }
    }
  }

  // * Search products
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state is MarketplaceLoaded) {
      final currentState = state as MarketplaceLoaded;
      
      final filteredProducts = _applyFiltersAndSort(
        currentState.allProducts,
        currentState.currentCategory,
        currentState.currentSortBy,
        event.query,
      );

      emit(currentState.copyWith(
        filteredProducts: filteredProducts,
        searchQuery: event.query,
      ));
    }
  }

  // * Filter products
  Future<void> _onFilterProducts(
    FilterProducts event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state is MarketplaceLoaded) {
      final currentState = state as MarketplaceLoaded;
      
      final filteredProducts = _applyFiltersAndSort(
        currentState.allProducts,
        event.category,
        event.sortBy,
        currentState.searchQuery,
      );

      emit(currentState.copyWith(
        filteredProducts: filteredProducts,
        currentCategory: event.category,
        currentSortBy: event.sortBy,
      ));
    }
  }

  // * Helper methods for filtering and sorting
  List<Map<String, dynamic>> _applyFiltersAndSort(
    List<Map<String, dynamic>> products,
    String category,
    String sortBy,
    String searchQuery,
  ) {
    var filtered = List<Map<String, dynamic>>.from(products);

    // * Apply category filter
    if (category != 'All') {
      filtered = filtered.where((product) => 
          product['category']?.toString().toLowerCase() == category.toLowerCase()
      ).toList();
    }

    // * Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((product) =>
          product['name']?.toString().toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          product['description']?.toString().toLowerCase().contains(searchQuery.toLowerCase()) == true
      ).toList();
    }

    // * Apply sorting
    switch (sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => (a['price'] ?? 0).compareTo(b['price'] ?? 0));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => (b['price'] ?? 0).compareTo(a['price'] ?? 0));
        break;
      case 'Rating':
        filtered.sort((a, b) => (b['rating'] ?? 0.0).compareTo(a['rating'] ?? 0.0));
        break;
      case 'Distance':
        // TODO: Implement distance-based sorting
        break;
      default: // Recent
        filtered.sort((a, b) {
          final aDate = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime.now();
          final bDate = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime.now();
          return bDate.compareTo(aDate);
        });
    }

    return filtered;
  }

  // * Generate sample data for development
  List<Map<String, dynamic>> _generateSampleProducts() {
    return [
      {
        'id': '1',
        'name': 'Fresh Tomatoes',
        'category': 'Vegetables',
        'price': 25,
        'quantity': 500,
        'unit': 'kg',
        'description': 'Premium quality tomatoes from organic farm',
        'location': 'Bangalore, Karnataka',
        'farmerId': 'farmer123',
        'farmerName': 'Rajesh Kumar',
        'rating': 4.5,
        'image': null,
        'status': 'active',
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': '2',
        'name': 'Red Onions',
        'category': 'Vegetables',
        'price': 18,
        'quantity': 300,
        'unit': 'kg',
        'description': 'Fresh red onions with excellent quality',
        'location': 'Mysore, Karnataka',
        'farmerId': 'farmer456',
        'farmerName': 'Suresh Gowda',
        'rating': 4.2,
        'image': null,
        'status': 'active',
        'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'id': '3',
        'name': 'Fresh Carrots',
        'category': 'Vegetables',
        'price': 15,
        'quantity': 200,
        'unit': 'kg',
        'description': 'Organic carrots with natural sweetness',
        'location': 'Mandya, Karnataka',
        'farmerId': 'farmer789',
        'farmerName': 'Lakshmi Devi',
        'rating': 4.8,
        'image': null,
        'status': 'active',
        'createdAt': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      },
      {
        'id': '4',
        'name': 'Green Cabbage',
        'category': 'Vegetables',
        'price': 8,
        'quantity': 400,
        'unit': 'kg',
        'description': 'Fresh green cabbage perfect for cooking',
        'location': 'Hassan, Karnataka',
        'farmerId': 'farmer321',
        'farmerName': 'Ravi Shankar',
        'rating': 4.0,
        'image': null,
        'status': 'active',
        'createdAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
      },
    ];
  }

  List<Map<String, dynamic>> _generateSampleMyProducts() {
    return [
      {
        'id': '5',
        'name': 'My Tomatoes',
        'category': 'Vegetables',
        'price': 30,
        'quantity': 250,
        'unit': 'kg',
        'description': 'High quality tomatoes from my farm',
        'location': 'My Farm, Karnataka',
        'status': 'active',
        'views': 45,
        'inquiries': 8,
        'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'id': '6',
        'name': 'My Potatoes',
        'category': 'Vegetables',
        'price': 12,
        'quantity': 100,
        'unit': 'kg',
        'description': 'Fresh potatoes ready for sale',
        'location': 'My Farm, Karnataka',
        'status': 'sold',
        'views': 32,
        'inquiries': 5,
        'createdAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      },
    ];
  }

  Map<String, dynamic> _generateSampleMarketStats() {
    return {
      'totalProducts': 156,
      'totalSellers': 45,
      'averagePrice': 18.5,
      'topCategories': ['Vegetables', 'Fruits', 'Grains'],
      'recentTrends': {
        'increasing': ['Tomatoes', 'Onions'],
        'decreasing': ['Potatoes'],
        'stable': ['Carrots', 'Cabbage'],
      },
    };
  }
} 