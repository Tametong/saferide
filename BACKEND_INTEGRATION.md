# Backend Integration - Chauffeurs API

## Résumé
Intégration de l'API backend Laravel pour récupérer les chauffeurs disponibles en temps réel.

## Fichiers créés

### 1. `lib/features/ride/data/models/chauffeur_model.dart`
Modèle de données correspondant à la structure backend:
- Conversion JSON ↔ Dart
- Gestion des types (String/int/double/bool)
- Extraction des données utilisateur (nom, prénom)
- Valeurs par défaut pour compatibilité

### 2. `lib/features/ride/data/datasources/chauffeur_remote_datasource.dart`
Source de données pour l'API chauffeurs:
- `getAvailableDrivers()` - Liste des chauffeurs disponibles
- `getChauffeurProfile(id)` - Profil d'un chauffeur
- `updateChauffeurLocation(id, lat, lng)` - Mise à jour position chauffeur
- `updatePassagerLocation(id, lat, lng)` - Mise à jour position passager
- Filtrage automatique: `est_en_ligne = true` ET `statut_validation = 'Valide'`
- Logging complet pour debugging

### 3. `hackaton/database/migrations/2026_02_14_000001_add_est_en_ligne_to_chauffeurs_table.php`
Migration pour ajouter le champ `est_en_ligne` manquant dans la table chauffeurs.

## Fichiers modifiés

### 1. `lib/core/constants/api_constants.dart`
Ajout des endpoints:
- `/passager/liste-chauffeurs` - Liste des chauffeurs
- `/chauffeur/profile/{id}` - Profil chauffeur
- `/chauffeur/location/{id}` - Position chauffeur
- `/passager/location/{id}` - Position passager
- `/admin/chauffeurs` - Admin endpoints

### 2. `lib/core/network/api_client.dart`
Ajout de la méthode `patch()` pour les requêtes PATCH.

### 3. `lib/features/ride/domain/entities/available_driver.dart`
Ajout des champs backend:
- `numeroPermis` - Numéro de permis
- `photoPieceIdentite` - Photo pièce d'identité
- `statutValidation` - Statut de validation
- `estEnLigne` - Disponibilité en ligne

### 4. `lib/features/ride/presentation/screens/ride_booking_screen.dart`
Remplacement des données simulées par l'API:
- Initialisation de `ChauffeurRemoteDataSource`
- Appel API dans `_loadAvailableDrivers()`
- Gestion des erreurs avec retry
- Loading state

## Structure Backend

### Modèle Chauffeur
```php
{
  "id_user": int,
  "numero_permis": string,
  "photo_piece_identite": string,
  "statut_validation": "En attente" | "Valide" | "Bloque",
  "note_moyenne": decimal(3,2),
  "latitude": decimal(10,7),
  "longitude": decimal(10,7),
  "est_en_ligne": boolean,
  "user": {
    "nom": string,
    "prenom": string,
    ...
  }
}
```

### Réponse API
```json
{
  "status": "success",
  "data": [
    { /* chauffeur 1 */ },
    { /* chauffeur 2 */ }
  ]
}
```

## Filtrage des chauffeurs

Les chauffeurs affichés sur la carte doivent respecter:
1. `est_en_ligne = true` - Le chauffeur est connecté
2. `statut_validation = 'Valide'` - Le compte est validé par l'admin

Les chauffeurs avec `statut_validation = 'En attente'` ou `'Bloque'` ne sont pas affichés.

## Migration à exécuter

Pour ajouter le champ `est_en_ligne`:
```bash
cd hackaton
php artisan migrate
```

## Tests

Pour tester l'intégration:
1. S'assurer que le backend Laravel est démarré
2. Créer des chauffeurs de test avec `statut_validation = 'Valide'`
3. Mettre `est_en_ligne = true` pour les chauffeurs à afficher
4. Lancer l'app Flutter et vérifier les logs

## Logs de debugging

Les logs sont préfixés par:
- `[ChauffeurDataSource]` - Datasource
- `[RideBooking]` - Écran de réservation
- `[ApiClient]` - Client HTTP

## Prochaines étapes

1. Implémenter la mise à jour de position en temps réel
2. Ajouter le type de véhicule dans le backend
3. Implémenter la recherche de chauffeur le plus proche
4. Gérer le statut en ligne/hors ligne des chauffeurs
