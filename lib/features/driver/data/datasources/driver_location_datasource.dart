import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/driver_location_model.dart';
import 'dart:developer' as developer;

class DriverLocationDataSource {
  final ApiClient apiClient;
  Timer? _locationUpdateTimer;

  DriverLocationDataSource(this.apiClient);

  // Envoyer la position actuelle du conducteur
  Future<void> updateLocation(DriverLocationModel location) async {
    developer.log('📍 UPDATE DRIVER LOCATION - Mise à jour position conducteur', name: 'DriverLocationDataSource');
    developer.log('🆔 Driver ID: ${location.driverId}', name: 'DriverLocationDataSource');
    developer.log('📍 Position: (${location.latitude}, ${location.longitude})', name: 'DriverLocationDataSource');
    developer.log('🚗 Disponible: ${location.isAvailable}', name: 'DriverLocationDataSource');
    
    try {
      final response = await apiClient.post(
        '${ApiConstants.baseUrl}/driver/location',
        data: location.toJson(),
      );
      
      developer.log('✅ UPDATE DRIVER LOCATION - Position mise à jour', name: 'DriverLocationDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'DriverLocationDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'DriverLocationDataSource');
        }
      }
    } catch (e, stackTrace) {
      developer.log('❌ UPDATE DRIVER LOCATION - Erreur', name: 'DriverLocationDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Démarrer l'envoi automatique de la position (toutes les 10 secondes)
  void startLocationUpdates(
    Stream<DriverLocationModel> locationStream,
  ) {
    developer.log('▶️ START LOCATION UPDATES - Démarrage envoi position', name: 'DriverLocationDataSource');
    
    locationStream.listen(
      (location) {
        updateLocation(location);
      },
      onError: (error) {
        developer.log('❌ LOCATION STREAM - Erreur', name: 'DriverLocationDataSource', error: error);
      },
    );
  }

  // Arrêter l'envoi de la position
  void stopLocationUpdates() {
    developer.log('⏹️ STOP LOCATION UPDATES - Arrêt envoi position', name: 'DriverLocationDataSource');
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  // Récupérer les conducteurs disponibles près d'une position
  Future<List<DriverLocationModel>> getNearbyDrivers({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    developer.log('🔍 GET NEARBY DRIVERS - Recherche conducteurs proches', name: 'DriverLocationDataSource');
    developer.log('📍 Position: ($latitude, $longitude)', name: 'DriverLocationDataSource');
    developer.log('📏 Rayon: ${radiusKm}km', name: 'DriverLocationDataSource');
    
    try {
      final response = await apiClient.get(
        '${ApiConstants.baseUrl}/driver/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radius': radiusKm,
        },
      );

      developer.log('✅ GET NEARBY DRIVERS - Conducteurs trouvés', name: 'DriverLocationDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'DriverLocationDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'DriverLocationDataSource');

      final drivers = (response.data['drivers'] as List)
          .map((json) => DriverLocationModel.fromJson(json))
          .toList();
      
      developer.log('👥 Nombre de conducteurs: ${drivers.length}', name: 'DriverLocationDataSource');
      
      return drivers;
    } catch (e, stackTrace) {
      developer.log('❌ GET NEARBY DRIVERS - Erreur', name: 'DriverLocationDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Mettre à jour le statut de disponibilité
  Future<void> updateAvailability(int driverId, bool isAvailable) async {
    developer.log('🔄 UPDATE AVAILABILITY - Mise à jour disponibilité', name: 'DriverLocationDataSource');
    developer.log('🆔 Driver ID: $driverId', name: 'DriverLocationDataSource');
    developer.log('🚗 Disponible: $isAvailable', name: 'DriverLocationDataSource');
    
    try {
      final response = await apiClient.post(
        '${ApiConstants.baseUrl}/driver/availability',
        data: {
          'driver_id': driverId,
          'is_available': isAvailable,
        },
      );
      
      developer.log('✅ UPDATE AVAILABILITY - Disponibilité mise à jour', name: 'DriverLocationDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'DriverLocationDataSource');
      
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'DriverLocationDataSource');
        }
      }
    } catch (e, stackTrace) {
      developer.log('❌ UPDATE AVAILABILITY - Erreur', name: 'DriverLocationDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
