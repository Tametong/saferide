class RideRequest {
  final int? id;
  final int passengerId;
  final int? driverId;
  final double departLat;
  final double departLng;
  final double arriveeLat;
  final double arriveeLng;
  final double distanceKm;
  final int prixPoints;
  final String vehicleType;
  final String statut;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RideRequest({
    this.id,
    required this.passengerId,
    this.driverId,
    required this.departLat,
    required this.departLng,
    required this.arriveeLat,
    required this.arriveeLng,
    required this.distanceKm,
    required this.prixPoints,
    required this.vehicleType,
    required this.statut,
    this.createdAt,
    this.updatedAt,
  });

  // Statuts possibles
  static const String statusPending = 'en_attente';
  static const String statusAccepted = 'acceptee';
  static const String statusDriverEnRoute = 'chauffeur_en_route';
  static const String statusDriverArrived = 'chauffeur_arrive';
  static const String statusInProgress = 'en_cours';
  static const String statusCompleted = 'terminee';
  static const String statusCancelled = 'annulee';

  RideRequest copyWith({
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
    return RideRequest(
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
