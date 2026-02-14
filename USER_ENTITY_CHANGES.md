# Changements de l'entité User

## Modifications apportées

L'entité `User` a été mise à jour pour correspondre à la structure du backend Laravel.

### Avant
```dart
class User {
  final int id;
  final String name;
  // ...
}
```

### Après
```dart
class User {
  final String id;        // Changé de int à String
  final String nom;       // Séparé de name
  final String prenom;    // Séparé de name
  // ...
  
  String get fullName => '$prenom $nom';  // Nouveau getter
}
```

## Raisons du changement

1. **Backend utilise `nom` et `prenom` séparés** - Le backend Laravel stocke le nom et le prénom dans des champs séparés
2. **ID en String** - Pour plus de flexibilité et compatibilité avec différents types d'ID
3. **Getter `fullName`** - Pour faciliter l'affichage du nom complet

## Fichiers modifiés

### Entités et Modèles
- ✅ `lib/features/auth/domain/entities/user.dart`
- ✅ `lib/features/auth/data/models/user_model.dart`

### Écrans
- ✅ `lib/features/home/presentation/screens/home_screen.dart`
- ✅ `lib/features/ride/presentation/screens/ride_booking_screen.dart`

## Utilisation

### Afficher le prénom
```dart
Text('Bonjour, ${user.prenom}')
```

### Afficher le nom complet
```dart
Text(user.fullName)  // Affiche "Prenom Nom"
```

### Afficher l'initiale
```dart
Text(user.prenom.substring(0, 1).toUpperCase())
```

## Migration des données

Si vous avez des données existantes avec le champ `name`, vous devrez les migrer:

```php
// Dans Laravel
$users = User::all();
foreach ($users as $user) {
    $parts = explode(' ', $user->name, 2);
    $user->prenom = $parts[0] ?? '';
    $user->nom = $parts[1] ?? '';
    $user->save();
}
```

## Compatibilité

Tous les fichiers ont été mis à jour pour utiliser la nouvelle structure. Aucune action supplémentaire n'est requise.
