class ApiConstants {
  //static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String baseUrl = 'https://appride-main-jmpd3p.laravel.cloud/api';

  // Auth
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String verifyOtp = '$baseUrl/verifyOtp';
  static const String resendOtp = '$baseUrl/resend-otp';
  static const String profile = '$baseUrl/profile';

  // Ride
  static const String rideRequest = '$baseUrl/ride/request';
  static const String rideAccept = '$baseUrl/ride/accept';
  static const String rideStart = '$baseUrl/ride/start';
  static const String rideComplete = '$baseUrl/ride/complete';

  // Location
  static const String locationUpdate = '$baseUrl/location/update';
  
  // Chauffeur (Driver)
  static const String listeChauffeurs = '$baseUrl/passager/liste-chauffeurs';
  static const String chauffeurProfile = '$baseUrl/chauffeur/profile';
  static const String chauffeurLocation = '$baseUrl/chauffeur/location';
  static const String passagerLocation = '$baseUrl/passager/location';
  
  // Véhicules
  static const String chauffeurVehicules = '$baseUrl/chauffeur'; // /{id}/vehicules
  static const String vehicules = '$baseUrl/chauffeur/vehicules';
  
  // Portefeuille (Wallet)
  static const String portefeuille = '$baseUrl/portefeuille';
  
  // Admin
  static const String adminChauffeurs = '$baseUrl/admin/chauffeurs';
  static const String adminValidateChauffeur = '$baseUrl/admin/chauffeurs';
  static const String adminUpdateStatus = '$baseUrl/admin/chauffeurs';

  // Safety
  static const String sos = '$baseUrl/sos';
  static const String share = '$baseUrl/share';
}
