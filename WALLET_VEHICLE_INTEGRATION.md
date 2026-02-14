# Intégration Wallet & Véhicules

## Résumé
Intégration complète du système de portefeuille (wallet) et de gestion des véhicules, avec affichage des informations utilisateur.

## Backend - Nouveaux fichiers créés

### 1. Contrôleurs

#### `hackaton/app/Http/Controllers/PortefeuilleController.php`
Gestion du portefeuille utilisateur:
- `show($userId)` - Récupérer le portefeuille
- `crediter($userId)` - Créditer des points
- `debiter($userId)` - Débiter des points

#### `hackaton/app/Http/Controllers/VehiculeController.php`
Gestion des véhicules:
- `index($chauffeurId)` - Liste des véhicules d'un chauffeur
- `show($id)` - Détails d'un véhicule
- `store()` - Créer un véhicule
- `update($id)` - Mettre à jour un véhicule
- `destroy($id)` - Supprimer un véhicule

### 2. Modèles

#### `hackaton/app/Models/Vehicule.php`
Modèle pour la table `vehicules`:
- Relation avec `Chauffeur`
- Champs: marque, modele, immatriculation, couleur, annee, type

### 3. Routes API

Ajout dans `hackaton/routes/api.php`:

**Véhicules:**
```php
GET    /chauffeur/{id}/vehicules      - Liste des véhicules
POST   /chauffeur/vehicules            - Créer un véhicule
GET    /chauffeur/vehicules/{id}       - Détails véhicule
PUT    /chauffeur/vehicules/{id}       - Modifier véhicule
DELETE /chauffeur/vehicules/{id}       - Supprimer véhicule
```

**Portefeuille:**
```php
GET  /portefeuille/{userId}            - Récupérer le portefeuille
POST /portefeuille/{userId}/crediter   - Créditer des points
POST /portefeuille/{userId}/debiter    - Débiter des points
```

## Frontend Flutter - Nouveaux fichiers créés

### 1. Wallet Feature

#### `lib/features/wallet/domain/entities/wallet.dart`
Entité Wallet:
- `id` - ID du portefeuille
- `userId` - ID utilisateur
- `soldePoints` - Solde en points
- `dateDerniereMaj` - Date dernière mise à jour

#### `lib/features/wallet/data/models/wallet_model.dart`
Modèle avec conversion JSON ↔ Dart

#### `lib/features/wallet/data/datasources/wallet_remote_datasource.dart`
Source de données API:
- `getWallet(userId)` - Récupérer le portefeuille
- `crediterWallet(userId, points)` - Créditer
- `debiterWallet(userId, points)` - Débiter

### 2. Vehicle Feature

#### `lib/features/driver/data/datasources/vehicle_remote_datasource.dart`
Source de données API:
- `getDriverVehicles(chauffeurId)` - Liste des véhicules
- `getVehicle(vehicleId)` - Détails véhicule
- `createVehicle(vehicle)` - Créer
- `updateVehicle(vehicleId, vehicle)` - Modifier
- `deleteVehicle(vehicleId)` - Supprimer

## Fichiers modifiés

### 1. Backend

#### `hackaton/routes/api.php`
Ajout des routes pour véhicules et portefeuille

### 2. Frontend

#### `lib/core/constants/api_constants.dart`
Ajout des endpoints:
- `chauffeurVehicules` - Véhicules du chauffeur
- `vehicules` - CRUD véhicules
- `portefeuille` - Wallet

#### `lib/features/auth/domain/entities/user.dart`
Mise à jour pour correspondre au backend:
- `id` changé de `int` à `String`
- `name` séparé en `nom` et `prenom`
- Ajout getter `fullName`

#### `lib/features/auth/data/models/user_model.dart`
Mise à jour du mapping JSON:
- Support de `nom` et `prenom` séparés
- Conversion `id` en String

