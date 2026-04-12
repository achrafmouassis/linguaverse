# Architecture du Projet - LinguaVerse v1.1.0

## Modèle d'Architecture Globale
L'application LinguaVerse repose sur un modèle d'architecture multicouche rigoureux de type **MVVM (Model-View-ViewModel)** croisé avec du **Feature-First (Feature-Driven Architecture)**, structuré et orchestré via l'injection de dépendances (Riverpod).

### Vue d'ensemble des couches
1. **Presentation Layer (View / Widgets / Notifiers)**
   Gère l'interface utilisateur et le state binding avec Riverpod (`StateNotifier`, `FutureProvider`).
2. **Domain Layer (Services / Providers)**
   Héberge la logique métier applicative et l'orchestration des données (ex: `ProgressionService`, `DuelService`).
3. **Data Layer (Models / Repositories)**
   Comprend les modèles de données statiques (ex: `BadgeModel`) et les interactions avec les helpers (ex: `DatabaseHelper`).

## Architecture des Dossiers (`lib/`)

```
lib/
├── core/
│   ├── errors/            # Classes d'erreurs métier
│   ├── services/          # Services transverses (DatabaseHelper)
│   └── utils/             # Utilitaires globaux (extensions, parseurs)
├── shared/
│   ├── theme/             # Couleurs (AppColors), typographie, thèmes
│   └── widgets/           # Composants UI partagés partout
├── features/              # (FEATURE-FIRST)
│   ├── ar/                # (M4) Scanner AR
│   ├── duel/              # (M6) Mode multi-joueur (Mocké)
│   ├── gamification/      # (M7) Progression, Badges, Mini-jeux
│   └── home/              # Dashboard principal
├── router.dart            # Configuration globale GoRouter
└── main.dart              # Point d'entrée (ProviderScope)
```

## Décisions Technologiques Importantes

- **State Management & DI** : `riverpod` (séparation totale de la logique UI et des états ; providers isolés avec `autoDispose`).
- **Persistance Locale** : `sqflite` v3 (stockage du dictionnaire localisé, des données d'utilisateurs temporaires et de la progression M7/M6).
- **Navigation** : `go_router` (approche déclarative par URL, utile pour les deep links et le flow structurel futur).
- **Computer Vision** : `Google ML Kit` (pour le module M4 d'object detection et text recognition).

## Standards de l'état
Tout l'état modifiable interagit avec le `DatabaseHelper`. Pour optimiser les accès concurrents, le module de gamification met en cache via des providers qui s'invalident mutuellement. Par exemple, appeler `ref.read(addXPProvider)` exécute un flush BD puis invalide tous les `FutureProviders` de statistiques pour provoquer un rafraîchissement d'UI réactif.
