import '../../domain/entities/sos_event.dart';

class SosEventModel extends SosEvent {
  SosEventModel({
    required super.id,
    required super.userId,
    super.rideId,
    required super.latitude,
    required super.longitude,
    required super.status,
    super.description,
    required super.createdAt,
    super.resolvedAt,
  });

  factory SosEventModel.fromJson(Map<String, dynamic> json) {
    return SosEventModel(
      id: json['id'],
      userId: json['user_id'],
      rideId: json['ride_id'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ride_id': rideId,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }
}
