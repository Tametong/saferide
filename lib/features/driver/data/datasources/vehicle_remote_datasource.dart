import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/vehicle_model.dart';

class VehicleRemoteDataSource {
  final ApiClient _apiClient;

  VehicleRemoteDataSource(this._apiClient);

  /// Récupérer tous les véhicules d'un chauffeur
  Future<List<VehicleModel>> getDriverVehicles(String chauffeurId) async {
    try {
      developer.log('🚗 Récupération des véhicules du chauffeur $chauffeurId...', name: 'VehicleDataSource');
      
      final response = await _apiClient.get('${ApiConstants.vehicules}/chauffeur/$chauffeurId');
      
      developer.log('📦 Response: ${response.data}', name: 'VehicleDataSource');
      
      // Backend may return raw array or wrapped in message/vehicule
      final responseData = response.data;
      List<dynamic> vehiculesJson;
      
      if (responseData is List) {
        vehiculesJson = responseData;
      } else if (responseData is Map<String, dynamic>) {
        if (responseData['vehicules'] != null) {
          vehiculesJson = responseData['vehicules'] as List<dynamic>;
        } else if (responseData['data'] != null) {
          vehiculesJson = responseData['data'] as List<dynamic>;
        } else {
          vehiculesJson = [];
        }
      } else {
        vehiculesJson = [];
      }
      
      final vehicules = vehiculesJson
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      developer.log('✅ ${vehicules.length} véhicules récupérés', name: 'VehicleDataSource');
      return vehicules;
    } catch (e) {
      developer.log('❌ Erreur récupération véhicules: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }

  /// Récupérer un véhicule spécifique
  Future<VehicleModel> getVehicle(String vehicleId) async {
    try {
      developer.log('🚗 Récupération du véhicule $vehicleId...', name: 'VehicleDataSource');
      
      final response = await _apiClient.get('${ApiConstants.vehicules}/$vehicleId');
      final responseData = response.data;
      
      // Handle both wrapped and unwrapped responses
      Map<String, dynamic> vehicleJson;
      if (responseData is Map<String, dynamic>) {
        if (responseData['vehicule'] != null) {
          vehicleJson = responseData['vehicule'] as Map<String, dynamic>;
        } else if (responseData['data'] != null) {
          vehicleJson = responseData['data'] as Map<String, dynamic>;
        } else {
          vehicleJson = responseData;
        }
      } else {
        throw Exception('Format de réponse invalide');
      }
      
      developer.log('✅ Véhicule récupéré', name: 'VehicleDataSource');
      return VehicleModel.fromJson(vehicleJson);
    } catch (e) {
      developer.log('❌ Erreur récupération véhicule: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }

  /// Créer un nouveau véhicule
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    try {
      developer.log('🚗 Création d\'un nouveau véhicule...', name: 'VehicleDataSource');
      
      final response = await _apiClient.post(
        ApiConstants.vehicules,
        data: vehicle.toJson(),
      );
      final responseData = response.data;
      
      developer.log('📦 Response: $responseData', name: 'VehicleDataSource');
      
      // Handle both wrapped and unwrapped responses
      Map<String, dynamic> vehicleJson;
      if (responseData is Map<String, dynamic>) {
        if (responseData['vehicule'] != null) {
          vehicleJson = responseData['vehicule'] as Map<String, dynamic>;
        } else if (responseData['data'] != null) {
          vehicleJson = responseData['data'] as Map<String, dynamic>;
        } else {
          vehicleJson = responseData;
        }
      } else {
        throw Exception('Format de réponse invalide');
      }
      
      developer.log('✅ Véhicule créé', name: 'VehicleDataSource');
      return VehicleModel.fromJson(vehicleJson);
    } catch (e) {
      developer.log('❌ Erreur création véhicule: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }

  /// Mettre à jour un véhicule
  Future<VehicleModel> updateVehicle(String vehicleId, VehicleModel vehicle) async {
    try {
      developer.log('🚗 Mise à jour du véhicule $vehicleId...', name: 'VehicleDataSource');
      
      final response = await _apiClient.put(
        '${ApiConstants.vehicules}/$vehicleId',
        data: vehicle.toJson(),
      );
      final responseData = response.data;
      
      developer.log('📦 Response: $responseData', name: 'VehicleDataSource');
      
      // Handle both wrapped and unwrapped responses
      Map<String, dynamic> vehicleJson;
      if (responseData is Map<String, dynamic>) {
        if (responseData['vehicule'] != null) {
          vehicleJson = responseData['vehicule'] as Map<String, dynamic>;
        } else if (responseData['data'] != null) {
          vehicleJson = responseData['data'] as Map<String, dynamic>;
        } else {
          vehicleJson = responseData;
        }
      } else {
        throw Exception('Format de réponse invalide');
      }
      
      developer.log('✅ Véhicule mis à jour', name: 'VehicleDataSource');
      return VehicleModel.fromJson(vehicleJson);
    } catch (e) {
      developer.log('❌ Erreur mise à jour véhicule: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }

  /// Supprimer un véhicule
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      developer.log('🚗 Suppression du véhicule $vehicleId...', name: 'VehicleDataSource');
      
      await _apiClient.delete('${ApiConstants.vehicules}/$vehicleId');
      
      developer.log('✅ Véhicule supprimé', name: 'VehicleDataSource');
    } catch (e) {
      developer.log('❌ Erreur suppression véhicule: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }
}
