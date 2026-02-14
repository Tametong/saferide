import '../../domain/entities/ride.dart';

class RideModel extends Ride {
  RideModel({
    required super.id,
    required super.passengerId,
    super.driverId,
    required super.pickupLocation,
    required super.dropoffLocation,
    required super.pickupLat,
    required super.pickupLng,
    required super.dropoffLat,
    required super.dropoffLng,
    required super.status,
    super.fare,
    required super.createdAt,
    super.startedAt,
    super.completedAt,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'],
      passengerId: json['passenger_id'],
      driverId: json['driver_id'],
      pickupLocation: json['pickup_location'],
      dropoffLocation: json['dropoff_location'],
      pickupLat: json['pickup_lat'].toDouble(),
      pickupLng: json['pickup_lng'].toDouble(),
      dropoffLat: json['dropoff_lat'].toDouble(),
      dropoffLng: json['dropoff_lng'].toDouble(),
      status: json['status'],
      fare: json['fare']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'pickup_location': pickupLocation,
      'dropoff_location': dropoffLocation,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
      'status': status,
      'fare': fare,
      'created_at': createdAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
