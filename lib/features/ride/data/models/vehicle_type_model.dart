import '../../domain/entities/vehicle_type.dart';

class VehicleTypeModel extends VehicleType {
  VehicleTypeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.pricePerKm,
    required super.capacity,
    required super.icon,
    required super.basePrice,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'].toString(),
      name: json['name'] ?? json['nom'] ?? '',
      description: json['description'] ?? '',
      pricePerKm: (json['price_per_km'] ?? json['prix_par_km'] ?? 0).toDouble(),
      capacity: json['capacity'] ?? json['capacite'] ?? 4,
      icon: json['icon'] ?? json['icone'] ?? '🚗',
      basePrice: (json['base_price'] ?? json['prix_base'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_km': pricePerKm,
      'capacity': capacity,
      'icon': icon,
      'base_price': basePrice,
    };
  }

  // Types de véhicules par défaut
  static List<VehicleTypeModel> getDefaultTypes() {
    return [
      VehicleTypeModel(
        id: '1',
        name: 'Standard',
        description: 'Voiture standard, confortable',
        pricePerKm: 1, // 1 point/km
        capacity: 4,
        icon: '🚗',
        basePrice: 0,
      ),
      VehicleTypeModel(
        id: '2',
        name: 'Confort',
        description: 'Véhicule haut de gamme',
        pricePerKm: 2, // 2 points/km
        capacity: 4,
        icon: '🚙',
        basePrice: 0,
      ),
      VehicleTypeModel(
        id: '3',
        name: 'Premium',
        description: 'Luxe et confort maximum',
        pricePerKm: 3, // 3 points/km
        capacity: 4,
        icon: '🚘',
        basePrice: 0,
      ),
    ];
  }
}
