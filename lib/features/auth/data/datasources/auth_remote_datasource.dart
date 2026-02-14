import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import 'dart:developer' as developer;

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<String> login(String email, String password) async {
    developer.log('🔐 LOGIN - Tentative de connexion', name: 'AuthDataSource');
    developer.log('📧 Email: $email', name: 'AuthDataSource');
    developer.log('🌐 URL: ${ApiConstants.login}', name: 'AuthDataSource');
    
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      
      developer.log('✅ LOGIN - Réponse reçue', name: 'AuthDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'AuthDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'AuthDataSource');
      
      // Afficher le message du backend s'il existe
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'AuthDataSource');
        }
      }
      
      // Retourner l'otp_id pour la vérification (convertir en String)
      final otpId = response.data['otp_id'];
      return otpId.toString();
    } catch (e) {
      developer.log('❌ LOGIN - Erreur: $e', name: 'AuthDataSource');
      rethrow;
    }
  }

  Future<UserModel> verifyOtp(String otpId, String otpCode) async {
    developer.log('🔢 VERIFY OTP - Début', name: 'AuthDataSource');
    developer.log('🆔 OTP ID: $otpId', name: 'AuthDataSource');
    developer.log('🔑 OTP Code: $otpCode', name: 'AuthDataSource');
    developer.log('🌐 URL: ${ApiConstants.verifyOtp}', name: 'AuthDataSource');
    
    try {
      final requestData = {'otp_id': otpId, 'code': otpCode};
      developer.log('📤 Request data: $requestData', name: 'AuthDataSource');
      
      final response = await apiClient.post(
        ApiConstants.verifyOtp,
        data: requestData,
      );
      
      developer.log('✅ VERIFY OTP - Réponse reçue', name: 'AuthDataSource');
      developer.log('📦 Response status: ${response.statusCode}', name: 'AuthDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'AuthDataSource');
      
      // Afficher le message du backend s'il existe
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'AuthDataSource');
        }
      }
      
      // Gérer le token (peut être null)
      final token = response.data['token'];
      if (token != null) {
        developer.log('🎫 Token reçu: ${token.substring(0, 20)}...', name: 'AuthDataSource');
        apiClient.setAuthToken(token);
      } else {
        developer.log('⚠️ Aucun token reçu', name: 'AuthDataSource');
      }
      
      // Le user peut être un tableau ou un objet
      dynamic userData = response.data['user'];
      if (userData is List && userData.isNotEmpty) {
        userData = userData[0]; // Prendre le premier élément si c'est un tableau
      }
      
      final user = UserModel.fromJson(userData);
      developer.log('👤 User créé: ${user.email}', name: 'AuthDataSource');
      
      return user;
    } catch (e, stackTrace) {
      developer.log('❌ VERIFY OTP - Erreur', name: 'AuthDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> resendOtp(String email) async {
    developer.log('🔄 RESEND OTP - Début', name: 'AuthDataSource');
    developer.log('📧 Email: $email', name: 'AuthDataSource');
    developer.log('🌐 URL: ${ApiConstants.resendOtp}', name: 'AuthDataSource');
    
    try {
      final response = await apiClient.post(
        ApiConstants.resendOtp,
        data: {'email': email},
      );
      
      developer.log('✅ RESEND OTP - Succès', name: 'AuthDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'AuthDataSource');
      developer.log('📦 Response: ${response.data}', name: 'AuthDataSource');
      
      // Afficher le message du backend s'il existe
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'AuthDataSource');
        }
      }
    } catch (e, stackTrace) {
      developer.log('❌ RESEND OTP - Erreur', name: 'AuthDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<UserModel> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String telephone,
    required String role,
    String? licenseNumber,
    String? idPhotoPath,
  }) async {
    developer.log('📝 REGISTER - Début inscription', name: 'AuthDataSource');
    developer.log('👤 Nom: $nom', name: 'AuthDataSource');
    developer.log('👤 Prénom: $prenom', name: 'AuthDataSource');
    developer.log('📧 Email: $email', name: 'AuthDataSource');
    developer.log('📱 Phone: $telephone', name: 'AuthDataSource');
    developer.log('🎭 Role: $role', name: 'AuthDataSource');
    developer.log('🌐 URL: ${ApiConstants.register}', name: 'AuthDataSource');
    
    final Map<String, dynamic> data = {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'telephone': telephone,
      'role': role,
    };

    // Ajouter les informations du conducteur si présentes
    if (role == 'chauffeur') {
      if (licenseNumber != null) {
        data['numero_permis'] = licenseNumber;
        developer.log('🪪 Numéro permis: $licenseNumber', name: 'AuthDataSource');
      }
      if (idPhotoPath != null) {
        data['photo_piece_identite'] = idPhotoPath;
        developer.log('📸 Photo pièce identité: ${idPhotoPath.substring(0, 50)}...', name: 'AuthDataSource');
      }
    }

    try {
      developer.log('📤 Request data: $data', name: 'AuthDataSource');
      
      final response = await apiClient.post(
        ApiConstants.register,
        data: data,
      );
      
      developer.log('✅ REGISTER - Inscription réussie', name: 'AuthDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'AuthDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'AuthDataSource');
      
      // Afficher le message du backend s'il existe
      if (response.data is Map<String, dynamic>) {
        final message = response.data['message'] ?? response.data['msg'];
        if (message != null) {
          developer.log('💬 Message backend: $message', name: 'AuthDataSource');
        }
      }
      
      final token = response.data['token'];
      developer.log('🎫 Token reçu: ${token?.substring(0, 20)}...', name: 'AuthDataSource');
      
      apiClient.setAuthToken(token);
      
      final user = UserModel.fromJson(response.data['user']);
      developer.log('👤 User créé: ${user.email} (${user.role})', name: 'AuthDataSource');
      
      return user;
    } catch (e, stackTrace) {
      developer.log('❌ REGISTER - Erreur', name: 'AuthDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<UserModel> getProfile() async {
    developer.log('👤 GET PROFILE - Récupération du profil', name: 'AuthDataSource');
    developer.log('🌐 URL: ${ApiConstants.profile}', name: 'AuthDataSource');
    
    try {
      final response = await apiClient.get(ApiConstants.profile);
      
      developer.log('✅ GET PROFILE - Profil récupéré', name: 'AuthDataSource');
      developer.log('📦 Status: ${response.statusCode}', name: 'AuthDataSource');
      developer.log('📦 Response data: ${response.data}', name: 'AuthDataSource');
      
      return UserModel.fromJson(response.data);
    } catch (e, stackTrace) {
      developer.log('❌ GET PROFILE - Erreur', name: 'AuthDataSource', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    developer.log('🚪 LOGOUT - Déconnexion', name: 'AuthDataSource');
    apiClient.clearAuthToken();
    developer.log('✅ LOGOUT - Token supprimé', name: 'AuthDataSource');
  }
}
