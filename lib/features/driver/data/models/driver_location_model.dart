import '../../domain/entities/driver_location.dart';

class DriverLocationModel extends DriverLocation {
  DriverLocationModel({
    required super.driverId,
    required super.latitude,
    required super.longitude,
    required super.timestamp,
    super.isAvailable,
    super.heading,
    super.speed,
  });

  factory DriverLocationModel.fromJson(Map<String, dynamic> json) {
    return DriverLocationModel(
      driverId: json['driver_id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      isAvailable: json['is_available'] ?? false,
      heading: json['heading']?.toDouble(),
      speed: json['speed']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'is_available': isAvailable,
      if (heading != null) 'heading': heading,
      if (speed != null) 'speed': speed,
    };
  }
}
