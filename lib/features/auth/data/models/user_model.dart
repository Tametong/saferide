import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    super.telephone,
    super.profileImage,
    super.ville,
    required super.role,
    super.driverProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nom: json['name'] ?? json['nom'] ?? '',  // Backend utilise 'name'
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone']?.toString(),
      ville: json['ville'],
      profileImage: json['profile_image'],
      role: json['role'] ?? 'passager',
      driverProfile: json['driver_profile'] != null
          ? DriverProfileModel.fromJson(json['driver_profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'ville': ville,
      'profile_image': profileImage,
      'role': role,
      if (driverProfile != null)
        'driver_profile': DriverProfileModel.fromDriverProfile(driverProfile!).toJson(),
    };
  }
}

class DriverProfileModel extends DriverProfile {
  DriverProfileModel({
    super.licenseNumber,
    super.idPhotoUrl,
    super.validationStatus,
    super.averageRating,
    super.totalRides,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      licenseNumber: json['numero_permis'],
      idPhotoUrl: json['photo_piece_identite'],
      validationStatus: json['statut_validation'] ?? 'pending',
      averageRating: (json['note_moyenne'] ?? 0.0).toDouble(),
      totalRides: json['total_rides'] ?? 0,
    );
  }

  factory DriverProfileModel.fromDriverProfile(DriverProfile profile) {
    return DriverProfileModel(
      licenseNumber: profile.licenseNumber,
      idPhotoUrl: profile.idPhotoUrl,
      validationStatus: profile.validationStatus,
      averageRating: profile.averageRating,
      totalRides: profile.totalRides,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero_permis': licenseNumber,
      'photo_piece_identite': idPhotoUrl,
      'statut_validation': validationStatus,
      'note_moyenne': averageRating,
      'total_rides': totalRides,
    };
  }
}
