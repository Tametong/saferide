import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _isActivated = false;

  void _activateSos() {
    setState(() {
      _isActivated = true;
    });
    
    // TODO: Implement SOS trigger
    // - Get current location
    // - Send SOS to backend
    // - Notify emergency contacts
    // - Start audio recording
  }

  void _cancelSos() {
    setState(() {
      _isActivated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urgence SOS'),
        backgroundColor: _isActivated ? AppColors.error : null,
        foregroundColor: _isActivated ? AppColors.textOnPrimary : null,
      ),
      body: Container(
        color: _isActivated ? AppColors.error : AppColors.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                
                if (!_isActivated) ...[
                  Icon(
                    Icons.emergency,
                    size: 120,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Bouton d\'urgence',
                    style: AppTextStyles.h1.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Appuyez sur le bouton ci-dessous en cas d\'urgence. Vos contacts seront notifiés et votre position sera partagée.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 120,
                    color: AppColors.textOnPrimary,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'SOS ACTIVÉ',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 32,
                      color: AppColors.textOnPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Les autorités et vos contacts d\'urgence ont été notifiés. Votre position est partagée en temps réel.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.textOnPrimary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Position partagée',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.mic,
                              color: AppColors.textOnPrimary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Enregistrement audio actif',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                
                const Spacer(),
                
                if (!_isActivated)
                  GestureDetector(
                    onTap: _activateSos,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'SOS',
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 48,
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  AppButton(
                    text: 'Annuler l\'alerte',
                    onPressed: _cancelSos,
                    isOutlined: true,
                  ),
                
                const SizedBox(height: 32),
                
                if (!_isActivated)
                  Text(
                    'Maintenez appuyé pendant 3 secondes',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
