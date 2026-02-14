import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton retour
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Titre
              Text(
                'Inscription à SafeRide....',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                ),
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Sous-titre
              Text(
                'Veuillez choisir votre profil\npour continuer',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              
              const Spacer(),
              
              // Option Passager
              _RoleCard(
                icon: Icons.person,
                label: 'Passager',
                onTap: () => context.push('/register', extra: 'passager'),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Option Conducteur
              _RoleCard(
                icon: Icons.directions_car,
                label: 'Conducteur',
                onTap: () => context.push('/register', extra: 'chauffeur'),
              ),
              
              const Spacer(flex: 2),
              
              // Lien vers login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà un compte ? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    child: Text(
                      'Se connecter',
                      style: AppTextStyles.body.copyWith(
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
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.neutralLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.textOnPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
