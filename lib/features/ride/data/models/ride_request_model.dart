import '../../domain/entities/ride_request.dart';

class RideRequestModel extends RideRequest {
  RideRequestModel({
    super.id,
    required super.passengerId,
    super.driverId,
    required super.departLat,
    required super.departLng,
    required super.arriveeLat,
    required super.arriveeLng,
    required super.distanceKm,
    required super.prixPoints,
    required super.vehicleType,
    required super.statut,
    super.createdAt,
    super.updatedAt,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      id: json['id'] ?? json['id_course'],
      passengerId: json['id_passager'] ?? json['passengerId'],
      driverId: json['id_chauffeur'] ?? json['driverId'],
      departLat: (json['depart_lat'] ?? json['departLat']).toDouble(),
      departLng: (json['depart_lng'] ?? json['departLng']).toDouble(),
      arriveeLat: (json['arrivee_lat'] ?? json['arriveeLat']).toDouble(),
      arriveeLng: (json['arrivee_lng'] ?? json['arriveeLng']).toDouble(),
      distanceKm: (json['distance_km'] ?? json['distanceKm']).toDouble(),
      prixPoints: json['prix_points'] ?? json['prixPoints'],
      vehicleType: json['vehicle_type'] ?? json['vehicleType'] ?? 'Standard',
      statut: json['statut'] ?? json['status'] ?? RideRequest.statusPending,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_course': id,
      'id_passager': passengerId,
      if (driverId != null) 'id_chauffeur': driverId,
      'depart_lat': departLat,
      'depart_lng': departLng,
      'arrivee_lat': arriveeLat,
      'arrivee_lng': arriveeLng,
      'distance_km': distanceKm,
      'prix_en_points': prixPoints, // Backend expects 'prix_en_points' not 'prix_points'
      'vehicle_type': vehicleType,
      'statut': statut,
    };
  }

  factory RideRequestModel.fromEntity(RideRequest entity) {
    return RideRequestModel(
      id: entity.id,
      passengerId: entity.passengerId,
      driverId: entity.driverId,
      departLat: entity.departLat,
      departLng: entity.departLng,
      arriveeLat: entity.arriveeLat,
      arriveeLng: entity.arriveeLng,
      distanceKm: entity.distanceKm,
      prixPoints: entity.prixPoints,
      vehicleType: entity.vehicleType,
      statut: entity.statut,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  RideRequestModel copyWith({
    int? id,
    int? passengerId,
    int? driverId,
    double? departLat,
    double? departLng,
    double? arriveeLat,
    double? arriveeLng,
    double? distanceKm,
    int? prixPoints,
    String? vehicleType,
    String? statut,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RideRequestModel(
      id: id ?? this.id,
      passengerId: passengerId ?? this.passengerId,
      driverId: driverId ?? this.driverId,
      departLat: departLat ?? this.departLat,
      departLng: departLng ?? this.departLng,
      arriveeLat: arriveeLat ?? this.arriveeLat,
      arriveeLng: arriveeLng ?? this.arriveeLng,
      distanceKm: distanceKm ?? this.distanceKm,
      prixPoints: prixPoints ?? this.prixPoints,
      vehicleType: vehicleType ?? this.vehicleType,
      statut: statut ?? this.statut,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
