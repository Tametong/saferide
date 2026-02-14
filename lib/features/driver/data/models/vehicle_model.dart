import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  VehicleModel({
    super.id,
    required super.driverId,
    required super.vehicleType,
    required super.brand,
    required super.model,
    required super.color,
    required super.licensePlate,
    required super.year,
    required super.seats,
    super.isActive,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Mapping backend → frontend
    return VehicleModel(
      id: json['id_vehicule'],
      driverId: json['id_chauffeur'] is int 
          ? json['id_chauffeur'] 
          : int.tryParse(json['id_chauffeur']?.toString() ?? '0') ?? 0,
      vehicleType: json['type'] ?? 'sedan',
      brand: json['marque'] ?? '',
      model: json['modele'] ?? '',
      color: json['couleur'] ?? '',
      licensePlate: json['immatriculation'] ?? '',
      year: json['annee'] is int 
          ? json['annee'] 
          : int.tryParse(json['annee']?.toString() ?? '2020') ?? 2020,
      seats: 4, // Par défaut, peut être ajouté au backend plus tard
      isActive: true,
    );
  }

  Map<String, dynamic> toJson() {
    // Mapping frontend → backend
    return {
      if (id != null) 'id_vehicule': id,
      'id_chauffeur': driverId,
      'type': vehicleType,
      'marque': brand,
      'modele': model,
      'couleur': color,
      'immatriculation': licensePlate,
      'annee': year,
    };
  }
}
