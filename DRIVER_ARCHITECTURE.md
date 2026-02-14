# Architecture des Données Conducteur

## Vue d'ensemble

L'architecture sépare les données statiques du profil conducteur des données dynamiques de localisation.

## 1. Données Statiques (Profil Conducteur)

### Stockées dans `User.driverProfile`
- `numero_permis` (licenseNumber) - Numéro du permis de conduire
- `photo_piece_identite` (idPhotoUrl) - URL de la photo de la pièce d'identité
- `statut_validation` (validationStatus) - Statut de validation: pending, approved, rejected, suspended
- `note_moyenne` (averageRating) - Note moyenne du conducteur (0.0 - 5.0)
- `total_rides` (totalRides) - Nombre total de courses effectuées

### Fichiers concernés
- `lib/features/auth/domain/entities/user.dart` - Entité User avec DriverProfile
- `lib/features/auth/data/models/user_model.dart` - Modèle avec sérialisation JSON

## 2. Données Dynamiques (Localisation)

### Entité `DriverLocation` (temps réel)
- `driver_id` - ID du conducteur
- `latitude` - Latitude actuelle
- `longitude` - Longitude actuelle
- `timestamp` - Horodatage de la position
- `is_available` - Disponibilité du conducteur
- `heading` (optionnel) - Direction du véhicule
- `speed` (optionnel) - Vitesse du véhicule

### Fichiers concernés
- `lib/features/driver/domain/entities/driver_location.dart` - Entité avec calcul de distance
- `lib/features/driver/data/models/driver_location_model.dart` - Modèle avec sérialisation
- `lib/features/driver/data/datasources/driver_location_datasource.dart` - Service de mise à jour

### Fonctionnalités
- Mise à jour automatique de la position (toutes les 10 secondes)
- Recherche de conducteurs à proximité
- Calcul de distance entre deux points
- Gestion de la disponibilité

## 3. Données Véhicule

### Entité `Vehicle` (séparée)
- `vehicle_type` - Type: sedan, suv, van, motorcycle
- `brand` - Marque
- `model` - Modèle
- `color` - Couleur
- `license_plate` - Plaque d'immatriculation
- `year` - Année
- `seats` - Nombre de places
- `is_active` - Véhicule actif ou non

### Fichiers concernés
- `lib/features/driver/domain/entities/vehicle.dart`
- `lib/features/driver/data/models/vehicle_model.dart`

## 4. Flux de Données

### Inscription Conducteur
1. Conducteur s'inscrit avec rôle = 'driver'
2. Profil créé avec `statut_validation = 'pending'`
3. Conducteur ajoute ses documents (permis, pièce d'identité) depuis son profil
4. Admin valide le profil → `statut_validation = 'approved'`

### Localisation en Temps Réel
1. Conducteur se connecte et active la disponibilité
2. App envoie la position GPS toutes les 10 secondes via `DriverLocationDataSource`
3. Backend stocke la dernière position en cache (Redis recommandé)
4. Passagers recherchent des conducteurs via `getNearbyDrivers()`

### Gestion Véhicule
1. Conducteur ajoute son véhicule depuis son profil
2. Peut avoir plusieurs véhicules, un seul actif à la fois
3. Informations du véhicule affichées aux passagers lors de la réservation

## 5. Recommandations Backend

### Pour la localisation
- Utiliser Redis pour stocker les positions en temps réel (TTL: 30 secondes)
- WebSocket ou Server-Sent Events pour les mises à jour en temps réel
- Index géospatial pour la recherche de proximité

### Pour les données statiques
- Base de données relationnelle (PostgreSQL)
- Stockage des photos sur S3 ou service similaire
- Validation manuelle ou automatique des documents
