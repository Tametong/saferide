import '../../domain/entities/ride.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/ride_remote_datasource.dart';

class RideRepositoryImpl implements RideRepository {
  final RideRemoteDataSource remoteDataSource;

  RideRepositoryImpl(this.remoteDataSource);

  @override
  Future<Ride> requestRide({
    required String pickupLocation,
    required String dropoffLocation,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  }) {
    return remoteDataSource.requestRide(
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
    );
  }

  @override
  Future<Ride> acceptRide(int rideId) {
    return remoteDataSource.acceptRide(rideId);
  }

  @override
  Future<Ride> startRide(int rideId) {
    return remoteDataSource.startRide(rideId);
  }

  @override
  Future<Ride> completeRide(int rideId) {
    return remoteDataSource.completeRide(rideId);
  }

  @override
  Future<Ride> getRideDetails(int rideId) {
    return remoteDataSource.getRideDetails(rideId);
  }

  @override
  Future<List<Ride>> getRideHistory() {
    return remoteDataSource.getRideHistory();
  }
}
