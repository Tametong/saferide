import '../entities/sos_event.dart';

abstract class SafetyRepository {
  Future<SosEvent> triggerSos({
    required double latitude,
    required double longitude,
    int? rideId,
    String? description,
  });
  
  Future<void> shareTripLocation({
    required int rideId,
    required String contactPhone,
  });
  
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  });
}
