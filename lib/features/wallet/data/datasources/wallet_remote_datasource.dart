import 'dart:developer' as developer;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/wallet_model.dart';

class WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSource(this._apiClient);

  /// Récupérer le portefeuille d'un utilisateur
  Future<WalletModel> getWallet(String userId) async {
    try {
      developer.log('💰 Récupération du portefeuille pour user $userId...', name: 'WalletDataSource');
      
      final response = await _apiClient.get('${ApiConstants.portefeuille}/$userId');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Portefeuille récupéré', name: 'WalletDataSource');
        return WalletModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Portefeuille non trouvé');
      }
    } catch (e) {
      developer.log('❌ Erreur récupération portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }

  /// Créditer le portefeuille
  Future<WalletModel> crediterWallet(String userId, int points) async {
    try {
      developer.log('💰 Crédit de $points points pour user $userId...', name: 'WalletDataSource');
      
      final response = await _apiClient.post(
        '${ApiConstants.portefeuille}/$userId/crediter',
        data: {'points': points},
      );
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Portefeuille crédité', name: 'WalletDataSource');
        return WalletModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception(responseData['message'] ?? 'Erreur lors du crédit');
      }
    } catch (e) {
      developer.log('❌ Erreur crédit portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }

  /// Débiter le portefeuille
  Future<WalletModel> debiterWallet(String userId, int points) async {
    try {
      developer.log('💰 Débit de $points points pour user $userId...', name: 'WalletDataSource');
      
      final response = await _apiClient.post(
        '${ApiConstants.portefeuille}/$userId/debiter',
        data: {'points': points},
      );
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        developer.log('✅ Portefeuille débité', name: 'WalletDataSource');
        return WalletModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception(responseData['message'] ?? 'Erreur lors du débit');
      }
    } catch (e) {
      developer.log('❌ Erreur débit portefeuille: $e', name: 'WalletDataSource');
      rethrow;
    }
  }
}
