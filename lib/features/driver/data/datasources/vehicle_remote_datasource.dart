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
      
      final response = await _apiClient.get('${ApiConstants.chauffeurVehicules}/$chauffeurId/vehicules');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List<dynamic> vehiculesJson = responseData['data'] as List<dynamic>;
        final vehicules = vehiculesJson
            .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        developer.log('✅ ${vehicules.length} véhicules récupérés', name: 'VehicleDataSource');
        return vehicules;
      } else {
        return [];
      }
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
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Véhicule récupéré', name: 'VehicleDataSource');
        return VehicleModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Véhicule non trouvé');
      }
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
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Véhicule créé', name: 'VehicleDataSource');
        return VehicleModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception(responseData['message'] ?? 'Erreur lors de la création');
      }
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
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Véhicule mis à jour', name: 'VehicleDataSource');
        return VehicleModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception(responseData['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      developer.log('❌ Erreur mise à jour véhicule: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }

  /// Supprimer un véhicule
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      developer.log('🚗 Suppression du véhicule $vehicleId...', name: 'VehicleDataSource');
      
      final response = await _apiClient.delete('${ApiConstants.vehicules}/$vehicleId');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        developer.log('✅ Véhicule supprimé', name: 'VehicleDataSource');
      } else {
        throw Exception(responseData['message'] ?? 'Erreur lors de la suppression');
      }
    } catch (e) {
      developer.log('❌ Erreur suppression véhicule: $e', name: 'VehicleDataSource');
      rethrow;
    }
  }
}
