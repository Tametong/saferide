import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/vehicle_model.dart';
import '../../domain/entities/vehicle.dart';

class VehicleRemoteDataSource {
  final ApiClient _apiClient = ApiClient();

  VehicleRemoteDataSource();

  /// Récupérer tous les véhicules d'un chauffeur
  Future<List<Vehicle>> getVehiclesByChauffeur(String chauffeurId) async {
    try {
      developer.log('🚗 Récupération des véhicules du chauffeur $chauffeurId...', name: 'VehicleDataSource');
      
      final response = await _apiClient.get('${ApiConstants.vehicules}/chauffeur/$chauffeurId');
      
      // Backend peut retourner différents formats
      List<dynamic> vehiculesJson = [];
      
      if (response.data is List) {
        // Format: [vehicule1, vehicule2, ...]
        vehiculesJson = response.data as List<dynamic>;
      } else if (response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        
        if (data['data'] != null && data['data'] is List) {
          // Format: {data: [vehicule1, vehicule2, ...]}
          vehiculesJson = data['data'] as List<dynamic>;
        } else if (data['vehicule'] != null) {
          // Format: {message: "...", vehicule: {...}}
          vehiculesJson = [data['vehicule']];
        } else if (data.containsKey('id_vehicule')) {
          // Format: {id_vehicule: 1, marque: "...", ...}
          vehiculesJson = [data];
        }
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

  /// Ajouter un nouveau véhicule
  Future<Vehicle> addVehicle({
    required String idChauffeur,
    required String marque,
    required String modele,
    required String immatriculation,
    required int annee,
    required String couleur,
    required String typeVehicule,
  }) async {
    try {
      developer.log('🚗 Ajout d\'un nouveau véhicule...', name: 'VehicleDataSource');
      
      final response = await _apiClient.post(
        ApiConstants.vehicules,
        data: {
          'id_chauffeur': idChauffeur,
          'marque': marque,
          'modele': modele,
          'immatriculation': immatriculation,
          'annee': annee,
          'couleur': couleur,
          'type_vehicule': typeVehicule,
        },
      );
      
      // Backend may return vehicle directly or wrapped
      Map<String, dynamic> vehicleJson;
      if (response.data is Map) {
        if (response.data['data'] != null) {
          vehicleJson = response.data['data'] as Map<String, dynamic>;
        } else {
          vehicleJson = response.data as Map<String, dynamic>;
        }
      } else {
        throw Exception('Format de réponse invalide');
      }
      
      developer.log('✅ Véhicule ajouté', name: 'VehicleDataSource');
      return VehicleModel.fromJson(vehicleJson);
    } catch (e) {
      developer.log('❌ Erreur ajout véhicule: $e', name: 'VehicleDataSource');
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
