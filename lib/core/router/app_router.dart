import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/ride/presentation/screens/request_ride_screen.dart';
import '../../features/ride/presentation/screens/ride_booking_screen.dart';
import '../../features/ride/presentation/screens/destination_search_screen.dart';
import '../../features/ride/presentation/screens/active_ride_screen.dart';
import '../../features/ride/data/models/ride_request_model.dart';
import '../../features/safety/presentation/screens/sos_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/driver/presentation/screens/driver_home_screen.dart';
import '../../features/driver/presentation/screens/vehicle_management_screen.dart';
import '../../features/driver/presentation/screens/ride_requests_screen.dart';
import '../../features/driver/presentation/screens/driver_wallet_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        if (email.isEmpty) {
          // Si pas d'email, rediriger vers login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return OtpVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        final userRole = state.extra as String?;
        return RegisterScreen(userRole: userRole);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/request-ride',
      builder: (context, state) => const RequestRideScreen(),
    ),
    GoRoute(
      path: '/ride-booking',
      builder: (context, state) => const RideBookingScreen(),
    ),
    GoRoute(
      path: '/active-ride',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final ride = extra['ride'] as RideRequestModel;
        final isDriver = extra['isDriver'] as bool? ?? false;
        return ActiveRideScreen(ride: ride, isDriver: isDriver);
      },
    ),
    GoRoute(
      path: '/destination-search',
      builder: (context, state) => const DestinationSearchScreen(),
    ),
    GoRoute(
      path: '/sos',
      builder: (context, state) => const SosScreen(),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    
    // Driver routes
    GoRoute(
      path: '/driver/home',
      builder: (context, state) => const DriverHomeScreen(),
    ),
    GoRoute(
      path: '/driver/vehicles',
      builder: (context, state) => const VehicleManagementScreen(),
    ),
    GoRoute(
      path: '/driver/ride-requests',
      builder: (context, state) => const RideRequestsScreen(),
    ),
    GoRoute(
      path: '/driver/wallet',
      builder: (context, state) => const DriverWalletScreen(),
    ),
  ],
);
