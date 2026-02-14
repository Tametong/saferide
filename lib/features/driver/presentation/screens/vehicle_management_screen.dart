import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/vehicle_remote_datasource.dart';
import '../../domain/entities/vehicle.dart';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;
  final VehicleRemoteDataSource _vehicleDataSource = VehicleRemoteDataSource();

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.user?.id;
      
      if (userId != null) {
        final vehicles = await _vehicleDataSource.getVehiclesByChauffeur(userId);
        setState(() {
          _vehicles = vehicles;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce véhicule ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _vehicleDataSource.deleteVehicle(vehicleId);
        _loadVehicles();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Véhicule supprimé avec succès'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  void _showAddVehicleDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddVehicleForm(
        onVehicleAdded: _loadVehicles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Véhicules'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vehicles.isEmpty
              ? _buildEmptyState()
              : _buildVehicleList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddVehicleDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.textOnPrimary),
        label: const Text(
          'Ajouter un véhicule',
          style: TextStyle(color: AppColors.textOnPrimary),
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
              Icons.directions_car_outlined,
              size: 100,
              color: AppColors.neutral.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Aucun véhicule',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Ajoutez votre premier véhicule pour commencer à recevoir des demandes de course',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _vehicles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            contentPadding: const EdgeInsets.all(AppSpacing.md),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_car,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            title: Text(
              '${vehicle.marque} ${vehicle.modele}',
              style: AppTextStyles.h2.copyWith(fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Immatriculation: ${vehicle.immatriculation}',
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
                Text(
                  'Type: ${vehicle.typeVehicule}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () {
                if (vehicle.id != null) {
                  _deleteVehicle(vehicle.id!);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _AddVehicleForm extends StatefulWidget {
  final VoidCallback onVehicleAdded;

  const _AddVehicleForm({required this.onVehicleAdded});

  @override
  State<_AddVehicleForm> createState() => _AddVehicleFormState();
}

class _AddVehicleFormState extends State<_AddVehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _immatriculationController = TextEditingController();
  final _anneeController = TextEditingController();
  final _couleurController = TextEditingController();
  String _selectedType = 'standard';
  bool _isLoading = false;

  final VehicleRemoteDataSource _vehicleDataSource = VehicleRemoteDataSource();

  @override
  void dispose() {
    _marqueController.dispose();
    _modeleController.dispose();
    _immatriculationController.dispose();
    _anneeController.dispose();
    _couleurController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.user?.id;

      if (userId == null) throw Exception('Utilisateur non connecté');

      await _vehicleDataSource.addVehicle(
        idChauffeur: userId,
        marque: _marqueController.text,
        modele: _modeleController.text,
        immatriculation: _immatriculationController.text,
        annee: int.parse(_anneeController.text),
        couleur: _couleurController.text,
        typeVehicule: _selectedType,
      );

      widget.onVehicleAdded();
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Véhicule ajouté avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Ajouter un véhicule',
                style: AppTextStyles.h1.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              AppTextField(
                controller: _marqueController,
                hintText: 'Ex: Toyota',
                labelText: 'Marque',
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                controller: _modeleController,
                hintText: 'Ex: Corolla',
                labelText: 'Modèle',
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                controller: _immatriculationController,
                hintText: 'Ex: ABC-123',
                labelText: 'Immatriculation',
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                controller: _anneeController,
                hintText: 'Ex: 2020',
                labelText: 'Année',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Champ requis';
                  final year = int.tryParse(value!);
                  if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                    return 'Année invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              
              AppTextField(
                controller: _couleurController,
                hintText: 'Ex: Blanc',
                labelText: 'Couleur',
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type de véhicule',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'standard', child: Text('Standard')),
                  DropdownMenuItem(value: 'confort', child: Text('Confort')),
                  DropdownMenuItem(value: 'premium', child: Text('Premium')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              
              AppButton(
                text: 'Ajouter',
                onPressed: _isLoading ? null : _submitForm,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
