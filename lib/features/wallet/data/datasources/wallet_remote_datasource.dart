import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';

class WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSource(this._apiClient);

  /// Récupérer le portefeuille d'un utilisateur (passager)
  Future<WalletModel> getWallet(String userId, {bool isChauffeur = false}) async {
    try {
      developer.log('💰 Récupération du portefeuille pour user $userId...', name: 'WalletDataSource');
      
      final endpoint = isChauffeur 
          ? ApiConstants.chauffeurWalletShow 
          : ApiConstants.passagerWalletShow;
      
      final response = await _apiClient.post(
        endpoint,
        data: {'iduser': userId},
      );
      
      developer.log('✅ Portefeuille récupéré', name: 'WalletDataSource');
      developer.log('📦 Response: ${response.data}', name: 'WalletDataSource');
      
      // Backend returns raw wallet object, not wrapped in status/data
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic>) {
        return WalletModel.fromJson(responseData);
      } else {
        throw Exception('Format de réponse invalide');
      }
    } catch (e) {
      developer.log('❌ Erreur récupération portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }

  /// Recharger le portefeuille
  Future<WalletModel> rechargeWallet(String userId, int montant, {bool isChauffeur = false}) async {
    try {
      developer.log('💰 Recharge de $montant pour user $userId...', name: 'WalletDataSource');
      
      final endpoint = isChauffeur 
          ? ApiConstants.chauffeurWalletRecharge 
          : ApiConstants.passagerWalletRecharge;
      
      final response = await _apiClient.post(
        endpoint,
        data: {
          'iduser': userId,
          'montant': montant,
        },
      );
      
      developer.log('✅ Portefeuille rechargé', name: 'WalletDataSource');
      developer.log('📦 Response: ${response.data}', name: 'WalletDataSource');
      
      // Backend returns raw wallet object, not wrapped in status/data
      final responseData = response.data;
      
      if (responseData is Map<String, dynamic>) {
        return WalletModel.fromJson(responseData);
      } else {
        throw Exception('Format de réponse invalide');
      }
    } catch (e) {
      developer.log('❌ Erreur recharge portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }

  /// Récupérer l'historique du portefeuille
  Future<List<Map<String, dynamic>>> getWalletHistory(String userId) async {
    try {
      developer.log('📜 Récupération historique portefeuille pour user $userId...', name: 'WalletDataSource');
      
      final response = await _apiClient.get(
        ApiConstants.passagerWalletHistorique,
        queryParameters: {'iduser': userId},
      );
      
      developer.log('✅ Historique récupéré', name: 'WalletDataSource');
      
      final responseData = response.data;
      
      if (responseData is List) {
        return List<Map<String, dynamic>>.from(responseData);
      } else if (responseData is Map<String, dynamic> && responseData['data'] is List) {
        return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        return [];
      }
    } catch (e) {
      developer.log('❌ Erreur récupération historique: $e', name: 'WalletDataSource');
      rethrow;
    }
  }
}
