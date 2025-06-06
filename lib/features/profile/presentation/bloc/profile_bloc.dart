import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// * PROFILE EVENTS
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  const LoadUserProfile();
}

class RefreshUserProfile extends ProfileEvent {
  const RefreshUserProfile();
}

class UpdateUserProfile extends ProfileEvent {
  final Map<String, dynamic> profileData;

  const UpdateUserProfile(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class LogoutUser extends ProfileEvent {
  const LogoutUser();
}

// * PROFILE STATES
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String profileImageUrl;
  final Map<String, dynamic> farmDetails;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> achievements;
  final List<Map<String, dynamic>> recentActivity;

  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.profileImageUrl,
    required this.farmDetails,
    required this.profile,
    required this.stats,
    required this.achievements,
    required this.recentActivity,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    location,
    profileImageUrl,
    farmDetails,
    profile,
    stats,
    achievements,
    recentActivity,
  ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// * PROFILE BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<RefreshUserProfile>(_onRefreshUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      // * Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // ! TODO: Replace with actual API call
      const mockProfile = {
        'name': 'Ravi Kumar',
        'phoneNumber': '+91 9876543210',
        'email': 'ravi.kumar@example.com',
        'location': 'Bangalore, Karnataka',
        'profilePicture': null,
        'verificationStatus': 'verified',
        'memberSince': '2023-01-15',
      };

      const mockStats = {
        'totalProducts': 12,
        'totalSales': 25,
        'totalIncome': 45000,
        'rating': 4.8,
      };

      const mockFarmDetails = {
        'area': '2.5 acres',
        'crops': ['Tomato', 'Onion', 'Potato'],
        'experience': '5 years',
        'soilType': 'Red Soil',
        'irrigationType': 'Drip Irrigation',
      };

      const mockAchievements = [
        {
          'id': '1',
          'title': 'Top Seller',
          'description': 'Sold over 1000kg of produce',
          'icon': 'trophy',
          'date': '2024-01-15',
        },
        {
          'id': '2',
          'title': 'Quality Farmer',
          'description': '5-star rating for 3 months',
          'icon': 'star',
          'date': '2023-12-01',
        },
      ];

      const mockRecentActivity = [
        {
          'id': '1',
          'type': 'product_listed',
          'title': 'Listed Fresh Tomatoes',
          'description': '500kg available for sale',
          'timestamp': '2024-01-20T10:30:00Z',
          'icon': 'add_shopping_cart',
        },
        {
          'id': '2',
          'type': 'order_received',
          'title': 'New Order Received',
          'description': 'Order for 100kg Onions',
          'timestamp': '2024-01-19T15:45:00Z',
          'icon': 'shopping_bag',
        },
        {
          'id': '3',
          'type': 'payment_received',
          'title': 'Payment Received',
          'description': '₹5,000 for Potato sale',
          'timestamp': '2024-01-18T09:15:00Z',
          'icon': 'payment',
        },
      ];

      emit(ProfileLoaded(
        name: mockProfile['name']!,
        email: mockProfile['email']!,
        phone: mockProfile['phoneNumber']!,
        location: mockProfile['location']!,
        profileImageUrl: mockProfile['profilePicture'] ?? '',
        farmDetails: mockFarmDetails,
        profile: mockProfile,
        stats: mockStats,
        achievements: mockAchievements,
        recentActivity: mockRecentActivity,
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onRefreshUserProfile(
    RefreshUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // * Don't show loading state for refresh
    try {
      // * Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // ! TODO: Replace with actual API call - same mock data for now
      const mockProfile = {
        'name': 'Ravi Kumar',
        'phoneNumber': '+91 9876543210',
        'email': 'ravi.kumar@example.com',
        'location': 'Bangalore, Karnataka',
        'profilePicture': null,
        'verificationStatus': 'verified',
        'memberSince': '2023-01-15',
      };

      const mockStats = {
        'totalProducts': 12,
        'totalSales': 25,
        'totalIncome': 45000,
        'rating': 4.8,
      };

      const mockFarmDetails = {
        'area': '2.5 acres',
        'crops': ['Tomato', 'Onion', 'Potato'],
        'experience': '5 years',
        'soilType': 'Red Soil',
        'irrigationType': 'Drip Irrigation',
      };

      const mockAchievements = [
        {
          'id': '1',
          'title': 'Top Seller',
          'description': 'Sold over 1000kg of produce',
          'icon': 'trophy',
          'date': '2024-01-15',
        },
        {
          'id': '2',
          'title': 'Quality Farmer',
          'description': '5-star rating for 3 months',
          'icon': 'star',
          'date': '2023-12-01',
        },
      ];

      const mockRecentActivity = [
        {
          'id': '1',
          'type': 'product_listed',
          'title': 'Listed Fresh Tomatoes',
          'description': '500kg available for sale',
          'timestamp': '2024-01-20T10:30:00Z',
          'icon': 'add_shopping_cart',
        },
        {
          'id': '2',
          'type': 'order_received',
          'title': 'New Order Received',
          'description': 'Order for 100kg Onions',
          'timestamp': '2024-01-19T15:45:00Z',
          'icon': 'shopping_bag',
        },
        {
          'id': '3',
          'type': 'payment_received',
          'title': 'Payment Received',
          'description': '₹5,000 for Potato sale',
          'timestamp': '2024-01-18T09:15:00Z',
          'icon': 'payment',
        },
      ];

      emit(ProfileLoaded(
        name: mockProfile['name']!,
        email: mockProfile['email']!,
        phone: mockProfile['phoneNumber']!,
        location: mockProfile['location']!,
        profileImageUrl: mockProfile['profilePicture'] ?? '',
        farmDetails: mockFarmDetails,
        profile: mockProfile,
        stats: mockStats,
        achievements: mockAchievements,
        recentActivity: mockRecentActivity,
      ));
    } catch (e) {
      emit(ProfileError('Failed to refresh profile: $e'));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      // * Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // ! TODO: Replace with actual API call
      // For now, just return updated profile with new data
      final updatedProfile = {
        'name': event.profileData['name'] ?? 'Ravi Kumar',
        'phoneNumber': event.profileData['phoneNumber'] ?? '+91 9876543210',
        'email': event.profileData['email'] ?? 'ravi.kumar@example.com',
        'location': event.profileData['location'] ?? 'Bangalore, Karnataka',
        'profilePicture': event.profileData['profilePicture'],
        'verificationStatus': 'verified',
        'memberSince': '2023-01-15',
      };

      const mockStats = {
        'totalProducts': 12,
        'totalSales': 25,
        'totalIncome': 45000,
        'rating': 4.8,
      };

      final updatedFarmDetails = event.profileData['farmDetails'] ?? {
        'area': '2.5 acres',
        'crops': ['Tomato', 'Onion', 'Potato'],
        'experience': '5 years',
        'soilType': 'Red Soil',
        'irrigationType': 'Drip Irrigation',
      };

      const mockAchievements = [
        {
          'id': '1',
          'title': 'Top Seller',
          'description': 'Sold over 1000kg of produce',
          'icon': 'trophy',
          'date': '2024-01-15',
        },
        {
          'id': '2',
          'title': 'Quality Farmer',
          'description': '5-star rating for 3 months',
          'icon': 'star',
          'date': '2023-12-01',
        },
      ];

      const mockRecentActivity = [
        {
          'id': '1',
          'type': 'product_listed',
          'title': 'Listed Fresh Tomatoes',
          'description': '500kg available for sale',
          'timestamp': '2024-01-20T10:30:00Z',
          'icon': 'add_shopping_cart',
        },
        {
          'id': '2',
          'type': 'order_received',
          'title': 'New Order Received',
          'description': 'Order for 100kg Onions',
          'timestamp': '2024-01-19T15:45:00Z',
          'icon': 'shopping_bag',
        },
      ];

      emit(ProfileLoaded(
        name: updatedProfile['name']!,
        email: updatedProfile['email']!,
        phone: updatedProfile['phoneNumber']!,
        location: updatedProfile['location']!,
        profileImageUrl: updatedProfile['profilePicture'] ?? '',
        farmDetails: updatedFarmDetails,
        profile: updatedProfile,
        stats: mockStats,
        achievements: mockAchievements,
        recentActivity: mockRecentActivity,
      ));
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e'));
    }
  }

  Future<void> _onLogoutUser(
    LogoutUser event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    try {
      // * Simulate logout delay
      await Future.delayed(const Duration(seconds: 1));
      
      // ! TODO: Clear authentication tokens and user data
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError('Failed to logout: $e'));
    }
  }
} 