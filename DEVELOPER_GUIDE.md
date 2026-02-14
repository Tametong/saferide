# Guide du Développeur - SafeRide

## 🚀 Démarrage Rapide

### Prérequis
- Flutter SDK 3.10.7 ou supérieur
- Dart SDK
- Android Studio / VS Code
- Émulateur Android ou iOS

### Installation

```bash
# Cloner le projet
git clone <repository-url>
cd saferide

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

## 📐 Architecture

L'application suit **Clean Architecture** avec 4 couches:

### 1. Presentation Layer (UI)
- **Responsabilité**: Affichage et interaction utilisateur
- **Contient**: Screens, Widgets, Providers
- **Règle**: Ne contient AUCUNE logique métier

```dart
// Exemple: AuthProvider
class AuthProvider extends ChangeNotifier {
  final LoginUser loginUseCase;
  
  Future<bool> login(String email, String password) async {
    _user = await loginUseCase(email, password);
    notifyListeners();
    return true;
  }
}
```

### 2. Domain Layer (Business Logic)
- **Responsabilité**: Logique métier pure
- **Contient**: Entities, UseCases, Repository Interfaces
- **Règle**: Indépendant de tout framework

```dart
// Exemple: LoginUser UseCase
class LoginUser {
  final AuthRepository repository;
  
  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
```

### 3. Data Layer (Data Management)
- **Responsabilité**: Gestion des données
- **Contient**: Models, Repository Implementations, DataSources
- **Règle**: Implémente les interfaces du Domain

```dart
// Exemple: AuthRepositoryImpl
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  @override
  Future<User> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }
}
```

### 4. Core Layer (Infrastructure)
- **Responsabilité**: Services partagés
- **Contient**: Network, Services, Theme, Constants
- **Règle**: Utilisé par toutes les autres couches

## 🎨 Système de Design

### Couleurs

```dart
// Couleurs principales
AppColors.primary      // #2F1DFA - Bleu
AppColors.secondary    // #FF7B08 - Orange

// Couleurs système
AppColors.background   // #FFFFFF
AppColors.surface      // #F5F5F5
AppColors.error        // #E53935

// Couleurs de texte
AppColors.textPrimary      // #111111
AppColors.textOnPrimary    // #FFFFFF
```

### Typographie

```dart
AppTextStyles.h1       // 28px, Bold
AppTextStyles.h2       // 20px, SemiBold
AppTextStyles.body     // 16px, Regular
AppTextStyles.caption  // 14px, Light
```

### Spacing

```dart
const EdgeInsets.all(8)    // Petit
const EdgeInsets.all(16)   // Moyen
const EdgeInsets.all(24)   // Grand
```

## 🔧 Ajouter une Nouvelle Fonctionnalité

### Étape 1: Créer la Structure

```bash
lib/features/ma_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

### Étape 2: Domain Layer

```dart
// 1. Créer l'Entity
class MyEntity {
  final int id;
  final String name;
  
  MyEntity({required this.id, required this.name});
}

// 2. Créer le Repository Interface
abstract class MyRepository {
  Future<MyEntity> getData();
}

// 3. Créer le UseCase
class GetData {
  final MyRepository repository;
  
  GetData(this.repository);
  
  Future<MyEntity> call() {
    return repository.getData();
  }
}
```

### Étape 3: Data Layer

```dart
// 1. Créer le Model
class MyModel extends MyEntity {
  MyModel({required super.id, required super.name});
  
  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

// 2. Créer le DataSource
class MyRemoteDataSource {
  final ApiClient apiClient;
  
  Future<MyModel> getData() async {
    final response = await apiClient.get('/endpoint');
    return MyModel.fromJson(response.data);
  }
}

// 3. Implémenter le Repository
class MyRepositoryImpl implements MyRepository {
  final MyRemoteDataSource dataSource;
  
  @override
  Future<MyEntity> getData() {
    return dataSource.getData();
  }
}
```

### Étape 4: Presentation Layer

```dart
// 1. Créer le Provider
class MyProvider extends ChangeNotifier {
  final GetData getDataUseCase;
  
  MyEntity? _data;
  bool _isLoading = false;
  
  MyEntity? get data => _data;
  bool get isLoading => _isLoading;
  
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    _data = await getDataUseCase();
    _isLoading = false;
    notifyListeners();
  }
}

// 2. Créer le Screen
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text('My Feature')),
      body: provider.isLoading
          ? CircularProgressIndicator()
          : Text(provider.data?.name ?? ''),
    );
  }
}
```

