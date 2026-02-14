class DriverProfile {
  final int userId;
  final String? licenseNumber;
  final String? idPhotoUrl;
  final DriverStatus validationStatus;
  final double averageRating;
  final int totalRides;

  DriverProfile({
    required this.userId,
    this.licenseNumber,
    this.idPhotoUrl,
    this.validationStatus = DriverStatus.pending,
    this.averageRating = 0.0,
    this.totalRides = 0,
  });
}

enum DriverStatus {
  pending,    // En attente de validation
  approved,   // Validé
  rejected,   // Rejeté
  suspended,  // Suspendu
}

// Extension pour convertir l'enum en string et vice versa
extension DriverStatusExtension on DriverStatus {
  String get value {
    switch (this) {
      case DriverStatus.pending:
        return 'pending';
      case DriverStatus.approved:
        return 'approved';
      case DriverStatus.rejected:
        return 'rejected';
      case DriverStatus.suspended:
        return 'suspended';
    }
  }

  static DriverStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return DriverStatus.approved;
      case 'rejected':
        return DriverStatus.rejected;
      case 'suspended':
        return DriverStatus.suspended;
      default:
        return DriverStatus.pending;
    }
  }
}
