import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../wallet/data/datasources/wallet_remote_datasource.dart';
import '../../../wallet/domain/entities/wallet.dart';
import '../../data/models/vehicle_type_model.dart';
import '../../domain/entities/available_driver.dart';
import '../../data/datasources/chauffeur_remote_datasource.dart';
import 'dart:developer' as developer;

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  double? _distanceKm;
  
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  late final ChauffeurRemoteDataSource _chauffeurDataSource;
  late final WalletRemoteDataSource _walletDataSource;
  
  List<VehicleTypeModel> _vehicleTypes = [];
  VehicleTypeModel? _selectedVehicleType;
  bool _showVehicleSelection = false;
  
  List<AvailableDriver> _availableDrivers = [];
  bool _isLoadingDrivers = false;
  
  Wallet? _userWallet;
  bool _isLoadingWallet = false;

  @override
  void initState() {
    super.initState();
    _chauffeurDataSource = ChauffeurRemoteDataSource(ApiClient());
    _walletDataSource = WalletRemoteDataSource(ApiClient());
    _getCurrentLocation();
    _vehicleTypes = VehicleTypeModel.getDefaultTypes();
    _loadAvailableDrivers();
    _loadUserWallet();
    
    // Écouter le focus pour faire monter le bottom sheet
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }
  
  void _loadAvailableDrivers() async {
    if (_isLoadingDrivers) return;
    
    setState(() {
      _isLoadingDrivers = true;
    });
    
    try {
      developer.log('🔄 Chargement des chauffeurs depuis l\'API...', name: 'RideBooking');
      
      final chauffeurs = await _chauffeurDataSource.getAvailableDrivers();
      
      if (!mounted) return;
      
      setState(() {
        _availableDrivers = chauffeurs;
        _isLoadingDrivers = false;
      });
      
      developer.log('✅ ${chauffeurs.length} chauffeurs chargés', name: 'RideBooking');
      
      // Ajouter les marqueurs après un court délai pour ne pas bloquer l'UI
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _addDriverMarkers();
      });
    } catch (e) {
      developer.log('❌ Erreur chargement chauffeurs: $e', name: 'RideBooking');
      
      if (!mounted) return;
      
      setState(() {
        _isLoadingDrivers = false;
      });
      
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des chauffeurs: $e'),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Réessayer',
            textColor: Colors.white,
            onPressed: _loadAvailableDrivers,
          ),
        ),
      );
    }
  }
  
  void _loadUserWallet() async {
    if (_isLoadingWallet) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user == null) {
      developer.log('⚠️ Utilisateur non connecté', name: 'RideBooking');
      return;
    }
    
    setState(() {
      _isLoadingWallet = true;
    });
    
    try {
      developer.log('💰 Chargement du portefeuille...', name: 'RideBooking');
      
      final wallet = await _walletDataSource.getWallet(user.id);
      
      if (!mounted) return;
      
      setState(() {
        _userWallet = wallet;
        _isLoadingWallet = false;
      });
      
      developer.log('✅ Portefeuille chargé: ${wallet.soldePoints} points', name: 'RideBooking');
    } catch (e) {
      developer.log('❌ Erreur chargement portefeuille: $e', name: 'RideBooking');
      
      if (!mounted) return;
      
      setState(() {
        _isLoadingWallet = false;
      });
    }
  }
  
  Future<void> _addDriverMarkers() async {
    // Utiliser des marqueurs simples au lieu d'icônes personnalisées
    for (var driver in _availableDrivers) {
      _markers.add(
        Marker(
          markerId: MarkerId('driver_${driver.id}'),
          position: driver.position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: InfoWindow(
            title: '${driver.vehicleIcon} ${driver.name}',
            snippet: '${driver.vehicleType} - ⭐ ${driver.rating}',
          ),
        ),
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    try {
      developer.log('🗺️ Demande de localisation...', name: 'RideBooking');
      final position = await _locationService.getCurrentLocation();
      
      if (!mounted) return;
      
      if (position == null) {
        developer.log('❌ Position null', name: 'RideBooking');
        throw Exception('Impossible d\'obtenir la position');
      }
      
      developer.log('✅ Position obtenue: ${position.latitude}, ${position.longitude}', name: 'RideBooking');
      
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Ma position'),
          ),
        );
      });
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    } catch (e) {
      developer.log('❌ Erreur localisation: $e', name: 'RideBooking');
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de localisation: $e'),
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'Réessayer',
            textColor: Colors.white,
            onPressed: _getCurrentLocation,
          ),
        ),
      );
      
      // Position par défaut (Douala, Cameroun)
      setState(() {
        _currentPosition = const LatLng(4.0511, 9.7679);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentPosition!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: 'Position par défaut'),
          ),
        );
      });
    }
  }

  void _onDestinationSelected(Prediction prediction) {
    final lat = double.tryParse(prediction.lat ?? '0') ?? 0;
    final lng = double.tryParse(prediction.lng ?? '0') ?? 0;
    
    _searchController.text = prediction.description ?? '';
    _searchFocusNode.unfocus();
    
    setState(() {
      _destinationPosition = LatLng(lat, lng);
      
      // Ajouter le marqueur de destination
      _markers.removeWhere((m) => m.markerId.value == 'destination');
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: prediction.description ?? ''),
        ),
      );
    });
    
    // Tracer la route
    _drawRoute();
    
    // Ajuster la caméra pour voir les deux points
    _fitBounds();
  }

  Future<void> _drawRoute() async {
    if (_currentPosition == null || _destinationPosition == null) return;
    
    try {
      developer.log('🗺️ Tracé de la route...', name: 'RideBooking');
      
      // Calculer d'abord la distance pour l'afficher rapidement
      double distance = await _locationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _destinationPosition!.latitude,
        _destinationPosition!.longitude,
      );
      
      setState(() {
        _distanceKm = distance / 1000;
        _showVehicleSelection = true;
        // Afficher une ligne droite temporaire
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: AppColors.primary,
            points: [_currentPosition!, _destinationPosition!],
            width: 4,
          ),
        );
      });
      
      developer.log('✅ Distance calculée: ${_distanceKm?.toStringAsFixed(2)} km', name: 'RideBooking');
      
      // Tracer la vraie route en arrière-plan
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyCrbY593deLu2Oic6xjs2BLN1UHmi2rBnQ",
        request: PolylineRequest(
          origin: PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          destination: PointLatLng(_destinationPosition!.latitude, _destinationPosition!.longitude),
          mode: TravelMode.driving,
        ),
      );
      
      if (result.points.isNotEmpty && mounted) {
        List<LatLng> polylineCoordinates = [];
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        
        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              color: AppColors.primary,
              points: polylineCoordinates,
              width: 4,
            ),
          );
        });
        
        developer.log('✅ Route réelle tracée avec ${polylineCoordinates.length} points', name: 'RideBooking');
      }
    } catch (e) {
      developer.log('❌ Erreur tracé route: $e', name: 'RideBooking');
      
      // Fallback en cas d'erreur
      try {
        double distance = await _locationService.calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _destinationPosition!.latitude,
          _destinationPosition!.longitude,
        );
        
        if (mounted) {
          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: AppColors.primary,
                points: [_currentPosition!, _destinationPosition!],
                width: 4,
              ),
            );
            _distanceKm = distance / 1000;
            _showVehicleSelection = true;
          });
        }
      } catch (e2) {
        developer.log('❌ Erreur calcul distance: $e2', name: 'RideBooking');
      }
    }
  }
  
  Future<AvailableDriver?> _findNearestDriver(String vehicleType) async {
    if (_currentPosition == null) return null;
    
    // Filtrer les chauffeurs par type de véhicule
    final driversOfType = _availableDrivers.where((d) => d.vehicleType == vehicleType).toList();
    
    if (driversOfType.isEmpty) return null;
    
    AvailableDriver? nearestDriver;
    double minDistance = double.infinity;
    
    for (var driver in driversOfType) {
      final distance = await _locationService.calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        driver.position.latitude,
        driver.position.longitude,
      );
      
      if (distance < minDistance) {
        minDistance = distance;
        nearestDriver = driver;
      }
    }
    
    return nearestDriver;
  }
  
  int _calculateEstimatedTime(double distanceKm) {
    // Vitesse moyenne en ville: 30 km/h
    final hours = distanceKm / 30;
    return (hours * 60).ceil(); // Convertir en minutes
  }

  void _fitBounds() {
    if (_currentPosition == null || _destinationPosition == null) return;
    
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _currentPosition!.latitude < _destinationPosition!.latitude
            ? _currentPosition!.latitude
            : _destinationPosition!.latitude,
        _currentPosition!.longitude < _destinationPosition!.longitude
            ? _currentPosition!.longitude
            : _destinationPosition!.longitude,
      ),
      northeast: LatLng(
        _currentPosition!.latitude > _destinationPosition!.latitude
            ? _currentPosition!.latitude
            : _destinationPosition!.latitude,
        _currentPosition!.longitude > _destinationPosition!.longitude
            ? _currentPosition!.longitude
            : _destinationPosition!.longitude,
      ),
    );
    
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 15),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Builder(
        builder: (context) => Stack(
          children: [
            // Carte Google Maps
            _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15.0,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
            
            // Header
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                
                // Greeting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Où allez-vous?',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                // Notification button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          
          // My Location badge
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.my_location, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Ma Position',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Home button (bottom left)
          Positioned(
            left: 16,
            bottom: 280,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
          
          // Recenter button (bottom right)
          Positioned(
            right: 16,
            bottom: 280,
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
                onPressed: _getCurrentLocation,
              ),
            ),
          ),
          
          // Bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildDrawer() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Text(
                  user != null ? '${user.prenom} ${user.nom}' : 'Utilisateur',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                Text(
                  user?.email ?? 'user@example.com',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                // Afficher le solde du wallet
                if (_userWallet != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${_userWallet!.soldePoints} points',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_isLoadingWallet)
                  const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mon Profil'),
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Mon Portefeuille'),
            trailing: _userWallet != null
                ? Text(
                    '${_userWallet!.soldePoints} pts',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                : null,
            onTap: () {
              Navigator.pop(context);
              context.push('/wallet');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historique des courses'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Moyens de paiement'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Aide'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Déconnexion', style: TextStyle(color: AppColors.error)),
            onTap: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    // Calculer la hauteur du bottom sheet selon l'état
    double bottomSheetHeight;
    if (_searchFocusNode.hasFocus) {
      bottomSheetHeight = MediaQuery.of(context).size.height * 0.4; // Monte à 40% quand on tape
    } else if (_showVehicleSelection) {
      bottomSheetHeight = 300; // Augmenté pour éviter l'overflow
    } else {
      bottomSheetHeight = 100; // Hauteur minimale
    }
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: bottomSheetHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Champ de recherche
          GooglePlaceAutoCompleteTextField(
            textEditingController: _searchController,
            googleAPIKey: "AIzaSyCrbY593deLu2Oic6xjs2BLN1UHmi2rBnQ",
            inputDecoration: InputDecoration(
              hintText: 'Où voulez-vous aller?',
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 22),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _destinationPosition = null;
                          _showVehicleSelection = false;
                          _selectedVehicleType = null;
                          _polylines.clear();
                          _markers.removeWhere((m) => m.markerId.value == 'destination');
                        });
                        _addDriverMarkers();
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            debounceTime: 600,
            countries: const ["cm"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              _onDestinationSelected(prediction);
            },
            itemClick: (Prediction prediction) {
              _searchController.text = prediction.description ?? '';
            },
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction.structuredFormatting?.mainText ?? '',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (prediction.structuredFormatting?.secondaryText != null)
                            Text(
                              prediction.structuredFormatting!.secondaryText!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            seperatedBuilder: const Divider(height: 1),
            isCrossBtnShown: false,
            focusNode: _searchFocusNode,
          ),
          
          if (_showVehicleSelection && _distanceKm != null && !_searchFocusNode.hasFocus) ...[
            const SizedBox(height: 16),
            
            // Titre
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose your ride',
                style: AppTextStyles.h2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Liste horizontale des véhicules
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _vehicleTypes.length,
                itemBuilder: (context, index) {
                  final vehicleType = _vehicleTypes[index];
                  final price = vehicleType.calculatePrice(_distanceKm!);
                  final estimatedTime = _calculateEstimatedTime(_distanceKm!);
                  final isSelected = _selectedVehicleType?.id == vehicleType.id;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedVehicleType = vehicleType;
                      });
                    },
                    child: Container(
                      width: 160,
                      margin: EdgeInsets.only(
                        right: index < _vehicleTypes.length - 1 ? 12 : 0,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFE0E0E0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji du véhicule
                          Text(
                            vehicleType.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 8),
                          
                          // Nom
                          Text(
                            vehicleType.name,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          
                          // Prix et places
                          Text(
                            '${price.toStringAsFixed(0)}frs → ${vehicleType.capacity}pts',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13,
                              color: isSelected ? Colors.white.withValues(alpha: 0.9) : AppColors.textSecondary,
                            ),
                          ),
                          
                          // Temps
                          Text(
                            '$estimatedTime MIN',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12,
                              color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            if (_selectedVehicleType != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  // Chercher le chauffeur le plus proche
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                  
                  final nearestDriver = await _findNearestDriver(_selectedVehicleType!.name);
                  
                  if (!mounted) return;
                  Navigator.pop(context); // Fermer le loading
                  
                  if (nearestDriver != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Chauffeur trouvé: ${nearestDriver.name} (${nearestDriver.rating}⭐) - ${_selectedVehicleType!.calculatePrice(_distanceKm!).toStringAsFixed(0)} FCFA',
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Aucun chauffeur disponible pour ce type de véhicule'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + 4),
        ],
      ),
      ),
    );
  }
}
