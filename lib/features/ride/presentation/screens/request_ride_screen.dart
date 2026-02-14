import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class RequestRideScreen extends StatefulWidget {
  const RequestRideScreen({super.key});

  @override
  State<RequestRideScreen> createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demander une course'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Map placeholder
                Container(
                  color: AppColors.surface,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 100,
                          color: AppColors.neutral.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Carte Google Maps',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Location inputs
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: AppColors.neutral.withValues(alpha: 0.3),
                                ),
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  AppTextField(
                                    controller: _pickupController,
                                    hintText: 'Point de départ',
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    controller: _dropoffController,
                                    hintText: 'Destination',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tarif estimé',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2500 FCFA',
                          style: AppTextStyles.h2,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Temps estimé',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '15 min',
                          style: AppTextStyles.h2,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Confirmer la course',
                  onPressed: () {
                    // TODO: Implement ride request
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
