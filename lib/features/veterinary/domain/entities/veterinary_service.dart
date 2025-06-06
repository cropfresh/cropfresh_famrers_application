/// * VETERINARY SERVICE ENTITY
/// * Domain model for veterinary services functionality
class VeterinaryService {
  final String id;
  final String vetId;
  final String farmerId;
  final ServiceType serviceType;
  final DateTime scheduledAt;
  final ServiceStatus status;
  final List<String> animalIds;
  final String symptoms;
  final double cost;
  final String? diagnosis;
  final String? prescription;
  final List<String> photoUrls;
  final bool isEmergency;

  const VeterinaryService({
    required this.id,
    required this.vetId,
    required this.farmerId,
    required this.serviceType,
    required this.scheduledAt,
    required this.status,
    required this.animalIds,
    required this.symptoms,
    required this.cost,
    this.diagnosis,
    this.prescription,
    required this.photoUrls,
    required this.isEmergency,
  });
}

/// * SERVICE TYPE ENUM
enum ServiceType {
  consultation,
  vaccination,
  artificialInsemination,
  emergency,
  surgery,
  healthCheckup,
}

/// * SERVICE STATUS ENUM
enum ServiceStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

/// * VETERINARIAN ENTITY
class Veterinarian {
  final String id;
  final String name;
  final String qualification;
  final List<String> specializations;
  final double rating;
  final int totalConsultations;
  final double latitude;
  final double longitude;
  final String address;
  final List<ServiceType> servicesOffered;
  final bool isAvailable;
  final bool offersEmergency;
  final List<String> workingHours;

  const Veterinarian({
    required this.id,
    required this.name,
    required this.qualification,
    required this.specializations,
    required this.rating,
    required this.totalConsultations,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.servicesOffered,
    required this.isAvailable,
    required this.offersEmergency,
    required this.workingHours,
  });
}

/// * ANIMAL ENTITY
class Animal {
  final String id;
  final String farmerId;
  final AnimalType type;
  final String breed;
  final String name;
  final DateTime birthDate;
  final String gender;
  final double weight;
  final String tagNumber;
  final List<VaccinationRecord> vaccinations;
  final List<HealthRecord> healthHistory;
  final String? currentStatus;

  const Animal({
    required this.id,
    required this.farmerId,
    required this.type,
    required this.breed,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.weight,
    required this.tagNumber,
    required this.vaccinations,
    required this.healthHistory,
    this.currentStatus,
  });
}

/// * ANIMAL TYPE ENUM
enum AnimalType {
  cattle,
  buffalo,
  goat,
  sheep,
  pig,
  poultry,
}

/// * VACCINATION RECORD
class VaccinationRecord {
  final String vaccineType;
  final DateTime dateGiven;
  final DateTime nextDue;
  final String vetId;
  final String batchNumber;

  const VaccinationRecord({
    required this.vaccineType,
    required this.dateGiven,
    required this.nextDue,
    required this.vetId,
    required this.batchNumber,
  });
}

/// * HEALTH RECORD
class HealthRecord {
  final DateTime date;
  final String symptoms;
  final String diagnosis;
  final String treatment;
  final String vetId;
  final List<String> photoUrls;

  const HealthRecord({
    required this.date,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.vetId,
    required this.photoUrls,
  });
} 