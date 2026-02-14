import 'dart:developer' as developer;
import '../../../../core/network/api_client.dart';
import '../../../wallet/data/datasources/wallet_remote_datasource.dart';

class PaymentService {
  final ApiClient apiClient;
  final WalletRemoteDataSource walletDataSource;

  PaymentService(this.apiClient, this.walletDataSource);

  /// Vérifier si le passager a suffisamment de points
  Future<bool> checkSufficientBalance(int userId, int requiredPoints) async {
    developer.log('💰 CHECK BALANCE - Vérification solde', name: 'PaymentService');
    developer.log('👤 User ID: $userId', name: 'PaymentService');
    developer.log('💵 Points requis: $requiredPoints', name: 'PaymentService');
    
    try {
      final wallet = await walletDataSource.getWallet(userId.toString());
      final hasSufficientBalance = wallet.soldePoints >= requiredPoints;
      
      developer.log(
        hasSufficientBalance 
          ? '✅ Solde suffisant: ${wallet.soldePoints} points' 
          : '❌ Solde insuffisant: ${wallet.soldePoints} points',
        name: 'PaymentService',
      );
      
      return hasSufficientBalance;
    } catch (e, stackTrace) {
      developer.log('❌ CHECK BALANCE - Erreur', name: 'PaymentService', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Calculer le prix en points basé sur la distance et le type de véhicule
  int calculatePrice(double distanceKm, String vehicleType) {
    developer.log('🧮 CALCULATE PRICE - Calcul du prix', name: 'PaymentService');
    developer.log('📏 Distance: ${distanceKm.toStringAsFixed(2)} km', name: 'PaymentService');
    developer.log('🚗 Type: $vehicleType', name: 'PaymentService');
    
    // Tarification: 1 point/km pour Standard, +1 pour chaque niveau supérieur
    int pointsPerKm;
    switch (vehicleType.toLowerCase()) {
      case 'standard':
        pointsPerKm = 1;
        break;
      case 'confort':
        pointsPerKm = 2;
        break;
      case 'premium':
        pointsPerKm = 3;
        break;
      default:
        pointsPerKm = 1;
    }
    
    final totalPoints = (distanceKm * pointsPerKm).ceil();
    
    developer.log('💰 Prix calculé: $totalPoints points ($pointsPerKm pts/km)', name: 'PaymentService');
    
    return totalPoints;
  }

  /// Convertir les points en FCFA (1 point = 250 FCFA)
  int convertPointsToFCFA(int points) {
    return points * 250;
  }

  /// Convertir les FCFA en points (250 FCFA = 1 point)
  int convertFCFAToPoints(int fcfa) {
    return (fcfa / 250).ceil();
  }

  /// Traiter le paiement d'une course
  /// Note: La distribution 60%/30%/10% doit être gérée par le backend
  /// Cette méthode vérifie juste le solde avant de créer la course
  Future<Map<String, dynamic>> processPayment({
    required int passengerId,
    required int driverId,
    required int totalPoints,
    required int courseId,
  }) async {
    developer.log('💳 PROCESS PAYMENT - Traitement paiement', name: 'PaymentService');
    developer.log('👤 Passager: $passengerId', name: 'PaymentService');
    developer.log('🚗 Chauffeur: $driverId', name: 'PaymentService');
    developer.log('💰 Total: $totalPoints points', name: 'PaymentService');
    
    try {
      // Vérifier le solde
      final hasSufficientBalance = await checkSufficientBalance(passengerId, totalPoints);
      
      if (!hasSufficientBalance) {
        throw Exception('Solde insuffisant');
      }
      
      // Calculer la distribution
      final driverShare = (totalPoints * 0.6).round(); // 60%
      final adminShare = (totalPoints * 0.3).round();  // 30%
      final platformShare = totalPoints - driverShare - adminShare; // 10%
      
      developer.log('📊 Distribution:', name: 'PaymentService');
      developer.log('  - Chauffeur (60%): $driverShare points', name: 'PaymentService');
      developer.log('  - Admin (30%): $adminShare points', name: 'PaymentService');
      developer.log('  - Plateforme (10%): $platformShare points', name: 'PaymentService');
      
      // Note: Le backend devrait gérer la distribution automatiquement
      // via l'endpoint /passager/coursepay
      // Pour l'instant, on retourne juste les informations
      
      return {
        'success': true,
        'totalPoints': totalPoints,
        'driverShare': driverShare,
        'adminShare': adminShare,
        'platformShare': platformShare,
        'totalFCFA': convertPointsToFCFA(totalPoints),
      };
    } catch (e, stackTrace) {
      developer.log('❌ PROCESS PAYMENT - Erreur', name: 'PaymentService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
