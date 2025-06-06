// * LOGISTICS BOOKING ENTITY - REPRESENTS TRANSPORTATION BOOKINGS
// * Purpose: Represents a booking request for transportation services
// ! SECURITY: Contains location data and transaction information

import 'package:equatable/equatable.dart';

class LogisticsBooking extends Equatable {
  final String id;
  final String farmerId;
  final String providerId;
  final String? vehicleId;
  final String? productId;
  final double pickupLatitude;
  final double pickupLongitude;
  final String? pickupAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String? deliveryAddress;
  final DateTime scheduledDateTime;
  final String status;
  final double? totalPrice;
  final double? estimatedWeight;
  final double? estimatedVolume;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // * PROVIDER INFORMATION
  final String? providerName;
  final String? providerPhone;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  
  // * BOOKING DETAILS
  final String? vehicleType;
  final bool requiresRefrigeration;
  final bool requiresLoadingAssistance;
  final String? packageDescription;
  final Map<String, dynamic>? additionalServices;
  
  // * PAYMENT & PRICING
  final double? basePrice;
  final double? distanceKm;
  final double? additionalCharges;
  final String? paymentMethod;
  final String? paymentStatus;
  
  // * TRACKING INFORMATION
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final List<String>? trackingPhotos;
  final String? deliveryProof;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  
  // * RATINGS & FEEDBACK
  final double? farmerRating;
  final double? providerRating;
  final String? farmerFeedback;
  final String? providerFeedback;
  
  const LogisticsBooking({
    required this.id,
    required this.farmerId,
    required this.providerId,
    this.vehicleId,
    this.productId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    this.pickupAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    this.deliveryAddress,
    required this.scheduledDateTime,
    required this.status,
    this.totalPrice,
    this.estimatedWeight,
    this.estimatedVolume,
    this.specialInstructions,
    required this.createdAt,
    this.updatedAt,
    this.providerName,
    this.providerPhone,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.vehicleType,
    this.requiresRefrigeration = false,
    this.requiresLoadingAssistance = false,
    this.packageDescription,
    this.additionalServices,
    this.basePrice,
    this.distanceKm,
    this.additionalCharges,
    this.paymentMethod,
    this.paymentStatus,
    this.pickupTime,
    this.deliveryTime,
    this.trackingPhotos,
    this.deliveryProof,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.farmerRating,
    this.providerRating,
    this.farmerFeedback,
    this.providerFeedback,
  });
  
  // * COMPUTED PROPERTIES
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in_progress' || status == 'picked_up' || status == 'in_transit';
  bool get isCompleted => status == 'delivered' || status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get canBeCancelled => isPending || isConfirmed;
  bool get canBeTracked => isInProgress;
  bool get requiresRating => isCompleted && (farmerRating == null || providerRating == null);
  Duration get estimatedDuration => scheduledDateTime.difference(DateTime.now());
  bool get isOverdue => DateTime.now().isAfter(scheduledDateTime) && !isCompleted;
  
