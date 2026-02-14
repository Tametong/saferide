import '../../domain/entities/sos_event.dart';
import '../../domain/repositories/safety_repository.dart';
import '../datasources/safety_remote_datasource.dart';

class SafetyRepositoryImpl implements SafetyRepository {
  final SafetyRemoteDataSource remoteDataSource;

  SafetyRepositoryImpl(this.remoteDataSource);

  @override
  Future<SosEvent> triggerSos({
    required double latitude,
    required double longitude,
    int? rideId,
    String? description,
  }) {
    return remoteDataSource.triggerSos(
      latitude: latitude,
      longitude: longitude,
      rideId: rideId,
      description: description,
    );
  }

  @override
  Future<void> shareTripLocation({
    required int rideId,
    required String contactPhone,
  }) {
    return remoteDataSource.shareTripLocation(
      rideId: rideId,
      contactPhone: contactPhone,
    );
  }

  @override
  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) {
    return remoteDataSource.updateLocation(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
