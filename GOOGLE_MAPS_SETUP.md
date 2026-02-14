# Configuration Google Maps API

## Obtenir une clé API Google Maps

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créez un nouveau projet ou sélectionnez un projet existant
3. Activez les APIs suivantes :
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API (optionnel, pour l'autocomplétion d'adresses)
4. Allez dans "Identifiants" et créez une clé API
5. Copiez votre clé API

## Configuration Android

Ouvrez le fichier `android/app/src/main/AndroidManifest.xml` et remplacez `YOUR_GOOGLE_MAPS_API_KEY_HERE` par votre clé API :

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API_ICI" />
```

## Configuration iOS

Ouvrez le fichier `ios/Runner/AppDelegate.swift` et remplacez `YOUR_GOOGLE_MAPS_API_KEY_HERE` par votre clé API :

```swift
GMSServices.provideAPIKey("VOTRE_CLE_API_ICI")
```

## Vérification

Après avoir ajouté votre clé API :

1. Arrêtez l'application complètement
2. Relancez avec `flutter run`
3. Naviguez vers l'écran de réservation de course
4. La carte Google Maps devrait s'afficher correctement

## Erreurs courantes

- **"API key not found"** : Vérifiez que vous avez bien ajouté la clé dans les deux fichiers
- **"This API project is not authorized"** : Activez les APIs nécessaires dans Google Cloud Console
- **Carte grise avec "For development purposes only"** : Ajoutez des restrictions de facturation dans Google Cloud Console
