import 'dart:developer' as developer;
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/ride_request_model.dart';

class RideRequestDataSource {
  final ApiClient apiClient;

  RideRequestDataSource(this.apiClient);

  /// Créer une nouvelle demande de course
  /// 
  /// Le backend attend:
  /// - id_passager (required)
  /// - id_chauffeur (required)
  /// - prix_en_points (required)
  /// - id_admin (required) - ID de l'admin (1 par défaut)
  /// - depart (optional) - Nom du lieu de départ
  /// - dest (optional) - Nom du lieu de destination
  Future<RideRequestModel> createRideRequest(
    RideRequestModel request, {
    String? departAddress,
    String? destAddress,
  }) async {
    developer.log('🚗 CREATE RIDE REQUEST - Création demande de course', name: 'RideRequestDataSource');
    developer.log('📍 Départ: (${request.departLat}, ${request.departLng})', name: 'RideRequestDataSource');
    developer.log('📍 Arrivée: (${request.arriveeLat}, ${request.arriveeLng})', name: 'RideRequestDataSource');
    developer.log('💰 Prix: ${request.prixPoints} points', name: 'RideRequestDataSource');
    
    try {
      // Préparer les données selon le format attendu par le backend
      final requestData = {
        'id_passager': request.passengerId,
        'id_chauffeur': request.driverId,
        'prix_en_points': request.prixPoints,
        'id_admin': 1, // ID de l'admin par défaut (à ajuster selon votre système)
        if (departAddress != null) 'depart': departAddress,
        if (destAddress != null) 'dest': destAddress,
      };
      
      developer.log('📤 Données envoyées: $requestData', name: 'RideRequestDataSource');
      
      final response = await apiClient.post(
        '${ApiConstants.baseUrl}/passager/coursepay',
        data: requestData,
      );
      
      developer.log('✅ CREATE RIDE REQUEST - Course créée', name: 'RideRequestDataSource');
      developer.log('📦 Response: ${response.data}', name: 'RideRequestDataSource');
      
      // Le backend peut retourner différents formats
      Map<String, dynamic> courseData;
      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('course')) {
          courseData = response.data['course'];
        } else if (response.data.containsKey('data')) {
          courseData = response.data['data'];
        } else {
          courseData = response.data;
        }
      } else {
        throw Exception('Format de réponse invalide');
      }
      
      // Enrichir les données de réponse avec les informations de la requête
      courseData['depart_lat'] = request.departLat;
      courseData['depart_lng'] = request.departLng;
      courseData['arrivee_lat'] = request.arriveeLat;
      courseData['arrivee_lng'] = request.arriveeLng;
      courseData['distance_km'] = request.distanceKm;
      courseData['vehicle_type'] = request.vehicleType;
      
      return RideRequestModel.fromJson(courseData);
    } catch (e, stackTrace) {
      developer.log('❌ CREATE RIDE REQUEST - Erreur', name: 'RideRequestDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Annuler une course
  /// 
  /// Le backend attend:
  /// - idcourse (required) - ID de la course à annuler
  Future<void> cancelRideRequest(int courseId) async {
    developer.log('❌ CANCEL RIDE REQUEST - Annulation course $courseId', name: 'RideRequestDataSource');
    
    try {
      final response = await apiClient.post(
        '${ApiConstants.baseUrl}/passager/cancelcourse',
        data: {
          'idcourse': courseId, // Backend expects 'idcourse' not 'id_course'
        },
      );
      
      developer.log('✅ CANCEL RIDE REQUEST - Course annulée', name: 'RideRequestDataSource');
      developer.log('📦 Response: ${response.data}', name: 'RideRequestDataSource');
    } catch (e, stackTrace) {
      developer.log('❌ CANCEL RIDE REQUEST - Erreur', name: 'RideRequestDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Récupérer la course active du passager
  Future<RideRequestModel?> getActiveRide(int passengerId) async {
    developer.log('🔍 GET ACTIVE RIDE - Recherche course active', name: 'RideRequestDataSource');
    
    try {
      // Note: Cet endpoint n'existe pas encore dans le backend
      // Pour l'instant, on retourne null
      developer.log('⚠️ GET ACTIVE RIDE - Endpoint non disponible', name: 'RideRequestDataSource');
      return null;
    } catch (e, stackTrace) {
      developer.log('❌ GET ACTIVE RIDE - Erreur', name: 'RideRequestDataSource', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Récupérer l'historique des courses
  Future<List<RideRequestModel>> getRideHistory(int userId) async {
    developer.log('📜 GET RIDE HISTORY - Récupération historique', name: 'RideRequestDataSource');
    
    try {
      // Note: Cet endpoint n'existe pas encore dans le backend
      // Pour l'instant, on retourne une liste vide
      developer.log('⚠️ GET RIDE HISTORY - Endpoint non disponible', name: 'RideRequestDataSource');
      return [];
    } catch (e, stackTrace) {
      developer.log('❌ GET RIDE HISTORY - Erreur', name: 'RideRequestDataSource', error: e, stackTrace: stackTrace);
      return [];
    }
  }
}
