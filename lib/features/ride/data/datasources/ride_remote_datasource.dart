import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

class RideRemoteDataSource {
  final ApiClient _apiClient;

  RideRemoteDataSource(this._apiClient);

  /// Créer et payer une course
  Future<Map<String, dynamic>> createAndPayRide({
    required String idPassager,
    required String idChauffeur,
    required int prixEnPoints,
    required String idAdmin,
    required Map<String, dynamic> depart,
    required Map<String, dynamic> dest,
  }) async {
    try {
      developer.log('🚗 Création et paiement de la course...', name: 'RideDataSource');
      developer.log('👤 Passager: $idPassager', name: 'RideDataSource');
      developer.log('🚕 Chauffeur: $idChauffeur', name: 'RideDataSource');
      developer.log('💰 Prix: $prixEnPoints points', name: 'RideDataSource');
      
      final response = await _apiClient.post(
        ApiConstants.coursePay,
        data: {
          'id_passager': idPassager,
          'id_chauffeur': idChauffeur,
          'prix_en_points': prixEnPoints,
          'id_admin': idAdmin,
          'depart': depart,
          'dest': dest,
        },
      );
      
      developer.log('✅ Course créée et payée', name: 'RideDataSource');
      developer.log('📦 Response: ${response.data}', name: 'RideDataSource');
      
      return response.data as Map<String, dynamic>;
    } catch (e, stackTrace) {
      developer.log('❌ Erreur création course: $e', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Annuler une course
  Future<void> cancelRide({
    required String courseId,
    String? reason,
  }) async {
    try {
      developer.log('❌ Annulation de la course $courseId...', name: 'RideDataSource');
      
      final data = <String, dynamic>{
        'id_course': courseId,
      };
      
      if (reason != null) {
        data['raison'] = reason;
      }
      
      final response = await _apiClient.post(
        ApiConstants.cancelCourse,
        data: data,
      );
      
      developer.log('✅ Course annulée', name: 'RideDataSource');
      developer.log('📦 Response: ${response.data}', name: 'RideDataSource');
    } catch (e, stackTrace) {
      developer.log('❌ Erreur annulation course: $e', name: 'RideDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
