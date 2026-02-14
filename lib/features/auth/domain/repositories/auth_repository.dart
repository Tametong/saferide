import '../entities/user.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<User> verifyOtp(String otpId, String otpCode);
  Future<User> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String telephone,
    required String role,
    String? licenseNumber,
    String? idPhotoPath,
  });
  Future<User> getProfile();
  Future<void> logout();
}
