import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/network/api_client.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ride/data/models/ride_request_model.dart';
import '../../data/datasources/driver_ride_datasource.dart';
import '../providers/driver_ride_provider.dart';

class RideRequestsScreen extends StatefulWidget {
  const RideRequestsScreen({super.key});

  @override
  State<RideRequestsScreen> createState() => _RideRequestsScreenState();
}

class _RideRequestsScreenState extends State<RideRequestsScreen> {
  late DriverRideProvider _rideProvider;

  @override
  void initState() {
    super.initState();
    _rideProvider = DriverRideProvider(DriverRideDataSource(ApiClient()));
    
    // Démarrer le polling si l'utilisateur est connecté
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      if (user != null) {
        _rideProvider.startPolling(int.parse(user.id));
      }
    });
  }

  @override
  void dispose() {
    _rideProvider.stopPolling();
    _rideProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return ChangeNotifierProvider.value(
      value: _rideProvider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Demandes de course'),
          backgroundColor: AppColors.background,
          elevation: 0,
          actions: [
            // Indicateur de chargement
            Consumer<DriverRideProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Consumer<DriverRideProvider>(
          builder: (context, provider, child) {
            if (provider.error != null) {
              return _buildErrorState(provider.error!);
            }

            if (provider.pendingRequests.isEmpty) {
              return _buildEmptyState();
            }

            return _buildRequestsList(provider.pendingRequests, user);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: AppColors.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Erreur',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 100,
              color: AppColors.neutral.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Aucune demande',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Les demandes de course apparaîtront ici. Assurez-vous d\'être en ligne pour recevoir des demandes.',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(List<RideRequestModel> requests, user) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final priceFCFA = request.prixPoints * 250;
        
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.person,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passager #${request.passengerId}',
                            style: AppTextStyles.h2.copyWith(fontSize: 16),
                          ),
                          Text(
                            '${request.distanceKm.toStringAsFixed(2)} km',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$priceFCFA FCFA',
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '${request.prixPoints} points',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Type de véhicule
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.vehicleType,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Pickup location
                Row(
                  children: [
                    const Icon(Icons.circle, size: 12, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Départ: ${request.departLat.toStringAsFixed(4)}, ${request.departLng.toStringAsFixed(4)}',
                        style: AppTextStyles.body.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Dropoff location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Arrivée: ${request.arriveeLat.toStringAsFixed(4)}, ${request.arriveeLng.toStringAsFixed(4)}',
                        style: AppTextStyles.body.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectRequest(request.id!, user),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                        child: const Text('Refuser'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: 'Accepter',
                        onPressed: () => _acceptRequest(request.id!, user),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _acceptRequest(int requestId, user) async {
    if (user == null) return;

    final provider = _rideProvider;
    final success = await provider.acceptRequest(requestId, int.parse(user.id));

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course acceptée !'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Naviguer vers l'écran de course active
      if (provider.activeRide != null) {
        context.push('/active-ride', extra: {
          'ride': provider.activeRide!,
          'isDriver': true,
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${provider.error ?? "Impossible d\'accepter la course"}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _rejectRequest(int requestId, user) async {
    if (user == null) return;

    final provider = _rideProvider;
    final success = await provider.rejectRequest(requestId, int.parse(user.id));

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course refusée'),
          backgroundColor: AppColors.neutral,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${provider.error ?? "Impossible de refuser la course"}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
