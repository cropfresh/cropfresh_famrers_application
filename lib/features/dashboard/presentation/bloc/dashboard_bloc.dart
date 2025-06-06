import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Dashboard Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}

class UpdateWeatherData extends DashboardEvent {
  final Map<String, dynamic> weatherData;

  const UpdateWeatherData(this.weatherData);

  @override
  List<Object?> get props => [weatherData];
}

class UpdateMarketPrices extends DashboardEvent {
  final List<Map<String, dynamic>> prices;

  const UpdateMarketPrices(this.prices);

  @override
  List<Object?> get props => [prices];
}

// Dashboard States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String farmerName;
  final Map<String, dynamic> weatherData;
  final List<Map<String, dynamic>> marketPrices;
  final List<Map<String, dynamic>> recentActivity;
  final List<Map<String, dynamic>> notifications;
  final Map<String, dynamic> farmSummary;

  const DashboardLoaded({
    required this.farmerName,
    required this.weatherData,
    required this.marketPrices,
    required this.recentActivity,
    required this.notifications,
    required this.farmSummary,
  });

  @override
  List<Object?> get props => [
        farmerName,
        weatherData,
        marketPrices,
        recentActivity,
        notifications,
        farmSummary,
      ];

  DashboardLoaded copyWith({
    String? farmerName,
    Map<String, dynamic>? weatherData,
    List<Map<String, dynamic>>? marketPrices,
    List<Map<String, dynamic>>? recentActivity,
    List<Map<String, dynamic>>? notifications,
    Map<String, dynamic>? farmSummary,
  }) {
    return DashboardLoaded(
      farmerName: farmerName ?? this.farmerName,
      weatherData: weatherData ?? this.weatherData,
      marketPrices: marketPrices ?? this.marketPrices,
      recentActivity: recentActivity ?? this.recentActivity,
      notifications: notifications ?? this.notifications,
      farmSummary: farmSummary ?? this.farmSummary,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// Dashboard BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<UpdateWeatherData>(_onUpdateWeatherData);
    on<UpdateMarketPrices>(_onUpdateMarketPrices);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      // Load dashboard data
      final dashboardData = await _loadDashboardData();
      emit(dashboardData);
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      try {
        final dashboardData = await _loadDashboardData();
        emit(dashboardData);
      } catch (e) {
        emit(DashboardError('Failed to refresh dashboard: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateWeatherData(
    UpdateWeatherData event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(weatherData: event.weatherData));
    }
  }

  Future<void> _onUpdateMarketPrices(
    UpdateMarketPrices event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(marketPrices: event.prices));
    }
  }

  Future<DashboardLoaded> _loadDashboardData() async {
    // Simulate API calls
    await Future.delayed(const Duration(seconds: 2));

    return DashboardLoaded(
      farmerName: 'Rajesh Kumar',
      weatherData: {
        'temperature': 28,
        'humidity': 65,
        'windSpeed': 12,
        'condition': 'Partly Cloudy',
        'rainfall': 0,
        'uvIndex': 6,
        'forecast': [
          {'day': 'Today', 'high': 32, 'low': 24, 'condition': 'Sunny'},
          {'day': 'Tomorrow', 'high': 30, 'low': 22, 'condition': 'Cloudy'},
          {'day': 'Thu', 'high': 28, 'low': 20, 'condition': 'Rain'},
          {'day': 'Fri', 'high': 29, 'low': 21, 'condition': 'Sunny'},
          {'day': 'Sat', 'high': 31, 'low': 23, 'condition': 'Partly Cloudy'},
        ],
      },
      marketPrices: [
        {'crop': 'Tomato', 'price': 25, 'unit': 'kg', 'change': 2.5, 'trend': 'up'},
        {'crop': 'Onion', 'price': 18, 'unit': 'kg', 'change': -1.2, 'trend': 'down'},
        {'crop': 'Potato', 'price': 12, 'unit': 'kg', 'change': 0.8, 'trend': 'up'},
        {'crop': 'Cabbage', 'price': 8, 'unit': 'kg', 'change': -0.5, 'trend': 'down'},
        {'crop': 'Carrot', 'price': 15, 'unit': 'kg', 'change': 1.0, 'trend': 'up'},
      ],
      recentActivity: [
        {
          'type': 'product_listed',
          'title': 'Tomato listing created',
          'description': '500 kg of premium tomatoes listed',
          'time': '2 hours ago',
          'icon': 'agriculture',
        },
        {
          'type': 'order_received',
          'title': 'New order received',
          'description': 'Order for 200 kg onions from ABC Traders',
          'time': '5 hours ago',
          'icon': 'shopping_cart',
        },
        {
          'type': 'logistics_booked',
          'title': 'Transport booked',
          'description': 'Pickup scheduled for tomorrow 8 AM',
          'time': '1 day ago',
          'icon': 'local_shipping',
        },
        {
          'type': 'vet_appointment',
          'title': 'Vet appointment reminder',
          'description': 'Cattle checkup scheduled for Thursday',
          'time': '2 days ago',
          'icon': 'medical_services',
        },
      ],
      notifications: [
        {
          'id': '1',
          'title': 'Weather Alert',
          'message': 'Heavy rain expected tomorrow. Protect your crops.',
          'type': 'weather',
          'priority': 'high',
          'time': '1 hour ago',
        },
        {
          'id': '2',
          'title': 'Market Update',
          'message': 'Tomato prices increased by 10% in local mandi.',
          'type': 'market',
          'priority': 'medium',
          'time': '3 hours ago',
        },
        {
          'id': '3',
          'title': 'New Buyer Inquiry',
          'message': 'Buyer interested in your potato listing.',
          'type': 'marketplace',
          'priority': 'medium',
          'time': '6 hours ago',
        },
      ],
      farmSummary: {
        'totalLand': 2.5,
        'activeCrops': 4,
        'totalAnimals': 12,
        'pendingOrders': 3,
        'monthlyRevenue': 45000,
        'cropHealth': 'Good',
      },
    );
  }
}
