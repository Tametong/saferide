# SafeRide - Application Mobile de VTC Sécurisée

Une application mobile Flutter de ride-hailing (VTC) avec un focus particulier sur la sécurité des utilisateurs.

## 🎨 Couleurs Principales

- **Primary (Bleu)**: `#2F1DFA`
- **Secondary (Orange)**: `#FF7B08`

## ✨ Fonctionnalités

### ✅ Implémentées
- 🔐 Authentification (Login/Register)
- 🏠 Écran d'accueil avec carte
- 🚗 Demande de course
- 🆘 Bouton SOS d'urgence
- 📍 Services de géolocalisation
- 🎨 Interface professionnelle et moderne

### 🔄 En Développement
- 🗺️ Intégration Google Maps
- 👨‍✈️ Recherche de chauffeur
- 📊 Suivi en temps réel
- ⭐ Évaluation des courses

## 🏗️ Architecture

L'application suit **Clean Architecture** avec 4 couches:

```
Presentation (UI) → Domain (Business Logic) → Data (Repository) → External (API/DB)
```

### Structure du Projet

```
lib/
├── core/              # Services partagés, theme, constants
├── features/          # Features modulaires
│   ├── auth/         # Authentification
│   ├── home/         # Écran d'accueil
│   ├── ride/         # Gestion des courses
│   └── safety/       # Fonctionnalités de sécurité
└── shared/           # Widgets réutilisables
```

## 🚀 Installation

### Prérequis
- Flutter SDK 3.10.7+
- Dart SDK
- Android Studio / VS Code

### Commandes

```bash
# Cloner le projet
git clone <repository-url>
cd saferide

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

## 📦 Dépendances Principales

```yaml
dio: ^5.9.1                    # HTTP client
provider: ^6.1.5+1             # State management
go_router: ^17.1.0             # Navigation
google_maps_flutter: ^2.14.2   # Maps
geolocator: ^14.0.2            # Location
flutter_screenutil: ^5.9.3     # Responsive UI
```

## 📱 Écrans

1. **Splash Screen** - Écran de démarrage
2. **Login** - Connexion utilisateur
3. **Register** - Inscription
4. **Home** - Écran principal avec carte
5. **Request Ride** - Demande de course
6. **SOS** - Urgence et sécurité

## 🎨 Design System

### Couleurs
- Primary: `#2F1DFA` (Bleu)
- Secondary: `#FF7B08` (Orange)
- Error: `#E53935` (Rouge)
- Success: `#2E7D32` (Vert)

### Typographie
- H1: 28px, Bold
- H2: 20px, SemiBold
- Body: 16px, Regular
- Caption: 14px, Light

## 📚 Documentation

- [README.md](README.md) - Ce fichier
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Détails d'implémentation
- [COLORS_GUIDE.md](COLORS_GUIDE.md) - Guide des couleurs
- [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) - Guide du développeur
- [FIXES_APPLIED.md](FIXES_APPLIED.md) - Corrections appliquées
- [CHANGELOG.md](CHANGELOG.md) - Historique des versions

## 🧪 Tests

```bash
# Lancer les tests
flutter test

# Analyser le code
flutter analyze

# Formater le code
flutter format .
```

## 🔐 Sécurité

- Validation des inputs
- Gestion sécurisée des tokens
- Bouton SOS d'urgence
- Partage de position en temps réel (à venir)

## 🌍 Internationalisation

Actuellement en français. Support multilingue à venir.

## 📄 Licence

Copyright © 2024 SafeRide. Tous droits réservés.

## 👥 Équipe

Développé avec ❤️ par l'équipe SafeRide

## 📞 Support

Pour toute question ou problème, contactez: support@saferide.com

---

**Version**: 1.0.0  
**Dernière mise à jour**: 13 février 2024


