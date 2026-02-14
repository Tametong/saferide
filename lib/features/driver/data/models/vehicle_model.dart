import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    super.id,
    required super.idChauffeur,
    required super.marque,
    required super.modele,
    required super.immatriculation,
    required super.annee,
    required super.couleur,
    required super.typeVehicule,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id_vehicule']?.toString(),
      idChauffeur: json['id_chauffeur']?.toString() ?? '',
      marque: json['marque'] ?? '',
      modele: json['modele'] ?? '',
      immatriculation: json['immatriculation'] ?? '',
      annee: json['annee'] is int 
          ? json['annee'] 
          : int.tryParse(json['annee']?.toString() ?? '2020') ?? 2020,
      couleur: json['couleur'] ?? '',
      typeVehicule: json['type_vehicule'] ?? 'standard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_vehicule': id,
      'id_chauffeur': idChauffeur,
      'marque': marque,
      'modele': modele,
      'immatriculation': immatriculation,
      'annee': annee,
      'couleur': couleur,
      'type_vehicule': typeVehicule,
    };
  }
}
