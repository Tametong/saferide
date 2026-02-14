class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String? profileImage;
  final String? ville;
  final String role; // 'passenger' or 'driver'
  final DriverProfile? driverProfile; // Only for drivers

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.ville,
    this.profileImage,
    required this.role,
    this.driverProfile,
  });

  String get fullName => '$prenom $nom';

  bool get isDriver => role == 'chauffeur';
  bool get isPassenger => role == 'passager';
}

class DriverProfile {
  final String? licenseNumber;
  final String? idPhotoUrl;
  final String validationStatus; // 'pending', 'approved', 'rejected', 'suspended'
  final double averageRating;
  final int totalRides;

  DriverProfile({
    this.licenseNumber,
    this.idPhotoUrl,
    this.validationStatus = 'pending',
    this.averageRating = 0.0,
    this.totalRides = 0,
  });

  bool get isApproved => validationStatus == 'approved';
  bool get isPending => validationStatus == 'pending';
  bool get isRejected => validationStatus == 'rejected';
}
