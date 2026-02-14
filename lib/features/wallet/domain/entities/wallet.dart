class Wallet {
  final String id;
  final String userId;
  final int soldePoints;
  final DateTime? dateDerniereMaj;

  Wallet({
    required this.id,
    required this.userId,
    required this.soldePoints,
    this.dateDerniereMaj,
  });
}
