import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/sos_event_model.dart';
import 'dart:developer' as developer;

class SafetyRemoteDataSource {
  final ApiClient apiClient;

  SafetyRemoteDataSource(this.apiClient);

  Future<SosEventModel> triggerSos({
    required double latitude,
    required double longitude,
    int? rideId,
    String? description,
  }) async {
    developer.log('🆘 TRIGGER SOS - Déclenchement SOS', name: 'SafetyDataSource');
    developer.log('📍 Position: ($latitude, $longitude)', name: 'SafetyDataSource');
    developer.log('🆔 Ride ID: $rideId', name: 'SafetyDataSource');
    developer.log('📝 Description: $description', name: 'SafetyDataSource');
    developer.log('🌐 URL: ${ApiConstants.sos}', name: 'SafetyDataSource');
    
    try {
      final requestData = {
        'latitude': latitude,
        'longitude': longitude,
        'ride_id': rideId,
        'description': description,
      };
      
      developer.log('📤 Request data: $requestData', name: 'SafetyDataSource');
      
      final response = await apiClient.post(
        ApiConstants.sos,
        data: requestData,
      );
      
      developer.log('✅ TRIGGER SOS - SOS déclenché', name: 'SafetyDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'SafetyDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'SafetyDataSource');
      
      // Afficher le message du backend s'il existe
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'SafetyDataSource');
        }
      }
      
      return SosEventModel.fromJson(response.data['sos_event']);
    } catch (e, stackTrace) {
      developer.log('❌ TRIGGER SOS - Erreur', name: 'SafetyDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> shareTripLocation({
    required int rideId,
    required String contactPhone,
  }) async {
    developer.log('📤 SHARE TRIP - Partage de localisation', name: 'SafetyDataSource');
    developer.log('🆔 Ride ID: $rideId', name: 'SafetyDataSource');
    developer.log('📱 Contact: $contactPhone', name: 'SafetyDataSource');
    developer.log('🌐 URL: ${ApiConstants.share}', name: 'SafetyDataSource');
    
    try {
      final requestData = {
        'ride_id': rideId,
        'contact_phone': contactPhone,
      };
      
      developer.log('📤 Request data: $requestData', name: 'SafetyDataSource');
      
      final response = await apiClient.post(
        ApiConstants.share,
        data: requestData,
      );
      
      developer.log('✅ SHARE TRIP - Localisation partagée', name: 'SafetyDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'SafetyDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'SafetyDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'SafetyDataSource');
        }
      }
    } catch (e, stackTrace) {
      developer.log('❌ SHARE TRIP - Erreur', name: 'SafetyDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    developer.log('📍 UPDATE LOCATION - Mise à jour position', name: 'SafetyDataSource');
    developer.log('📍 Position: ($latitude, $longitude)', name: 'SafetyDataSource');
    developer.log('🌐 URL: ${ApiConstants.locationUpdate}', name: 'SafetyDataSource');
    
    try {
      final requestData = {
        'latitude': latitude,
        'longitude': longitude,
      };
      
      final response = await apiClient.post(
        ApiConstants.locationUpdate,
        data: requestData,
      );
      
      developer.log('✅ UPDATE LOCATION - Position mise à jour', name: 'SafetyDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'SafetyDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'SafetyDataSource');
        }
      }
    } catch (e, stackTrace) {
      developer.log('❌ UPDATE LOCATION - Erreur', name: 'SafetyDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
