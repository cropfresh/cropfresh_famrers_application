// * LIVESTOCK ENTITY - ANIMAL MANAGEMENT MODEL
// * Purpose: Represents individual animals in farmer's livestock inventory
// ! SECURITY: Contains sensitive animal health and breeding data

import 'package:equatable/equatable.dart';

/// Livestock entity representing individual animals
class Livestock extends Equatable {
  final String id;
  final String farmerId;
  final String species; // cattle, buffalo, goat, sheep, pig, poultry
  final String breed;
  final String? tagNumber;
  final String? rfidNumber;
  final String gender; // male, female
  final DateTime? birthDate;
  final DateTime acquisitionDate;
  final String acquisitionType; // born, purchased, gifted
  final double? acquisitionCost;
  final String? motherTagNumber;
  final String? fatherTagNumber;
  final double? currentWeight;
  final String healthStatus; // healthy, sick, under_treatment, quarantine
  final String productionStatus; // producing, dry, pregnant, breeding
  final List<String> imageUrls;
  final Map<String, dynamic>? physicalCharacteristics;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // * ADDITIONAL LIVESTOCK DETAILS
  final String? currentLocation; // barn, field, medical_facility
  final bool isInsured;
  final String? insurancePolicyNumber;
  final double? insuranceValue;
  final bool isPregnant;
  final DateTime? expectedDeliveryDate;
  final int totalOffspring;
  final double? averageMilkYield; // liters per day for dairy animals
  final String? feedType;
  final double? dailyFeedCost;
  final double? marketValue;
  final String? specialNotes;
  
  const Livestock({
    required this.id,
    required this.farmerId,
    required this.species,
    required this.breed,
    this.tagNumber,
    this.rfidNumber,
    required this.gender,
    this.birthDate,
    required this.acquisitionDate,
    required this.acquisitionType,
    this.acquisitionCost,
    this.motherTagNumber,
    this.fatherTagNumber,
    this.currentWeight,
    required this.healthStatus,
    required this.productionStatus,
    required this.imageUrls,
    this.physicalCharacteristics,
    required this.createdAt,
    required this.updatedAt,
    this.currentLocation,
    this.isInsured = false,
    this.insurancePolicyNumber,
    this.insuranceValue,
    this.isPregnant = false,
    this.expectedDeliveryDate,
    this.totalOffspring = 0,
    this.averageMilkYield,
    this.feedType,
    this.dailyFeedCost,
    this.marketValue,
    this.specialNotes,
  });
  
  // * COMPUTED PROPERTIES
  bool get isHealthy => healthStatus == 'healthy';
  bool get isSick => healthStatus == 'sick' || healthStatus == 'under_treatment';
  bool get isProducing => productionStatus == 'producing';
  bool get isDairy => species == 'cattle' || species == 'buffalo' || species == 'goat';
  bool get hasImages => imageUrls.isNotEmpty;
  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';
  
  // Calculate age in months
  int? get ageInMonths {
    if (birthDate == null) return null;
    final now = DateTime.now();
    final difference = now.difference(birthDate!);
    return (difference.inDays / 30).floor();
  }
  
  // Calculate age in years
  double? get ageInYears {
    if (birthDate == null) return null;
    final now = DateTime.now();
    final difference = now.difference(birthDate!);
    return difference.inDays / 365.25;
  }
  
  // Get display name (tag number or ID)
  String get displayName => tagNumber ?? 'Animal-${id.substring(0, 8)}';
  
