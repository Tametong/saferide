import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Écran de démonstration des couleurs de l'application
/// Utile pour visualiser la palette complète
class ColorDemoScreen extends StatelessWidget {
  const ColorDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palette de Couleurs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Couleurs Principales',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 16),
          _buildColorCard(
            'Primary',
            AppColors.primary,
            '#2F1DFA',
            'Boutons principaux, accents',
          ),
          _buildColorCard(
            'Secondary',
            AppColors.secondary,
            '#FF7B08',
            'Accents secondaires',
          ),
          const SizedBox(height: 24),
          const Text(
            'Couleurs Système',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 16),
          _buildColorCard(
            'Background',
            AppColors.background,
            '#FFFFFF',
            'Arrière-plans principaux',
            textColor: AppColors.textPrimary,
          ),
          _buildColorCard(
            'Surface',
            AppColors.surface,
            '#F5F5F5',
            'Cartes, inputs',
            textColor: AppColors.textPrimary,
          ),
          _buildColorCard(
            'Error',
            AppColors.error,
            '#E53935',
            'Erreurs, SOS',
          ),
          _buildColorCard(
            'Success',
            AppColors.success,
            '#2E7D32',
            'Succès, confirmations',
          ),
          _buildColorCard(
            'Warning',
            AppColors.warning,
            '#F9A825',
            'Avertissements',
          ),
          const SizedBox(height: 24),
          const Text(
            'Couleurs de Texte',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 16),
          _buildColorCard(
            'Text Primary',
            AppColors.textPrimary,
            '#111111',
            'Texte principal',
            textColor: AppColors.textOnPrimary,
          ),
          _buildColorCard(
            'Text Secondary',
            AppColors.textSecondary,
            '#9E9E9E',
            'Texte secondaire',
          ),
          _buildColorCard(
            'Text on Primary',
            AppColors.textOnPrimary,
            '#FFFFFF',
            'Texte sur fond bleu',
            textColor: AppColors.textPrimary,
          ),
          const SizedBox(height: 24),
          const Text(
            'Exemples d\'Utilisation',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: 16),
          _buildExampleButton(),
          const SizedBox(height: 16),
          _buildExampleCard(),
        ],
      ),
    );
  }

  Widget _buildColorCard(
    String name,
    Color color,
    String hex,
    String usage, {
    Color textColor = AppColors.textOnPrimary,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: color == AppColors.background || color == AppColors.textOnPrimary
            ? Border.all(color: AppColors.neutralLight)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTextStyles.h2.copyWith(
              color: textColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hex,
            style: AppTextStyles.body.copyWith(
              color: textColor.withValues(alpha: 0.8),
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            usage,
            style: AppTextStyles.caption.copyWith(
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bouton Principal',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action Principale'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Bouton Secondaire',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Action Secondaire'),
        ),
      ],
    );
  }

  Widget _buildExampleCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Carte Exemple',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutralLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_taxi,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Titre de la Carte',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Description secondaire',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Information avec surface colorée',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
