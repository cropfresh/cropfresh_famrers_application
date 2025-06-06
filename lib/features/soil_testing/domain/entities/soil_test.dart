/// * SOIL TEST ENTITY
/// * Domain model for soil testing functionality
class SoilTest {
  final String id;
  final String farmerId;
  final String labId;
  final String testPackageId;
  final SoilTestStatus status;
  final DateTime createdAt;
  final DateTime? sampleCollectedAt;
  final DateTime? resultsCompletedAt;
  final SoilTestLocation sampleLocation;
  final SoilTestResults? results;
  final double totalCost;
  final String? specialInstructions;

  const SoilTest({
    required this.id,
    required this.farmerId,
    required this.labId,
    required this.testPackageId,
    required this.status,
    required this.createdAt,
    this.sampleCollectedAt,
    this.resultsCompletedAt,
    required this.sampleLocation,
    this.results,
    required this.totalCost,
    this.specialInstructions,
  });
}

/// * SOIL TEST STATUS ENUM
enum SoilTestStatus {
  booked,
  sampleCollectionScheduled,
  sampleCollected,
  inProgress,
  completed,
  resultsReady,
  cancelled,
}

/// * SOIL TEST LOCATION
class SoilTestLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String fieldName;
  final String cropHistory;

  const SoilTestLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.fieldName,
    required this.cropHistory,
  });
}

/// * SOIL TEST RESULTS
class SoilTestResults {
  final Map<String, double> parameters;
  final String interpretation;
  final List<String> recommendations;
  final List<String> suitableCrops;
  final String reportUrl;

  const SoilTestResults({
    required this.parameters,
    required this.interpretation,
    required this.recommendations,
    required this.suitableCrops,
    required this.reportUrl,
  });
} 