  // * COPY WITH METHOD
  LogisticsBooking copyWith({
    String? id,
    String? farmerId,
    String? providerId,
    String? vehicleId,
    String? productId,
    double? pickupLatitude,
    double? pickupLongitude,
    String? pickupAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? deliveryAddress,
    DateTime? scheduledDateTime,
    String? status,
    double? totalPrice,
    double? estimatedWeight,
    double? estimatedVolume,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? providerName,
    String? providerPhone,
    String? driverName,
    String? driverPhone,
    String? vehicleNumber,
    String? vehicleType,
    bool? requiresRefrigeration,
    bool? requiresLoadingAssistance,
    String? packageDescription,
    Map<String, dynamic>? additionalServices,
    double? basePrice,
    double? distanceKm,
    double? additionalCharges,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? pickupTime,
    DateTime? deliveryTime,
    List<String>? trackingPhotos,
    String? deliveryProof,
    double? deliveryLatitude,
    double? deliveryLongitude,
    double? farmerRating,
    double? providerRating,
    String? farmerFeedback,
    String? providerFeedback,
  }) {
    return LogisticsBooking(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      providerId: providerId ?? this.providerId,
      vehicleId: vehicleId ?? this.vehicleId,
      productId: productId ?? this.productId,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      estimatedVolume: estimatedVolume ?? this.estimatedVolume,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      providerName: providerName ?? this.providerName,
      providerPhone: providerPhone ?? this.providerPhone,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      requiresRefrigeration: requiresRefrigeration ?? this.requiresRefrigeration,
      requiresLoadingAssistance: requiresLoadingAssistance ?? this.requiresLoadingAssistance,
      packageDescription: packageDescription ?? this.packageDescription,
      additionalServices: additionalServices ?? this.additionalServices,
      basePrice: basePrice ?? this.basePrice,
      distanceKm: distanceKm ?? this.distanceKm,
      additionalCharges: additionalCharges ?? this.additionalCharges,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      pickupTime: pickupTime ?? this.pickupTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      trackingPhotos: trackingPhotos ?? this.trackingPhotos,
      deliveryProof: deliveryProof ?? this.deliveryProof,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      farmerRating: farmerRating ?? this.farmerRating,
      providerRating: providerRating ?? this.providerRating,
      farmerFeedback: farmerFeedback ?? this.farmerFeedback,
      providerFeedback: providerFeedback ?? this.providerFeedback,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    farmerId,
    providerId,
    vehicleId,
    productId,
    pickupLatitude,
    pickupLongitude,
    pickupAddress,
    deliveryLatitude,
    deliveryLongitude,
    deliveryAddress,
    scheduledDateTime,
    status,
    totalPrice,
    estimatedWeight,
    estimatedVolume,
    specialInstructions,
    createdAt,
    updatedAt,
    providerName,
    providerPhone,
    driverName,
    driverPhone,
    vehicleNumber,
    vehicleType,
    requiresRefrigeration,
    requiresLoadingAssistance,
    packageDescription,
    additionalServices,
    basePrice,
    distanceKm,
    additionalCharges,
    paymentMethod,
    paymentStatus,
    pickupTime,
    deliveryTime,
    trackingPhotos,
    deliveryProof,
    deliveryLatitude,
    deliveryLongitude,
    farmerRating,
    providerRating,
    farmerFeedback,
    providerFeedback,
  ];
  
  @override
  String toString() => 'LogisticsBooking(id: $id, provider: $providerName, status: $status)';
}

// * TRACKING EVENT ENTITY
class TrackingEvent extends Equatable {
  final String id;
  final String bookingId;
  final DateTime timestamp;
  final String status;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final List<String>? photos;
  final Map<String, dynamic>? metadata;
  
  const TrackingEvent({
    required this.id,
    required this.bookingId,
    required this.timestamp,
    required this.status,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.photos,
    this.metadata,
  });
  
  // * COMPUTED PROPERTIES
  bool get hasLocation => latitude != null && longitude != null;
  bool get hasPhotos => photos != null && photos!.isNotEmpty;
  
  @override
  List<Object?> get props => [
    id,
    bookingId,
    timestamp,
    status,
    description,
    latitude,
    longitude,
    address,
    photos,
    metadata,
  ];
  
  @override
  String toString() => 'TrackingEvent(status: $status, timestamp: $timestamp)';
}

// * BOOKING STATUS ENUM
enum BookingStatus {
  pending,
  confirmed,
  driverAssigned,
  pickupScheduled,
  inProgress,
  pickedUp,
  inTransit,
  delivered,
  completed,
  cancelled,
  refunded;
  
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending Confirmation';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.driverAssigned:
        return 'Driver Assigned';
      case BookingStatus.pickupScheduled:
        return 'Pickup Scheduled';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.pickedUp:
        return 'Picked Up';
      case BookingStatus.inTransit:
        return 'In Transit';
      case BookingStatus.delivered:
        return 'Delivered';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.refunded:
        return 'Refunded';
    }
  }
  
  String get description {
    switch (this) {
      case BookingStatus.pending:
        return 'Waiting for provider confirmation';
      case BookingStatus.confirmed:
        return 'Booking confirmed by provider';
      case BookingStatus.driverAssigned:
        return 'Driver has been assigned';
      case BookingStatus.pickupScheduled:
        return 'Pickup time has been scheduled';
      case BookingStatus.inProgress:
        return 'Transportation is in progress';
      case BookingStatus.pickedUp:
        return 'Package has been picked up';
      case BookingStatus.inTransit:
        return 'Package is on the way';
      case BookingStatus.delivered:
        return 'Package has been delivered';
      case BookingStatus.completed:
        return 'Transaction completed successfully';
      case BookingStatus.cancelled:
        return 'Booking was cancelled';
      case BookingStatus.refunded:
        return 'Payment has been refunded';
    }
  }
  
  bool get isActive => [
    BookingStatus.confirmed,
    BookingStatus.driverAssigned,
    BookingStatus.pickupScheduled,
    BookingStatus.inProgress,
    BookingStatus.pickedUp,
    BookingStatus.inTransit,
  ].contains(this);
  
  bool get isFinal => [
    BookingStatus.delivered,
    BookingStatus.completed,
    BookingStatus.cancelled,
    BookingStatus.refunded,
  ].contains(this);
} 