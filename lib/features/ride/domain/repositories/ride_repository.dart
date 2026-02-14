import '../entities/ride.dart';

abstract class RideRepository {
  Future<Ride> requestRide({
    required String pickupLocation,
    required String dropoffLocation,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  });
  
  Future<Ride> acceptRide(int rideId);
  Future<Ride> startRide(int rideId);
  Future<Ride> completeRide(int rideId);
  Future<Ride> getRideDetails(int rideId);
  Future<List<Ride>> getRideHistory();
}
