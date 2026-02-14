import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _telephoneController;
  late TextEditingController _villeController;
  
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    _nomController = TextEditingController(text: user?.nom ?? '');
    _prenomController = TextEditingController(text: user?.prenom ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _telephoneController = TextEditingController(text: user?.telephone ?? '');
    _villeController = TextEditingController(text: user?.ville ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // TODO: Implémenter l'API de mise à jour du profil
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
      _isEditing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil mis à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() => _isEditing = false);
                // Réinitialiser les valeurs
                _nomController.text = user?.nom ?? '';
                _prenomController.text = user?.prenom ?? '';
                _emailController.text = user?.email ?? '';
                _telephoneController.text = user?.telephone ?? '';
                _villeController.text = user?.ville ?? '';
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo de profil
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.prenom.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Nom complet
              if (!_isEditing)
                Text(
                  user?.fullName ?? 'Utilisateur',
                  style: AppTextStyles.h1.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              
              const SizedBox(height: 8),
              
              // Email
              if (!_isEditing)
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              const SizedBox(height: 32),
              
              // Formulaire
              _buildTextField(
                controller: _prenomController,
                label: 'Prénom',
                icon: Icons.person,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _nomController,
                label: 'Nom',
                icon: Icons.person_outline,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                enabled: _isEditing,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _telephoneController,
                label: 'Téléphone',
                icon: Icons.phone,
                enabled: _isEditing,
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _villeController,
                label: 'Ville',
                icon: Icons.location_city,
                enabled: _isEditing,
              ),
              
              const SizedBox(height: 32),
              
              // Bouton sauvegarder
              if (_isEditing)
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Enregistrer les modifications'),
                ),
              
              const SizedBox(height: 16),
              
              // Informations supplémentaires
              if (!_isEditing) ...[
                const Divider(height: 32),
                
                ListTile(
                  leading: const Icon(Icons.badge, color: AppColors.primary),
                  title: const Text('Rôle'),
                  subtitle: Text(
                    user?.role == 'chauffeur' ? 'Chauffeur' : 'Passager',
                  ),
                ),
                
                ListTile(
                  leading: const Icon(Icons.verified, color: AppColors.primary),
                  title: const Text('Statut du compte'),
                  subtitle: const Text('Vérifié'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
                
                const SizedBox(height: 16),
                
                // Bouton déconnexion
                OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Déconnexion'),
                        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Annuler'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text('Déconnexion'),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true && mounted) {
                      await authProvider.logout();
                      if (mounted) context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text(
                    'Se déconnecter',
                    style: TextStyle(color: AppColors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: enabled ? null : AppColors.surface,
      ),
    );
  }
}
