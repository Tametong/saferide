class VehicleType {
  final String id;
  final String name;
  final String description;
  final double pricePerKm;
  final int capacity;
  final String icon;
  final double basePrice;

  VehicleType({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerKm,
    required this.capacity,
    required this.icon,
    required this.basePrice,
  });

  double calculatePrice(double distanceKm) {
    return basePrice + (pricePerKm * distanceKm);
  }
}
