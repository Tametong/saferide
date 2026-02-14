import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Où voulez-vous aller?',
          style: AppTextStyles.h2.copyWith(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: "AIzaSyCrbY593deLu2Oic6xjs2BLN1UHmi2rBnQ",
              inputDecoration: InputDecoration(
                hintText: 'Rechercher une destination',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              debounceTime: 800,
              countries: const ["cm"], // Cameroun
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (Prediction prediction) {
                // Retourner les détails de la destination sélectionnée
                context.pop({
                  'description': prediction.description ?? '',
                  'lat': double.tryParse(prediction.lat ?? '0') ?? 0,
                  'lng': double.tryParse(prediction.lng ?? '0') ?? 0,
                });
              },
              itemClick: (Prediction prediction) {
                _searchController.text = prediction.description ?? '';
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: prediction.description?.length ?? 0),
                );
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prediction.structuredFormatting?.mainText ?? '',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (prediction.structuredFormatting?.secondaryText != null)
                              Text(
                                prediction.structuredFormatting!.secondaryText!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
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
              isCrossBtnShown: true,
            ),
          ),
          
          // Recent searches or suggestions
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Text(
                  'Suggestions',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSuggestionTile(
                  icon: Icons.home,
                  title: 'Domicile',
                  subtitle: 'Ajouter votre adresse',
                ),
                _buildSuggestionTile(
                  icon: Icons.work,
                  title: 'Travail',
                  subtitle: 'Ajouter votre adresse',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: AppTextStyles.body),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
      onTap: () {},
    );
  }
}
