class SosEvent {
  final int id;
  final int userId;
  final int? rideId;
  final double latitude;
  final double longitude;
  final String status;
  final String? description;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  SosEvent({
    required this.id,
    required this.userId,
    this.rideId,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.description,
    required this.createdAt,
    this.resolvedAt,
  });
}
