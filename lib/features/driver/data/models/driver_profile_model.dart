import '../../domain/entities/driver_profile.dart';

class DriverProfileModel extends DriverProfile {
  DriverProfileModel({
    required super.userId,
    super.licenseNumber,
    super.idPhotoUrl,
    super.validationStatus,
    super.averageRating,
    super.totalRides,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      userId: json['user_id'],
      licenseNumber: json['numero_permis'],
      idPhotoUrl: json['photo_piece_identite'],
      validationStatus: DriverStatusExtension.fromString(
        json['statut_validation'] ?? 'pending',
      ),
      averageRating: (json['note_moyenne'] ?? 0.0).toDouble(),
      totalRides: json['total_rides'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'numero_permis': licenseNumber,
      'photo_piece_identite': idPhotoUrl,
      'statut_validation': validationStatus.value,
      'note_moyenne': averageRating,
      'total_rides': totalRides,
    };
  }
}
