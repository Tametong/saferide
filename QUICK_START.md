# Guide de Démarrage Rapide

## 🚀 Démarrage en 5 minutes

### 1. Préparer le backend (2 min)

```bash
cd hackaton

# Exécuter les migrations
php artisan migrate

# Démarrer le serveur
php artisan serve
```

### 2. Créer des données de test (2 min)

```bash
php artisan tinker
```

Puis dans Tinker:

```php
// 1. Créer un portefeuille pour l'utilisateur ID 1
$wallet = \App\Models\Portefeuille::create([
    'user_id' => 1,
    'solde_points' => 1500
]);

// 2. Mettre à jour un chauffeur pour qu'il soit disponible
$chauffeur = \App\Models\Chauffeur::where('id_user', 1)->first();
if ($chauffeur) {
    $chauffeur->update([
        'est_en_ligne' => true,
        'statut_validation' => 'Valide',
        'latitude' => 4.0511,
        'longitude' => 9.7679,
        'note_moyenne' => 4.5
    ]);
}

// 3. Créer un véhicule (optionnel)
$vehicle = \App\Models\Vehicule::create([
    'id_chauffeur' => 1,
    'marque' => 'Toyota',
    'modele' => 'Corolla',
    'immatriculation' => 'ABC-123-XY',
    'couleur' => 'Blanc',
    'annee' => 2020,
    'type' => 'sedan'
]);

exit
```

### 3. Lancer l'app Flutter (1 min)

```bash
# Dans le dossier racine du projet Flutter
flutter run
```

## ✅ Vérification

### Dans l'app Flutter:

1. **Se connecter** avec un utilisateur existant
2. **Ouvrir le drawer** (menu hamburger en haut à gauche)
3. **Vérifier l'affichage:**
   - ✅ Nom et prénom de l'utilisateur
   - ✅ Email
   - ✅ Badge avec solde du portefeuille (ex: "1500 points")
   - ✅ Menu "Mon Portefeuille" avec le solde

4. **Sur la carte:**
   - ✅ Marqueur bleu = votre position
   - ✅ Marqueurs orange = chauffeurs disponibles
   - ✅ Cliquer sur un marqueur pour voir les infos

5. **Rechercher une destination:**
   - ✅ Taper dans la barre de recherche
   - ✅ Sélectionner un lieu
   - ✅ Voir l'itinéraire tracé en bleu
   - ✅ Voir les types de véhicules disponibles

## 🐛 Problèmes courants

### Aucun chauffeur n'apparaît
```bash
# Vérifier dans Tinker:
php artisan tinker
>>> \App\Models\Chauffeur::where('est_en_ligne', true)
    ->where('statut_validation', 'Valide')
    ->get();
```

Si vide, créer un chauffeur disponible (voir étape 2).

### Wallet ne s'affiche pas
```bash
# Vérifier dans Tinker:
php artisan tinker
>>> \App\Models\Portefeuille::where('user_id', 1)->first();
```

Si null, créer un portefeuille (voir étape 2).

### Erreur de connexion au backend
- Vérifier que le backend tourne sur `http://localhost:8000`
- Vérifier l'URL dans `lib/core/constants/api_constants.dart`
- Pour émulateur Android: utiliser `http://10.0.2.2:8000`
- Pour appareil physique: utiliser l'IP de votre machine

## 📱 Fonctionnalités disponibles

### ✅ Implémenté
- Connexion / Inscription
- Affichage des chauffeurs disponibles
- Recherche de destination
- Tracé d'itinéraire
- Sélection de véhicule
- Calcul de prix
- Affichage du wallet
- Informations utilisateur

### 🚧 À venir
- Réservation de course
- Paiement avec points
- Historique des courses
- Gestion des véhicules (chauffeurs)
- Notifications

## 📚 Documentation complète

- `BACKEND_INTEGRATION.md` - Intégration des chauffeurs
- `WALLET_VEHICLE_INTEGRATION.md` - Wallet et véhicules
- `COMPLETE_INTEGRATION_STATUS.md` - Status complet
- `QUICK_START.md` - Ce fichier

## 🆘 Besoin d'aide?

Vérifier les logs dans la console:
- `[ChauffeurDataSource]` - Chauffeurs
- `[WalletDataSource]` - Wallet
- `[RideBooking]` - Écran principal
- `[ApiClient]` - Requêtes HTTP

Tous les logs sont préfixés pour faciliter le debugging!