### Étape 5: Injection de Dépendances

```dart
// Dans main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) {
        final dataSource = MyRemoteDataSource(apiClient);
        final repository = MyRepositoryImpl(dataSource);
        final useCase = GetData(repository);
        return MyProvider(useCase);
      },
    ),
  ],
  child: MyApp(),
)
```

## 🧪 Tests

### Tests Unitaires (UseCases)

```dart
void main() {
  late MockMyRepository mockRepository;
  late GetData useCase;
  
  setUp(() {
    mockRepository = MockMyRepository();
    useCase = GetData(mockRepository);
  });
  
  test('should return data from repository', () async {
    // Arrange
    final expected = MyEntity(id: 1, name: 'Test');
    when(mockRepository.getData()).thenAnswer((_) async => expected);
    
    // Act
    final result = await useCase();
    
    // Assert
    expect(result, expected);
  });
}
```

### Tests de Widgets

```dart
void main() {
  testWidgets('should display data', (tester) async {
    // Arrange
    final provider = MyProvider(mockUseCase);
    
    // Act
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(home: MyScreen()),
      ),
    );
    
    // Assert
    expect(find.text('Test'), findsOneWidget);
  });
}
```

## 🔌 API Integration

### Configuration

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.saferide.com';
  static const String myEndpoint = '/my-endpoint';
}
```

### Utilisation

```dart
// Dans le DataSource
Future<MyModel> getData() async {
  final response = await apiClient.get(ApiConstants.myEndpoint);
  return MyModel.fromJson(response.data);
}
```

## 🎯 Bonnes Pratiques

### 1. Nommage

```dart
// Classes
class UserProfile {}           // PascalCase
class AuthRepository {}

// Variables
final userName = 'John';       // camelCase
final isLoading = false;

// Constantes
const API_KEY = 'xxx';         // SCREAMING_SNAKE_CASE
const MAX_RETRIES = 3;

// Fichiers
user_profile.dart              // snake_case
auth_repository.dart
```

### 2. Organisation des Imports

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Packages externes
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

// 4. Imports locaux
import '../../core/constants/app_colors.dart';
import '../widgets/my_widget.dart';
```

### 3. Gestion des Erreurs

```dart
try {
  final result = await useCase();
  return result;
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    throw UnauthorizedException();
  }
  throw NetworkException(e.message);
} catch (e) {
  throw UnknownException(e.toString());
}
```

### 4. State Management

```dart
// ✅ BON
class MyProvider extends ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();  // Notifier APRÈS le changement
    
    await fetchData();
    
    _isLoading = false;
    notifyListeners();
  }
}

// ❌ MAUVAIS
class MyProvider extends ChangeNotifier {
  bool isLoading = false;  // Pas de getter
  
  Future<void> loadData() async {
    notifyListeners();  // Notifier AVANT le changement
    isLoading = true;
  }
}
```

## 🐛 Debugging

### Logs

```dart
import 'dart:developer' as developer;

developer.log('Message', name: 'MyFeature');
developer.log('Error: $error', name: 'MyFeature', error: error);
```

### Flutter DevTools

```bash
# Lancer DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Dio Interceptor pour Logs

```dart
dio.interceptors.add(LogInterceptor(
  request: true,
  requestHeader: true,
  requestBody: true,
  responseHeader: true,
  responseBody: true,
  error: true,
));
```

## 📱 Build & Release

### Android

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release
```

## 🔐 Sécurité

### Stockage Sécurisé

```dart
// Ajouter flutter_secure_storage
final storage = FlutterSecureStorage();

// Sauvegarder
await storage.write(key: 'token', value: token);

// Lire
final token = await storage.read(key: 'token');

// Supprimer
await storage.delete(key: 'token');
```

### Validation des Inputs

```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email requis';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Email invalide';
  }
  return null;
}
```

## 📚 Ressources

- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Dio Documentation](https://pub.dev/packages/dio)

## 🤝 Contribution

1. Créer une branche: `git checkout -b feature/ma-feature`
2. Commit: `git commit -m 'Add: ma feature'`
3. Push: `git push origin feature/ma-feature`
4. Créer une Pull Request

## 📞 Support

Pour toute question, contactez l'équipe de développement.
