class Vehicle {
  final int? id;
  final int driverId;
  final String vehicleType; // 'sedan', 'suv', 'van', 'motorcycle'
  final String brand;
  final String model;
  final String color;
  final String licensePlate;
  final int year;
  final int seats;
  final bool isActive;

  Vehicle({
    this.id,
    required this.driverId,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.color,
    required this.licensePlate,
    required this.year,
    required this.seats,
    this.isActive = true,
  });
}
