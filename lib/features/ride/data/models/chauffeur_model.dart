import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entities/available_driver.dart';

class ChauffeurModel extends AvailableDriver {
  ChauffeurModel({
    required super.id,
    required super.name,
    required super.position,
    required super.vehicleType,
    required super.rating,
    required super.vehicleIcon,
    required super.numeroPermis,
    super.photoPieceIdentite,
    required super.statutValidation,
    required super.estEnLigne,
  });

  factory ChauffeurModel.fromJson(Map<String, dynamic> json) {
    // Extraire latitude et longitude
    final latitude = json['latitude'] != null 
        ? (json['latitude'] is String 
            ? double.tryParse(json['latitude']) ?? 0.0 
            : (json['latitude'] as num).toDouble())
        : 0.0;
    
    final longitude = json['longitude'] != null 
        ? (json['longitude'] is String 
            ? double.tryParse(json['longitude']) ?? 0.0 
            : (json['longitude'] as num).toDouble())
        : 0.0;
    
    // Extraire note moyenne
    final noteMoyenne = json['note_moyenne'] != null 
        ? (json['note_moyenne'] is String 
            ? double.tryParse(json['note_moyenne']) ?? 0.0 
            : (json['note_moyenne'] as num).toDouble())
        : 0.0;
    
    // Extraire est_en_ligne (avec fallback si le champ n'existe pas encore)
    final estEnLigne = json['est_en_ligne'] != null
        ? (json['est_en_ligne'] is bool
            ? json['est_en_ligne']
            : (json['est_en_ligne'] == 1 || json['est_en_ligne'] == '1' || json['est_en_ligne'] == true))
        : true; // Par défaut true si le champ n'existe pas (pour compatibilité)
    
    // Déterminer le type de véhicule et l'icône (par défaut)
    // TODO: À adapter selon les données réelles du backend
    String vehicleType = 'Économique';
    String vehicleIcon = '🚗';
    
    // Extraire le nom depuis l'objet user si disponible
    String name = 'Chauffeur';
    if (json['user'] != null && json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      final nom = user['nom'] ?? '';
      final prenom = user['prenom'] ?? '';
      name = '$prenom $nom'.trim();
      if (name.isEmpty) name = 'Chauffeur';
    }
    
    return ChauffeurModel(
      id: json['id_user']?.toString() ?? '',
      name: name,
      position: LatLng(latitude, longitude),
      vehicleType: vehicleType,
      rating: noteMoyenne,
      vehicleIcon: vehicleIcon,
      numeroPermis: json['numero_permis']?.toString() ?? '',
      photoPieceIdentite: json['photo_piece_identite']?.toString(),
      statutValidation: json['statut_validation']?.toString() ?? 'En attente',
      estEnLigne: estEnLigne,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'numero_permis': numeroPermis,
      'photo_piece_identite': photoPieceIdentite,
      'statut_validation': statutValidation,
      'note_moyenne': rating,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'est_en_ligne': estEnLigne,
    };
  }
}
