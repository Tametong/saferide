import 'dart:math' as math;

class DriverLocation {
  final int driverId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final bool isAvailable;
  final double? heading; // Direction du véhicule (optionnel)
  final double? speed; // Vitesse (optionnel)

  DriverLocation({
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.isAvailable = false,
    this.heading,
    this.speed,
  });

  // Calculer la distance entre deux points (en km)
  double distanceTo(double lat, double lon) {
    const double earthRadius = 6371; // Rayon de la Terre en km
    
    final dLat = _toRadians(lat - latitude);
    final dLon = _toRadians(lon - longitude);
    
    final a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(latitude)) * math.cos(_toRadians(lat)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
