import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/chauffeur_model.dart';

class ChauffeurRemoteDataSource {
  final ApiClient _apiClient;

  ChauffeurRemoteDataSource(this._apiClient);

  /// Récupérer la liste des chauffeurs disponibles
  /// Filtre automatiquement pour ne retourner que les chauffeurs:
  /// - En ligne (est_en_ligne = true)
  /// - Validés (statut_validation = 'Valide')
  Future<List<ChauffeurModel>> getAvailableDrivers() async {
    try {
      developer.log('🚗 Récupération des chauffeurs disponibles...', name: 'ChauffeurDataSource');
      
      final response = await _apiClient.get(ApiConstants.listeChauffeurs);
      final responseData = response.data as Map<String, dynamic>;
      
      developer.log('📥 Réponse reçue: $responseData', name: 'ChauffeurDataSource');
      
      // Le backend retourne: { "status": "success", "data": [...] }
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List<dynamic> chauffeursJson = responseData['data'] as List<dynamic>;
        
        developer.log('📊 Nombre total de chauffeurs: ${chauffeursJson.length}', name: 'ChauffeurDataSource');
        
        // Convertir en modèles et filtrer
        final chauffeurs = chauffeursJson
            .map((json) => ChauffeurModel.fromJson(json as Map<String, dynamic>))
            .where((chauffeur) {
              // Filtrer: seulement les chauffeurs en ligne ET validés
              final isAvailable = chauffeur.estEnLigne && 
                                 chauffeur.statutValidation == 'Valide';
              
              if (!isAvailable) {
                developer.log(
                  '⏭️ Chauffeur ${chauffeur.name} ignoré - En ligne: ${chauffeur.estEnLigne}, Statut: ${chauffeur.statutValidation}',
                  name: 'ChauffeurDataSource'
                );
              }
              
              return isAvailable;
            })
            .toList();
        
        developer.log('✅ Chauffeurs disponibles: ${chauffeurs.length}', name: 'ChauffeurDataSource');
        
        return chauffeurs;
      } else {
        developer.log('⚠️ Format de réponse inattendu', name: 'ChauffeurDataSource');
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Erreur lors de la récupération des chauffeurs: $e',
        name: 'ChauffeurDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Récupérer le profil d'un chauffeur spécifique
  Future<ChauffeurModel> getChauffeurProfile(String id) async {
    try {
      developer.log('👤 Récupération du profil chauffeur $id...', name: 'ChauffeurDataSource');
      
      final response = await _apiClient.get('${ApiConstants.chauffeurProfile}/$id');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        return ChauffeurModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Profil chauffeur non trouvé');
      }
    } catch (e) {
      developer.log('❌ Erreur profil chauffeur: $e', name: 'ChauffeurDataSource');
      rethrow;
    }
  }

  /// Mettre à jour la position d'un chauffeur
  Future<void> updateChauffeurLocation(String id, double latitude, double longitude) async {
    try {
      developer.log('📍 Mise à jour position chauffeur $id...', name: 'ChauffeurDataSource');
      
      await _apiClient.patch(
        '${ApiConstants.chauffeurLocation}/$id',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      
      developer.log('✅ Position chauffeur mise à jour', name: 'ChauffeurDataSource');
    } catch (e) {
      developer.log('❌ Erreur mise à jour position: $e', name: 'ChauffeurDataSource');
      rethrow;
    }
  }

  /// Mettre à jour la position d'un passager
  Future<void> updatePassagerLocation(String id, double latitude, double longitude) async {
    try {
      developer.log('📍 Mise à jour position passager $id...', name: 'ChauffeurDataSource');
      
      await _apiClient.patch(
        '${ApiConstants.passagerLocation}/$id',
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      
      developer.log('✅ Position passager mise à jour', name: 'ChauffeurDataSource');
    } catch (e) {
      developer.log('❌ Erreur mise à jour position: $e', name: 'ChauffeurDataSource');
      rethrow;
    }
  }
}
