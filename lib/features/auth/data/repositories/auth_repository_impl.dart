import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<User> verifyOtp(String otpId, String otpCode) {
    return remoteDataSource.verifyOtp(otpId, otpCode);
  }

  @override
  Future<User> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String telephone,
    required String role,
    String? licenseNumber,
    String? idPhotoPath,
  }) {
    return remoteDataSource.register(
      nom: nom,
      prenom: prenom,
      email: email,
      password: password,
      telephone: telephone,
      role: role,
      licenseNumber: licenseNumber,
      idPhotoPath: idPhotoPath,
    );
  }

  @override
  Future<User> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}
