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
import '../../features/safety/presentation/screens/sos_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

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
        final email = state.extra as String;
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
  ],
);
