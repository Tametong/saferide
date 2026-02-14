import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  WalletModel({
    required super.id,
    required super.userId,
    required super.soldePoints,
    super.dateDerniereMaj,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id_portefeuille']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      soldePoints: json['solde_points'] is int 
          ? json['solde_points'] 
          : int.tryParse(json['solde_points']?.toString() ?? '0') ?? 0,
      dateDerniereMaj: json['date_derniere_maj'] != null
          ? DateTime.tryParse(json['date_derniere_maj'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_portefeuille': id,
      'user_id': userId,
      'solde_points': soldePoints,
      'date_derniere_maj': dateDerniereMaj?.toIso8601String(),
    };
  }
}
