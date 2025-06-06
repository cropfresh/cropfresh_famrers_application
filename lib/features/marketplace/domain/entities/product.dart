// * PRODUCT ENTITY - CORE BUSINESS MODEL
// * Purpose: Represents a marketplace product with all related information
// ! SECURITY: Contains sensitive data like pricing and location information

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String farmerId;
  final String cropType;
  final String variety;
  final double quantity;
  final String unit;
  final String? qualityGrade;
  final double basePrice;
  final String pricingType;
  final String? description;
  final DateTime? harvestDate;
  final DateTime availableFrom;
  final DateTime? availableUntil;
  final double? farmLatitude;
  final double? farmLongitude;
  final String status;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // * ADDITIONAL PRODUCT DETAILS
  final String? farmAddress;
  final bool isOrganic;
  final bool isCertified;
  final String? certificationDetails;
  final Map<String, dynamic>? nutritionalInfo;
  final String? packagingType;
  final double? minimumOrderQuantity;
  final int viewCount;
  final int inquiryCount;
  final double? rating;
  final int ratingCount;
  
  // * FARMER INFORMATION (for display)
  final String? farmerName;
  final String? farmerPhone;
  final double? farmerRating;
  final bool isVerifiedFarmer;
  
  const Product({
    required this.id,
    required this.farmerId,
    required this.cropType,
    required this.variety,
    required this.quantity,
    required this.unit,
    this.qualityGrade,
    required this.basePrice,
    required this.pricingType,
    this.description,
    this.harvestDate,
    required this.availableFrom,
    this.availableUntil,
    this.farmLatitude,
    this.farmLongitude,
    required this.status,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    this.farmAddress,
    this.isOrganic = false,
    this.isCertified = false,
    this.certificationDetails,
    this.nutritionalInfo,
    this.packagingType,
    this.minimumOrderQuantity,
    this.viewCount = 0,
    this.inquiryCount = 0,
    this.rating,
    this.ratingCount = 0,
    this.farmerName,
    this.farmerPhone,
    this.farmerRating,
    this.isVerifiedFarmer = false,
  });
  
  // * COMPUTED PROPERTIES
  bool get isNegotiable => pricingType == 'negotiable';
  bool get isAuction => pricingType == 'auction';
  bool get isActive => status == 'active';
  bool get isAvailable => DateTime.now().isAfter(availableFrom) && 
                          (availableUntil == null || DateTime.now().isBefore(availableUntil!));
  bool get hasImages => imageUrls.isNotEmpty;
  bool get hasLocation => farmLatitude != null && farmLongitude != null;
  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';
  
  // * COPY WITH METHOD FOR UPDATES
  Product copyWith({
    String? id,
    String? farmerId,
    String? cropType,
    String? variety,
    double? quantity,
    String? unit,
    String? qualityGrade,
    double? basePrice,
    String? pricingType,
    String? description,
    DateTime? harvestDate,
    DateTime? availableFrom,
    DateTime? availableUntil,
    double? farmLatitude,
    double? farmLongitude,
    String? status,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? farmAddress,
    bool? isOrganic,
    bool? isCertified,
    String? certificationDetails,
    Map<String, dynamic>? nutritionalInfo,
    String? packagingType,
    double? minimumOrderQuantity,
    int? viewCount,
    int? inquiryCount,
    double? rating,
    int? ratingCount,
    String? farmerName,
    String? farmerPhone,
    double? farmerRating,
    bool? isVerifiedFarmer,
  }) {
    return Product(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      cropType: cropType ?? this.cropType,
      variety: variety ?? this.variety,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      qualityGrade: qualityGrade ?? this.qualityGrade,
      basePrice: basePrice ?? this.basePrice,
      pricingType: pricingType ?? this.pricingType,
      description: description ?? this.description,
      harvestDate: harvestDate ?? this.harvestDate,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
      farmLatitude: farmLatitude ?? this.farmLatitude,
      farmLongitude: farmLongitude ?? this.farmLongitude,
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      farmAddress: farmAddress ?? this.farmAddress,
      isOrganic: isOrganic ?? this.isOrganic,
      isCertified: isCertified ?? this.isCertified,
      certificationDetails: certificationDetails ?? this.certificationDetails,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      packagingType: packagingType ?? this.packagingType,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      viewCount: viewCount ?? this.viewCount,
      inquiryCount: inquiryCount ?? this.inquiryCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      farmerName: farmerName ?? this.farmerName,
      farmerPhone: farmerPhone ?? this.farmerPhone,
      farmerRating: farmerRating ?? this.farmerRating,
      isVerifiedFarmer: isVerifiedFarmer ?? this.isVerifiedFarmer,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    farmerId,
    cropType,
    variety,
    quantity,
    unit,
    qualityGrade,
    basePrice,
    pricingType,
    description,
    harvestDate,
    availableFrom,
    availableUntil,
    farmLatitude,
    farmLongitude,
    status,
    imageUrls,
    createdAt,
    updatedAt,
    farmAddress,
    isOrganic,
    isCertified,
    certificationDetails,
    nutritionalInfo,
    packagingType,
    minimumOrderQuantity,
    viewCount,
    inquiryCount,
    rating,
    ratingCount,
    farmerName,
    farmerPhone,
    farmerRating,
    isVerifiedFarmer,
  ];
  
  @override
  String toString() => 'Product(id: $id, cropType: $cropType, variety: $variety, quantity: $quantity $unit, price: ₹$basePrice)';
}

// * PRODUCT STATUS ENUM
enum ProductStatus {
  draft,
  active,
  sold,
  expired,
  removed;
  
  String get displayName {
    switch (this) {
      case ProductStatus.draft:
        return 'Draft';
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.sold:
        return 'Sold';
      case ProductStatus.expired:
        return 'Expired';
      case ProductStatus.removed:
        return 'Removed';
    }
  }
}

// * PRICING TYPE ENUM
enum PricingType {
  fixed,
  negotiable,
  auction;
  
  String get displayName {
    switch (this) {
      case PricingType.fixed:
        return 'Fixed Price';
      case PricingType.negotiable:
        return 'Negotiable';
      case PricingType.auction:
        return 'Auction';
    }
  }
}

// * QUALITY GRADE ENUM
enum QualityGrade {
  premium,
  gradeA,
  gradeB,
  gradeC;
  
  String get displayName {
    switch (this) {
      case QualityGrade.premium:
        return 'Premium';
      case QualityGrade.gradeA:
        return 'Grade A';
      case QualityGrade.gradeB:
        return 'Grade B';
      case QualityGrade.gradeC:
        return 'Grade C';
    }
  }
  
  String get description {
    switch (this) {
      case QualityGrade.premium:
        return 'Highest quality with perfect appearance and taste';
      case QualityGrade.gradeA:
        return 'Excellent quality with minor imperfections';
      case QualityGrade.gradeB:
        return 'Good quality suitable for most uses';
      case QualityGrade.gradeC:
        return 'Fair quality, good for processing';
    }
  }
} 