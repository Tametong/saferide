class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Auth
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String verifyOtp = '$baseUrl/verifyOtp';
  static const String profile = '$baseUrl/profile';

  // Chauffeur (Driver)
  static const String listeChauffeurs = '$baseUrl/passager/liste-chauffeurs';
  static const String chauffeurProfile = '$baseUrl/chauffeur/profile';
  static const String chauffeurLocation = '$baseUrl/chauffeur/location';
  
  // Véhicules
  static const String vehicules = '$baseUrl/chauffeur/vehicules';
  
  // Portefeuille (Wallet) - Passager
  static const String passagerWalletShow = '$baseUrl/passager/wallet/show';
  static const String passagerWalletRecharge = '$baseUrl/passager/wallet/recharge';
  static const String passagerWalletHistorique = '$baseUrl/passager/wallet/historique';
  
  // Portefeuille (Wallet) - Chauffeur
  static const String chauffeurWalletShow = '$baseUrl/chauffeur/wallet/show';
  static const String chauffeurWalletRecharge = '$baseUrl/chauffeur/wallet/recharge';
  
  // Course (Ride)
  static const String coursePay = '$baseUrl/passager/coursepay';
  static const String cancelCourse = '$baseUrl/passager/cancelcourse';
  
  // Admin
  static const String adminChauffeurs = '$baseUrl/admin/chauffeurs';
  static const String adminValidateChauffeur = '$baseUrl/admin/chauffeurs';
  static const String adminUpdateStatus = '$baseUrl/admin/chauffeurs';

  // Safety
  static const String sos = '$baseUrl/sos';
  static const String share = '$baseUrl/share';
}
