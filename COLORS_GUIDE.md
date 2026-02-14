# Guide des Couleurs - SafeRide

## 🎨 Palette de Couleurs Principales

### Couleurs Primaires
- **Primary (Bleu)**: `#2F1DFA` - Couleur principale de l'application
  - Utilisée pour: Boutons principaux, éléments interactifs, accents
  - RGB: (47, 29, 250)
  
- **Secondary (Orange)**: `#FF7B08` - Couleur secondaire
  - Utilisée pour: Accents secondaires, éléments de mise en évidence
  - RGB: (255, 123, 8)

### Couleurs Système
- **Background**: `#FFFFFF` - Blanc pur
  - Utilisée pour: Arrière-plans principaux
  
- **Surface**: `#F5F5F5` - Gris très clair
  - Utilisée pour: Cartes, inputs, surfaces élevées
  
- **Error**: `#E53935` - Rouge
  - Utilisée pour: Messages d'erreur, bouton SOS, alertes
  
- **Success**: `#2E7D32` - Vert
  - Utilisée pour: Messages de succès, confirmations
  
- **Warning**: `#F9A825` - Jaune/Orange
  - Utilisée pour: Avertissements, notifications importantes

### Couleurs de Texte
- **Text Primary**: `#111111` - Noir presque pur
  - Utilisée pour: Texte principal, titres
  
- **Text Secondary**: `#9E9E9E` - Gris moyen
  - Utilisée pour: Texte secondaire, descriptions, captions
  
- **Text on Primary**: `#FFFFFF` - Blanc
  - Utilisée pour: Texte sur fond bleu primaire
  
- **Text on Secondary**: `#FFFFFF` - Blanc
  - Utilisée pour: Texte sur fond orange secondaire

### Couleurs Neutres
- **Neutral**: `#9E9E9E` - Gris moyen
  - Utilisée pour: Bordures, séparateurs, icônes désactivées
  
- **Neutral Light**: `#E0E0E0` - Gris clair
  - Utilisée pour: Bordures légères, arrière-plans subtils

## 📱 Utilisation par Composant

### Boutons
- **Bouton Principal (Elevated)**
  - Background: Primary (`#2F1DFA`)
  - Text: Text on Primary (`#FFFFFF`)
  
- **Bouton Secondaire (Outlined)**
  - Border: Primary (`#2F1DFA`)
  - Text: Primary (`#2F1DFA`)
  - Background: Transparent

### Inputs
- **TextField**
  - Background: Surface (`#F5F5F5`)
  - Border (focus): Primary (`#2F1DFA`)
  - Border (error): Error (`#E53935`)
  - Text: Text Primary (`#111111`)
  - Hint: Neutral (`#9E9E9E`)

### Navigation
- **AppBar**
  - Background: Background (`#FFFFFF`)
  - Text: Text Primary (`#111111`)
  
- **Bottom Navigation**
  - Background: Background (`#FFFFFF`)
  - Selected: Primary (`#2F1DFA`)
  - Unselected: Neutral (`#9E9E9E`)

### Cartes et Surfaces
- **Card**
  - Background: Background (`#FFFFFF`)
  - Shadow: Black avec alpha 0.08
  
- **Surface Elevated**
  - Background: Surface (`#F5F5F5`)

### Écrans Spéciaux

#### Splash Screen
- Background: Primary (`#2F1DFA`)
- Icon: Text on Primary (`#FFFFFF`)
- Text: Text on Primary (`#FFFFFF`)

#### Home Screen
- Map Background: Surface (`#F5F5F5`)
- Top Bar: Background (`#FFFFFF`)
- Service Cards: Primary (`#2F1DFA`)
- SOS Button: Error (`#E53935`)

#### SOS Screen (Activé)
- Background: Error (`#E53935`)
- Text: Text on Primary (`#FFFFFF`)
- Icons: Text on Primary (`#FFFFFF`)

## 🎯 Bonnes Pratiques

### Contraste
- Toujours utiliser Text on Primary (`#FFFFFF`) sur fond Primary
- Toujours utiliser Text on Secondary (`#FFFFFF`) sur fond Secondary
- Utiliser Text Primary (`#111111`) sur fond clair
- Ratio de contraste minimum: 4.5:1 pour le texte normal

### Hiérarchie Visuelle
1. **Primaire**: Actions principales, éléments importants
2. **Secondaire**: Actions secondaires, accents
3. **Neutre**: Éléments de support, bordures
4. **Error**: Alertes, urgences, SOS

### Accessibilité
- Les couleurs respectent les normes WCAG 2.1 niveau AA
- Contraste suffisant entre texte et arrière-plan
- Ne pas utiliser uniquement la couleur pour transmettre l'information

## 🔄 Migration depuis l'Ancienne Palette

### Changements Principaux
- ❌ Ancien Primary: `#111111` (Noir)
- ✅ Nouveau Primary: `#2F1DFA` (Bleu)

- ❌ Ancien Secondary: `#FFFFFF` (Blanc)
- ✅ Nouveau Secondary: `#FF7B08` (Orange)

### Fichiers Mis à Jour
- ✅ `lib/core/constants/app_colors.dart`
- ✅ `lib/core/theme/app_theme.dart`
- ✅ `lib/features/splash/presentation/screens/splash_screen.dart`
- ✅ `lib/features/home/presentation/screens/home_screen.dart`
- ✅ `lib/features/safety/presentation/screens/sos_screen.dart`
- ✅ `lib/features/ride/presentation/screens/request_ride_screen.dart`
- ✅ `lib/shared/widgets/app_button.dart`

## 🎨 Exemples de Code

### Utiliser la Couleur Primaire
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Texte',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)
```

### Utiliser la Couleur Secondaire
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.secondary,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'Texte',
    style: TextStyle(color: AppColors.textOnSecondary),
  ),
)
```

### Utiliser les Couleurs avec Transparence
```dart
Container(
  color: AppColors.primary.withValues(alpha: 0.1), // 10% d'opacité
)
```

### Bouton avec Couleur Primaire
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Action'), // Utilise automatiquement textOnPrimary
)
```