  // * COPY WITH METHOD FOR UPDATES
  Livestock copyWith({
    String? id,
    String? farmerId,
    String? species,
    String? breed,
    String? tagNumber,
    String? rfidNumber,
    String? gender,
    DateTime? birthDate,
    DateTime? acquisitionDate,
    String? acquisitionType,
    double? acquisitionCost,
    String? motherTagNumber,
    String? fatherTagNumber,
    double? currentWeight,
    String? healthStatus,
    String? productionStatus,
    List<String>? imageUrls,
    Map<String, dynamic>? physicalCharacteristics,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? currentLocation,
    bool? isInsured,
    String? insurancePolicyNumber,
    double? insuranceValue,
    bool? isPregnant,
    DateTime? expectedDeliveryDate,
    int? totalOffspring,
    double? averageMilkYield,
    String? feedType,
    double? dailyFeedCost,
    double? marketValue,
    String? specialNotes,
  }) {
    return Livestock(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      tagNumber: tagNumber ?? this.tagNumber,
      rfidNumber: rfidNumber ?? this.rfidNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      acquisitionType: acquisitionType ?? this.acquisitionType,
      acquisitionCost: acquisitionCost ?? this.acquisitionCost,
      motherTagNumber: motherTagNumber ?? this.motherTagNumber,
      fatherTagNumber: fatherTagNumber ?? this.fatherTagNumber,
      currentWeight: currentWeight ?? this.currentWeight,
      healthStatus: healthStatus ?? this.healthStatus,
      productionStatus: productionStatus ?? this.productionStatus,
      imageUrls: imageUrls ?? this.imageUrls,
      physicalCharacteristics: physicalCharacteristics ?? this.physicalCharacteristics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentLocation: currentLocation ?? this.currentLocation,
      isInsured: isInsured ?? this.isInsured,
      insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceValue: insuranceValue ?? this.insuranceValue,
      isPregnant: isPregnant ?? this.isPregnant,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      totalOffspring: totalOffspring ?? this.totalOffspring,
      averageMilkYield: averageMilkYield ?? this.averageMilkYield,
      feedType: feedType ?? this.feedType,
      dailyFeedCost: dailyFeedCost ?? this.dailyFeedCost,
      marketValue: marketValue ?? this.marketValue,
      specialNotes: specialNotes ?? this.specialNotes,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    farmerId,
    species,
    breed,
    tagNumber,
    rfidNumber,
    gender,
    birthDate,
    acquisitionDate,
    acquisitionType,
    acquisitionCost,
    motherTagNumber,
    fatherTagNumber,
    currentWeight,
    healthStatus,
    productionStatus,
    imageUrls,
    physicalCharacteristics,
    createdAt,
    updatedAt,
    currentLocation,
    isInsured,
    insurancePolicyNumber,
    insuranceValue,
    isPregnant,
    expectedDeliveryDate,
    totalOffspring,
    averageMilkYield,
    feedType,
    dailyFeedCost,
    marketValue,
    specialNotes,
  ];
}

// * ENUMS FOR LIVESTOCK MANAGEMENT

enum LivestockSpecies {
  cattle('cattle', 'Cattle'),
  buffalo('buffalo', 'Buffalo'),
  goat('goat', 'Goat'),
  sheep('sheep', 'Sheep'),
  pig('pig', 'Pig'),
  poultry('poultry', 'Poultry');
  
  const LivestockSpecies(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum LivestockGender {
  male('male', 'Male'),
  female('female', 'Female');
  
  const LivestockGender(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum HealthStatus {
  healthy('healthy', 'Healthy'),
  sick('sick', 'Sick'),
  underTreatment('under_treatment', 'Under Treatment'),
  quarantine('quarantine', 'Quarantine'),
  deceased('deceased', 'Deceased');
  
  const HealthStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ProductionStatus {
  producing('producing', 'Producing'),
  dry('dry', 'Dry'),
  pregnant('pregnant', 'Pregnant'),
  breeding('breeding', 'Breeding'),
  young('young', 'Young'),
  retired('retired', 'Retired');
  
  const ProductionStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum AcquisitionType {
  born('born', 'Born on Farm'),
  purchased('purchased', 'Purchased'),
  gifted('gifted', 'Gifted'),
  leased('leased', 'Leased');
  
  const AcquisitionType(this.value, this.displayName);
  final String value;
  final String displayName;
} 