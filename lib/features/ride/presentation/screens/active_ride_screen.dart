import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:developer' as developer;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/ride_request_model.dart';
import '../../domain/entities/ride_request.dart';

class ActiveRideScreen extends StatefulWidget {
  final RideRequestModel ride;
  final bool isDriver;

  const ActiveRideScreen({
    super.key,
    required this.ride,
    this.isDriver = false,
  });

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final LocationService _locationService = LocationService();
  StreamSubscription? _locationSubscription;
  LatLng? _currentPosition;
  
  late RideRequestModel _currentRide;

  @override
  void initState() {
    super.initState();
    _currentRide = widget.ride;
    _initializeMap();
    
    if (widget.isDriver) {
      _startLocationTracking();
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Obtenir la position actuelle
      final position = await _locationService.getCurrentLocation();
      
      if (!mounted) return;
      
      if (position != null) {
        _currentPosition = LatLng(position.latitude, position.longitude);
      }
      
      // Créer les marqueurs
      _createMarkers();
      
      // Tracer la route
      _drawRoute();
      
      setState(() {});
    } catch (e) {
      developer.log('❌ Erreur initialisation carte: $e', name: 'ActiveRideScreen');
    }
  }

  void _createMarkers() {
    _markers.clear();
    
    // Marqueur de départ
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(_currentRide.departLat, _currentRide.departLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Point de départ'),
      ),
    );
    
    // Marqueur d'arrivée
    _markers.add(
      Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(_currentRide.arriveeLat, _currentRide.arriveeLng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    );
    
    // Marqueur de position actuelle
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.isDriver ? 'driver' : 'passenger'),
          position: _currentPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            widget.isDriver ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueBlue,
          ),
          infoWindow: InfoWindow(
            title: widget.isDriver ? 'Votre position' : 'Ma position',
          ),
        ),
      );
    }
  }

  void _drawRoute() {
    _polylines.clear();
    
    // Ligne simple entre départ et arrivée
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: AppColors.primary,
        points: [
          LatLng(_currentRide.departLat, _currentRide.departLng),
          LatLng(_currentRide.arriveeLat, _currentRide.arriveeLng),
        ],
        width: 4,
      ),
    );
  }

  void _startLocationTracking() {
    _locationSubscription = _locationService.getLocationStream().listen((position) {
      final newPosition = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _currentPosition = newPosition;
        _createMarkers();
      });
      
      // Centrer la caméra sur la nouvelle position
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
    // Ajuster la caméra pour voir tous les marqueurs
    if (_markers.isNotEmpty) {
      _fitBounds();
    }
  }

  void _fitBounds() {
    if (_markers.isEmpty) return;
    
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;
    
    for (var marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng) minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng) maxLng = marker.position.longitude;
    }
    
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      body: Stack(
        children: [
          // Carte
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentRide.departLat, _currentRide.departLng),
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isDriver ? 'Course en cours' : 'Votre course',
                            style: AppTextStyles.h2.copyWith(fontSize: 16),
                          ),
                          Text(
                            _getStatusText(),
                            style: AppTextStyles.caption.copyWith(
                              color: _getStatusColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge de statut
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentRide.statut.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Recenter button
          Positioned(
            right: 16,
            bottom: widget.isDriver ? 280 : 320,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _fitBounds,
              ),
            ),
          ),
          
          // Bottom card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: widget.isDriver ? _buildDriverBottomCard(user) : _buildPassengerBottomCard(user),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (_currentRide.statut) {
      case RideRequest.statusPending:
        return 'En attente d\'acceptation';
      case RideRequest.statusAccepted:
        return 'Chauffeur en route vers vous';
      case RideRequest.statusDriverEnRoute:
        return 'Chauffeur en route';
      case RideRequest.statusDriverArrived:
        return 'Chauffeur arrivé';
      case RideRequest.statusInProgress:
        return 'Course en cours';
      case RideRequest.statusCompleted:
        return 'Course terminée';
      case RideRequest.statusCancelled:
        return 'Course annulée';
      default:
        return _currentRide.statut;
    }
  }

  Color _getStatusColor() {
    switch (_currentRide.statut) {
      case RideRequest.statusPending:
        return AppColors.neutral;
      case RideRequest.statusAccepted:
      case RideRequest.statusDriverEnRoute:
        return Colors.orange;
      case RideRequest.statusDriverArrived:
        return AppColors.primary;
      case RideRequest.statusInProgress:
        return AppColors.success;
      case RideRequest.statusCompleted:
        return AppColors.success;
      case RideRequest.statusCancelled:
        return AppColors.error;
      default:
        return AppColors.neutral;
    }
  }

  Widget _buildPassengerBottomCard(user) {
    final priceFCFA = _currentRide.prixPoints * 250;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Info chauffeur
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chauffeur #${_currentRide.driverId}',
                      style: AppTextStyles.h2.copyWith(fontSize: 18),
                    ),
                    Text(
                      _currentRide.vehicleType,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Bouton appel
              Container(
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.phone, color: AppColors.success),
                  onPressed: () {
                    // TODO: Implémenter appel
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fonction d\'appel à implémenter')),
                    );
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Info course
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Distance',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${_currentRide.distanceKm.toStringAsFixed(2)} km',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prix',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$priceFCFA FCFA (${_currentRide.prixPoints} pts)',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bouton annuler (seulement si en attente ou acceptée)
          if (_currentRide.statut == RideRequest.statusPending ||
              _currentRide.statut == RideRequest.statusAccepted)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _cancelRide(user),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Annuler la course'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDriverBottomCard(user) {
    final driverShare = (_currentRide.prixPoints * 0.6).round();
    final driverShareFCFA = driverShare * 250;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.neutral.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Info passager
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passager #${_currentRide.passengerId}',
                      style: AppTextStyles.h2.copyWith(fontSize: 18),
                    ),
                    Text(
                      '${_currentRide.distanceKm.toStringAsFixed(2)} km',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Gains
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$driverShareFCFA FCFA',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 16,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    'Vos gains (60%)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Boutons d'action selon le statut
          if (_currentRide.statut == RideRequest.statusAccepted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startRide(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Démarrer la course'),
              ),
            )
          else if (_currentRide.statut == RideRequest.statusInProgress)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _completeRide(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Terminer la course'),
              ),
            ),
        ],
      ),
    );
  }

  void _cancelRide(user) async {
    // TODO: Implémenter annulation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la course'),
        content: const Text('Êtes-vous sûr de vouloir annuler cette course ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course annulée'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }

  void _startRide() {
    setState(() {
      _currentRide = _currentRide.copyWith(statut: RideRequest.statusInProgress);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Course démarrée'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _completeRide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminer la course'),
        content: const Text('Confirmez-vous que le passager est arrivé à destination ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course terminée ! Vos gains ont été crédités.'),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Oui, terminer'),
          ),
        ],
      ),
    );
  }
}
