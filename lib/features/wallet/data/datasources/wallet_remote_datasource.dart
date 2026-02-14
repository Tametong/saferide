import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';

class WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSource(this._apiClient);

  /// Récupérer le portefeuille d'un utilisateur
  Future<WalletModel> getWallet(String userId, {bool isChauffeur = false}) async {
    try {
      developer.log('💰 Récupération du portefeuille pour user $userId...', name: 'WalletDataSource');
      
      // Backend uses POST with iduser in body, not GET with ID in URL
      final endpoint = isChauffeur 
          ? '${ApiConstants.baseUrl}/chauffeur/wallet/show'
          : '${ApiConstants.baseUrl}/passager/wallet/show';
      
      final response = await _apiClient.post(
        endpoint,
        data: {'iduser': userId},
      );
      
      final responseData = response.data;
      
      // Backend peut retourner directement l'objet ou avec wrapper
      Map<String, dynamic> walletJson;
      
      if (responseData is Map<String, dynamic>) {
        // Vérifier d'abord le format direct (le plus courant)
        if (responseData.containsKey('id_portefeuille') || responseData.containsKey('user_id')) {
          // Format direct: {id_portefeuille: 2, user_id: 5, ...}
          walletJson = responseData;
        } else if (responseData.containsKey('status') && responseData['data'] != null) {
          // Format: {status: "success", data: {...}}
          walletJson = responseData['data'] as Map<String, dynamic>;
        } else {
          developer.log('⚠️ Format de réponse inattendu: $responseData', name: 'WalletDataSource');
          throw Exception('Format de réponse invalide');
        }
      } else {
        throw Exception('Format de réponse invalide');
      }
      
      developer.log('✅ Portefeuille récupéré', name: 'WalletDataSource');
      return WalletModel.fromJson(walletJson);
    } catch (e) {
      developer.log('❌ Erreur récupération portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }

  /// Créditer le portefeuille (recharge)
  Future<WalletModel> rechargeWallet(String userId, int montant, {bool isChauffeur = false}) async {
    try {
      developer.log('💰 Recharge de $montant points pour user $userId...', name: 'WalletDataSource');
      
      final endpoint = isChauffeur 
          ? '${ApiConstants.baseUrl}/chauffeur/wallet/recharge'
          : '${ApiConstants.baseUrl}/passager/wallet/recharge';
      
      final response = await _apiClient.post(
        endpoint,
        data: {
          'iduser': userId,
          'montant': montant,
        },
      );
      
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Portefeuille rechargé', name: 'WalletDataSource');
        return WalletModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception(responseData['message'] ?? 'Erreur lors de la recharge');
      }
    } catch (e) {
      developer.log('❌ Erreur recharge portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }
}