#### `lib/features/driver/data/models/vehicle_model.dart`
Mise à jour pour correspondre au backend:
- Mapping `id_vehicule` ↔ `id`
- Mapping `id_chauffeur` ↔ `driverId`
- Mapping `marque` ↔ `brand`
- Mapping `modele` ↔ `model`
- Mapping `couleur` ↔ `color`
- Mapping `immatriculation` ↔ `licensePlate`
- Mapping `annee` ↔ `year`
- Mapping `type` ↔ `vehicleType`

#### `lib/features/ride/presentation/screens/ride_booking_screen.dart`
Ajout de l'affichage des informations utilisateur:
- Import de `AuthProvider` et `WalletRemoteDataSource`
- Chargement du wallet au démarrage
- Affichage dans le drawer:
  - Nom complet de l'utilisateur
  - Email
  - Solde du portefeuille
- Menu "Mon Portefeuille" avec solde

## Structure des données

### Portefeuille (Backend)
```json
{
  "id_portefeuille": 1,
  "user_id": 5,
  "solde_points": 1500,
  "date_derniere_maj": "2026-02-14T10:30:00"
}
```

### Véhicule (Backend)
```json
{
  "id_vehicule": 1,
  "id_chauffeur": 3,
  "marque": "Toyota",
  "modele": "Corolla",
  "immatriculation": "ABC-123-XY",
  "couleur": "Blanc",
  "annee": 2020,
  "type": "sedan"
}
```

## Fonctionnalités implémentées

### Wallet
✅ Récupération du solde
✅ Affichage dans le drawer
✅ Crédit de points (API)
✅ Débit de points (API)
✅ Gestion des erreurs
✅ Loading states

### Véhicules
✅ CRUD complet (API)
✅ Liste des véhicules par chauffeur
✅ Mapping backend ↔ frontend
✅ Validation des données
✅ Gestion des erreurs

### Informations utilisateur
✅ Affichage nom complet
✅ Affichage email
✅ Affichage solde wallet
✅ Déconnexion fonctionnelle

## Tests à effectuer

### 1. Créer un portefeuille
```bash
# Via Laravel Tinker
php artisan tinker
>>> $wallet = \App\Models\Portefeuille::create(['user_id' => 1, 'solde_points' => 1000]);
```

### 2. Créer un véhicule
```bash
# Via API ou Tinker
>>> $vehicle = \App\Models\Vehicule::create([
    'id_chauffeur' => 1,
    'marque' => 'Toyota',
    'modele' => 'Corolla',
    'immatriculation' => 'ABC-123',
    'couleur' => 'Blanc',
    'annee' => 2020,
    'type' => 'sedan'
]);
```

### 3. Tester l'app Flutter
1. Se connecter avec un utilisateur
2. Ouvrir le drawer
3. Vérifier l'affichage:
   - Nom et prénom
   - Email
   - Solde du portefeuille

## Endpoints API disponibles

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/portefeuille/{userId}` | GET | Récupérer le portefeuille |
| `/portefeuille/{userId}/crediter` | POST | Créditer des points |
| `/portefeuille/{userId}/debiter` | POST | Débiter des points |
| `/chauffeur/{id}/vehicules` | GET | Liste des véhicules |
| `/chauffeur/vehicules` | POST | Créer un véhicule |
| `/chauffeur/vehicules/{id}` | GET | Détails véhicule |
| `/chauffeur/vehicules/{id}` | PUT | Modifier véhicule |
| `/chauffeur/vehicules/{id}` | DELETE | Supprimer véhicule |

## Prochaines étapes

1. ✅ Créer un écran dédié au portefeuille
2. ✅ Créer un écran de gestion des véhicules (pour chauffeurs)
3. ✅ Implémenter les transactions de points
4. ✅ Historique des transactions
5. ✅ Système de récompenses/fidélité
6. ✅ Notifications de crédit/débit

## Notes importantes

- Le portefeuille est créé automatiquement lors de l'inscription (à implémenter dans AuthController)
- Les points peuvent être utilisés pour payer des courses
- Les chauffeurs peuvent avoir plusieurs véhicules
- Le type de véhicule influence le prix de la course
