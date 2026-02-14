import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/ride_model.dart';
import 'dart:developer' as developer;

class RideRemoteDataSource {
  final ApiClient apiClient;

  RideRemoteDataSource(this.apiClient);

  Future<RideModel> requestRide({
    required String pickupLocation,
    required String dropoffLocation,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  }) async {
    developer.log('🚗 REQUEST RIDE - Demande de course', name: 'RideDataSource');
    developer.log('📍 Pickup: $pickupLocation ($pickupLat, $pickupLng)', name: 'RideDataSource');
    developer.log('📍 Dropoff: $dropoffLocation ($dropoffLat, $dropoffLng)', name: 'RideDataSource');
    developer.log('🌐 URL: ${ApiConstants.rideRequest}', name: 'RideDataSource');
    
    try {
      final requestData = {
        'pickup_location': pickupLocation,
        'dropoff_location': dropoffLocation,
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'dropoff_lat': dropoffLat,
        'dropoff_lng': dropoffLng,
      };
      
      developer.log('📤 Request data: $requestData', name: 'RideDataSource');
      
      final response = await apiClient.post(
        ApiConstants.rideRequest,
        data: requestData,
      );
      
      developer.log('✅ REQUEST RIDE - Course créée', name: 'RideDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'RideDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'RideDataSource');
      
      // Afficher le message du backend s'il existe
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'RideDataSource');
        }
      }
      
      return RideModel.fromJson(response.data['ride']);
    } catch (e, stackTrace) {
      developer.log('❌ REQUEST RIDE - Erreur', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<RideModel> acceptRide(int rideId) async {
    developer.log('✋ ACCEPT RIDE - Acceptation de course', name: 'RideDataSource');
    developer.log('🆔 Ride ID: $rideId', name: 'RideDataSource');
    developer.log('🌐 URL: ${ApiConstants.rideAccept}', name: 'RideDataSource');
    
    try {
      final response = await apiClient.post(
        ApiConstants.rideAccept,
        data: {'ride_id': rideId},
      );
      
      developer.log('✅ ACCEPT RIDE - Course acceptée', name: 'RideDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'RideDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'RideDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'RideDataSource');
        }
      }
      
      return RideModel.fromJson(response.data['ride']);
    } catch (e, stackTrace) {
      developer.log('❌ ACCEPT RIDE - Erreur', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<RideModel> startRide(int rideId) async {
    developer.log('🏁 START RIDE - Démarrage de course', name: 'RideDataSource');
    developer.log('🆔 Ride ID: $rideId', name: 'RideDataSource');
    developer.log('🌐 URL: ${ApiConstants.rideStart}', name: 'RideDataSource');
    
    try {
      final response = await apiClient.post(
        ApiConstants.rideStart,
        data: {'ride_id': rideId},
      );
      
      developer.log('✅ START RIDE - Course démarrée', name: 'RideDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'RideDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'RideDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'RideDataSource');
        }
      }
      
      return RideModel.fromJson(response.data['ride']);
    } catch (e, stackTrace) {
      developer.log('❌ START RIDE - Erreur', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<RideModel> completeRide(int rideId) async {
    developer.log('🏁 COMPLETE RIDE - Fin de course', name: 'RideDataSource');
    developer.log('🆔 Ride ID: $rideId', name: 'RideDataSource');
    developer.log('🌐 URL: ${ApiConstants.rideComplete}', name: 'RideDataSource');
    
    try {
      final response = await apiClient.post(
        ApiConstants.rideComplete,
        data: {'ride_id': rideId},
      );
      
      developer.log('✅ COMPLETE RIDE - Course terminée', name: 'RideDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'RideDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'RideDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'RideDataSource');
        }
      }
      
      return RideModel.fromJson(response.data['ride']);
    } catch (e, stackTrace) {
      developer.log('❌ COMPLETE RIDE - Erreur', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<RideModel> getRideDetails(int rideId) async {
    developer.log('📋 GET RIDE DETAILS - Détails de course', name: 'RideDataSource');
    developer.log('🆔 Ride ID: $rideId', name: 'RideDataSource');
    
    try {
      final response = await apiClient.get('/ride/$rideId');
      
      developer.log('✅ GET RIDE DETAILS - Détails récupérés', name: 'RideDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'RideDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'RideDataSource');
      
      return RideModel.fromJson(response.data['ride']);
    } catch (e, stackTrace) {
      developer.log('❌ GET RIDE DETAILS - Erreur', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<RideModel>> getRideHistory() async {
    developer.log('📜 GET RIDE HISTORY - Historique des courses', name: 'RideDataSource');
    
    try {
      final response = await apiClient.get('/ride/history');
      
      developer.log('✅ GET RIDE HISTORY - Historique récupéré', name: 'RideDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'RideDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'RideDataSource');
      
      final rides = (response.data['rides'] as List)
          .map((ride) => RideModel.fromJson(ride))
          .toList();
      
      developer.log('📊 Nombre de courses: ${rides.length}', name: 'RideDataSource');
      
      return rides;
    } catch (e, stackTrace) {
      developer.log('❌ GET RIDE HISTORY - Erreur', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
