import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import '../../../ride/data/models/ride_request_model.dart';
import '../../data/datasources/driver_ride_datasource.dart';

class DriverRideProvider extends ChangeNotifier {
  final DriverRideDataSource _dataSource;
  
  List<RideRequestModel> _pendingRequests = [];
  RideRequestModel? _activeRide;
  bool _isLoading = false;
  String? _error;
  Timer? _pollingTimer;

  DriverRideProvider(this._dataSource);

  List<RideRequestModel> get pendingRequests => _pendingRequests;
  RideRequestModel? get activeRide => _activeRide;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveRide => _activeRide != null;

  /// Démarrer le polling pour les nouvelles demandes
  void startPolling(int driverId) {
    developer.log('▶️ START POLLING - Démarrage polling pour chauffeur $driverId', name: 'DriverRideProvider');
    
    // Charger immédiatement
    loadPendingRequests(driverId);
    
    // Puis toutes les 10 secondes
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      loadPendingRequests(driverId);
    });
  }

  /// Arrêter le polling
  void stopPolling() {
    developer.log('⏹️ STOP POLLING - Arrêt polling', name: 'DriverRideProvider');
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Charger les demandes en attente
  Future<void> loadPendingRequests(int driverId) async {
    try {
      final requests = await _dataSource.getPendingRideRequests(driverId);
      
      // Ne notifier que si la liste a changé
      if (!listEquals(_pendingRequests, requests)) {
        _pendingRequests = requests;
        _error = null;
        notifyListeners();
        
        developer.log('✅ ${requests.length} demandes chargées', name: 'DriverRideProvider');
      }
    } catch (e) {
      developer.log('❌ Erreur chargement demandes: $e', name: 'DriverRideProvider');
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Accepter une demande
  Future<bool> acceptRequest(int courseId, int driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('✅ Acceptation course $courseId', name: 'DriverRideProvider');
      
      final acceptedRide = await _dataSource.acceptRideRequest(courseId, driverId);
      
      // Retirer de la liste des demandes
      _pendingRequests.removeWhere((r) => r.id == courseId);
      
      // Définir comme course active
      _activeRide = acceptedRide;
      
      _isLoading = false;
      notifyListeners();
      
      developer.log('✅ Course acceptée et définie comme active', name: 'DriverRideProvider');
      return true;
    } catch (e) {
      developer.log('❌ Erreur acceptation: $e', name: 'DriverRideProvider');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Refuser une demande
  Future<bool> rejectRequest(int courseId, int driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('❌ Refus course $courseId', name: 'DriverRideProvider');
      
      await _dataSource.rejectRideRequest(courseId, driverId);
      
      // Retirer de la liste des demandes
      _pendingRequests.removeWhere((r) => r.id == courseId);
      
      _isLoading = false;
      notifyListeners();
      
      developer.log('✅ Course refusée', name: 'DriverRideProvider');
      return true;
    } catch (e) {
      developer.log('❌ Erreur refus: $e', name: 'DriverRideProvider');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Démarrer la course active
  Future<bool> startActiveRide() async {
    if (_activeRide == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('🚗 Démarrage course ${_activeRide!.id}', name: 'DriverRideProvider');
      
      final updatedRide = await _dataSource.startRide(_activeRide!.id!);
      _activeRide = updatedRide;
      
      _isLoading = false;
      notifyListeners();
      
      developer.log('✅ Course démarrée', name: 'DriverRideProvider');
      return true;
    } catch (e) {
      developer.log('❌ Erreur démarrage: $e', name: 'DriverRideProvider');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Terminer la course active
  Future<bool> completeActiveRide() async {
    if (_activeRide == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('🏁 Fin course ${_activeRide!.id}', name: 'DriverRideProvider');
      
      await _dataSource.completeRide(_activeRide!.id!);
      _activeRide = null;
      
      _isLoading = false;
      notifyListeners();
      
      developer.log('✅ Course terminée', name: 'DriverRideProvider');
      return true;
    } catch (e) {
      developer.log('❌ Erreur fin course: $e', name: 'DriverRideProvider');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Charger la course active
  Future<void> loadActiveRide(int driverId) async {
    try {
      final ride = await _dataSource.getActiveRide(driverId);
      _activeRide = ride;
      _error = null;
      notifyListeners();
    } catch (e) {
      developer.log('❌ Erreur chargement course active: $e', name: 'DriverRideProvider');
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
