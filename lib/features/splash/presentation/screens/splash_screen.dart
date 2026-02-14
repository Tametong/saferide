import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/role-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo/logo.png",
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 24),
            Text(
              'SafeRide',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre sécurité, notre priorité',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textOnPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
