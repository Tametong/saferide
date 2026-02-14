class Vehicle {
  final String? id;
  final String idChauffeur;
  final String marque;
  final String modele;
  final String immatriculation;
  final int annee;
  final String couleur;
  final String typeVehicule;

  Vehicle({
    this.id,
    required this.idChauffeur,
    required this.marque,
    required this.modele,
    required this.immatriculation,
    required this.annee,
    required this.couleur,
    required this.typeVehicule,
  });
}
