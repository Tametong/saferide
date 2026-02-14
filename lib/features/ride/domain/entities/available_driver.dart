import 'package:google_maps_flutter/google_maps_flutter.dart';

class AvailableDriver {
  final String id;
  final String name;
  final LatLng position;
  final String vehicleType;
  final double rating;
  final String vehicleIcon;
  final String numeroPermis;
  final String? photoPieceIdentite;
  final String statutValidation;
  final bool estEnLigne;

  AvailableDriver({
    required this.id,
    required this.name,
    required this.position,
    required this.vehicleType,
    required this.rating,
    required this.vehicleIcon,
    required this.numeroPermis,
    this.photoPieceIdentite,
    required this.statutValidation,
    required this.estEnLigne,
  });
}
