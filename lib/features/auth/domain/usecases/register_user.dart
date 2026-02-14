import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<User> call({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String telephone,
    required String role,
    String? licenseNumber,
    String? idPhotoPath,
  }) {
    return repository.register(
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
}
