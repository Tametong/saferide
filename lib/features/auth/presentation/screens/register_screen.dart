import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final String? userRole;
  
  const RegisterScreen({super.key, this.userRole});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _password = '';
  File? _idPhotoFile;
  final ImagePicker _imagePicker = ImagePicker();

  bool get _isDriver => widget.userRole == 'chauffeur';

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickIdPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromSource(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Choisir depuis la galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: AppColors.error),
                title: const Text('Annuler'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _idPhotoFile = File(pickedFile.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo sélectionnée avec succès'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Validation supplémentaire pour les conducteurs
      if (_isDriver && _idPhotoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez ajouter une photo de votre pièce d\'identité'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.register(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        telephone: _telephoneController.text.trim(),
        role: widget.userRole ?? 'passager',
        licenseNumber: _isDriver ? _licenseNumberController.text.trim() : null,
        idPhotoPath: _isDriver && _idPhotoFile != null ? _idPhotoFile!.path : null,
      );

      if (success && mounted) {
        context.go('/home');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Erreur d\'inscription'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleText = widget.userRole == 'chauffeur' ? 'Conducteur' : 'Passager';
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Créer un compte $roleText', style: AppTextStyles.h1),
                const SizedBox(height: 8),
                const Text(
                  'Rejoignez SafeRide aujourd\'hui',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _nomController,
                  hintText: 'Entrez votre nom',
                  labelText: 'Nom',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _prenomController,
                  hintText: 'Entrez votre prénom',
                  labelText: 'Prénom',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  hintText: 'Entrez votre email',
                  labelText: 'Email',
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
                AppTextField(
                  controller: _telephoneController,
                  hintText: 'Entrez votre numéro',
                  labelText: 'Téléphone',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre numéro';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Entrez votre mot de passe',
                  labelText: 'Mot de passe',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.neutral,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  onChanged: (value){
                    _password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  
                  hintText: 'Confirmez le mot de passe',
                  labelText: 'Confirmer mot de passe',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.neutral,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      return 'Veuillez confirmer le mot de passe';
                    }
                    if (value != _password) {
                      return 'veuillez entrer le même mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                
                // Champs spécifiques pour les conducteurs
                if (_isDriver) ...[
                  const SizedBox(height: 32),
                  Text(
                    'Informations du conducteur',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _licenseNumberController,
                    hintText: 'Ex: ABC123456',
                    labelText: 'Numéro de permis',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro de permis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.neutralLight),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pièce d\'identité',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Aperçu de l'image sélectionnée
                        if (_idPhotoFile != null)
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _idPhotoFile!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.neutralLight),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Aucune photo sélectionnée',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 12),
                        
                        // Boutons d'action
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _pickIdPhoto,
                                icon: const Icon(Icons.add_a_photo),
                                label: Text(_idPhotoFile == null ? 'Ajouter' : 'Changer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textOnPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            if (_idPhotoFile != null) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _idPhotoFile = null;
                                  });
                                },
                                icon: const Icon(Icons.delete),
                                color: AppColors.error,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AppButton(
                      text: 'S\'inscrire',
                      onPressed: authProvider.isLoading ? null : _handleRegister,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Déjà un compte ? ',
                      style: AppTextStyles.body,
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
