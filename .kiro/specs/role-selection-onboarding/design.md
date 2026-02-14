# Design Document: Role Selection Onboarding

## Overview

The role selection onboarding feature introduces a new screen in the SafeRide Flutter application that allows first-time users to choose between Passenger ("Passager") and Driver ("Conducteur") roles. This screen appears after the splash screen and before the registration flow, directing users to role-specific registration based on their selection.

The feature integrates with the existing Flutter app architecture using Provider for state management, go_router for navigation, and follows the established clean architecture pattern with presentation, domain, and data layers.

## Architecture

### High-Level Architecture

```
┌─────────────────┐
│  Splash Screen  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ Role Selection Screen   │
│  - Passager option      │
│  - Conducteur option    │
└────────┬────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌────────┐  ┌────────┐
│Passenger│  │ Driver │
│Register │  │Register│
└─────────┘  └────────┘
```

### Layer Architecture

Following the app's clean architecture pattern:

```
Presentation Layer
├── screens/
│   └── role_selection_screen.dart
├── providers/
│   └── onboarding_provider.dart
└── widgets/
    └── role_option_card.dart

Domain Layer
├── entities/
│   └── user_role.dart
├── repositories/
│   └── onboarding_repository.dart
└── usecases/
    ├── check_onboarding_status.dart
    └── save_user_role.dart

Data Layer
├── datasources/
│   └── onboarding_local_datasource.dart
├── repositories/
│   └── onboarding_repository_impl.dart
└── models/
    └── user_role_model.dart
```

## Components and Interfaces

### 1. Role Selection Screen (Presentation)

**File:** `lib/features/onboarding/presentation/screens/role_selection_screen.dart`

The main UI screen that displays role options to first-time users.

**Responsibilities:**
- Display title and subtitle text
- Render two role option cards (Passager and Conducteur)
- Handle user tap events on role options
- Navigate to appropriate registration screen based on selection
- Display back button for navigation

**Key Methods:**
```dart
class RoleSelectionScreen extends StatelessWidget {
  void _handleRoleSelection(BuildContext context, UserRole role);
  Widget _buildRoleOption(UserRole role, IconData icon, String label);
}
```

### 2. Role Option Card Widget (Presentation)

**File:** `lib/features/onboarding/presentation/widgets/role_option_card.dart`

A reusable widget for displaying individual role options.

**Responsibilities:**
- Display role icon and label
- Provide visual feedback on tap
- Apply consistent styling from app theme

**Interface:**
```dart
class RoleOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
}
```

### 3. Onboarding Provider (Presentation)

**File:** `lib/features/onboarding/presentation/providers/onboarding_provider.dart`

State management for onboarding flow using Provider pattern (consistent with AuthProvider).

**Responsibilities:**
- Check if user has completed onboarding
- Save selected user role
- Mark onboarding as completed
- Provide loading and error states

**Interface:**
```dart
class OnboardingProvider extends ChangeNotifier {
  final CheckOnboardingStatus checkOnboardingStatusUseCase;
  final SaveUserRole saveUserRoleUseCase;
  
  bool _isOnboardingCompleted = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  bool get isOnboardingCompleted;
  bool get isLoading;
  String? get errorMessage;
  
  Future<bool> checkOnboardingStatus();
  Future<bool> saveUserRole(UserRole role);
}
```

### 4. User Role Entity (Domain)

**File:** `lib/features/onboarding/domain/entities/user_role.dart`

Domain entity representing user role selection.

**Definition:**
```dart
enum UserRole {
  passenger,
  driver;
  
  String toJson();
  static UserRole fromJson(String json);
}
```

### 5. Onboarding Repository Interface (Domain)

**File:** `lib/features/onboarding/domain/repositories/onboarding_repository.dart`

Abstract repository defining onboarding operations.

**Interface:**
```dart
abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
  Future<void> saveUserRole(UserRole role);
  Future<UserRole?> getUserRole();
}
```

### 6. Use Cases (Domain)

**Check Onboarding Status Use Case**
```dart
class CheckOnboardingStatus {
  final OnboardingRepository repository;
  
  Future<bool> call();
}
```

**Save User Role Use Case**
```dart
class SaveUserRole {
  final OnboardingRepository repository;
  
  Future<void> call(UserRole role);
}
```

### 7. Onboarding Local Data Source (Data)

**File:** `lib/features/onboarding/data/datasources/onboarding_local_datasource.dart`

Handles local storage operations using SharedPreferences.

**Responsibilities:**
- Store and retrieve onboarding completion status
- Store and retrieve selected user role
- Provide synchronous and asynchronous access methods

**Interface:**
```dart
abstract class OnboardingLocalDataSource {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool completed);
  Future<void> saveUserRole(String role);
  Future<String?> getUserRole();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyUserRole = 'user_role';
}
```

### 8. Onboarding Repository Implementation (Data)

**File:** `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart`

Concrete implementation of the onboarding repository.

**Responsibilities:**
- Implement repository interface
- Delegate to local data source
- Convert between domain entities and data models

### 9. Router Integration

**File:** `lib/core/router/app_router.dart`

Update existing router to include role selection screen and separate registration routes.

**New Routes:**
```dart
GoRoute(
  path: '/role-selection',
  builder: (context, state) => const RoleSelectionScreen(),
),
GoRoute(
  path: '/register/passenger',
  builder: (context, state) => const RegisterScreen(role: UserRole.passenger),
),
GoRoute(
  path: '/register/driver',
  builder: (context, state) => const RegisterScreen(role: UserRole.driver),
),
```

### 10. Splash Screen Update

**File:** `lib/features/splash/presentation/screens/splash_screen.dart`

Modify splash screen navigation logic to check onboarding status.

**Updated Navigation Logic:**
```dart
Future<void> _navigateToNextScreen() async {
  await Future.delayed(const Duration(seconds: 2));
  
  final onboardingProvider = context.read<OnboardingProvider>();
  final isCompleted = await onboardingProvider.checkOnboardingStatus();
  
  if (mounted) {
    if (isCompleted) {
      context.go('/login');
    } else {
      context.go('/role-selection');
    }
  }
}
```

## Data Models

### User Role Model

**File:** `lib/features/onboarding/data/models/user_role_model.dart`

```dart
class UserRoleModel {
  final String role;
  
  UserRoleModel({required this.role});
  
  // Convert to domain entity
  UserRole toEntity() {
    return UserRole.fromJson(role);
  }
  
  // Create from domain entity
  factory UserRoleModel.fromEntity(UserRole role) {
    return UserRoleModel(role: role.toJson());
  }
  
  // JSON serialization
  Map<String, dynamic> toJson() => {'role': role};
  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(role: json['role']);
  }
}
```

### Local Storage Keys

```dart
class OnboardingStorageKeys {
  static const String onboardingCompleted = 'onboarding_completed';
  static const String userRole = 'user_role';
}
```

### Storage Schema

**SharedPreferences Storage:**
- `onboarding_completed`: bool - Whether user has completed onboarding
- `user_role`: String - Selected role ("passenger" or "driver")

## Correctness Properties

