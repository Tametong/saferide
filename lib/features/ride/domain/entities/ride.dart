class Ride {
  final int id;
  final int passengerId;
  final int? driverId;
  final String pickupLocation;
  final String dropoffLocation;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String status;
  final double? fare;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Ride({
    required this.id,
    required this.passengerId,
    this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.status,
    this.fare,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
  });
}
