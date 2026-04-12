# Guide Développeur - LinguaVerse v1.1.0

Ce fichier vous aide à configurer l'environnement de travail pour développer, auditer et améliorer LinguaVerse.

## 1. Pré-Requis
- **Flutter SDK** : v3.19+ préconisé
- **Dart SDK** : v3.3+ préconisé
- **Plateforme ciblée** : iOS et Android (Permissions Caméra configurées pour les 2 environnements).
- Clé d'API Claude : Si vous testez la vraie stack IA du M4, déclarez `CLAUDE_API_KEY` dans un fichier `.env`.

## 2. Démarrage de l'Environnement

```bash
# Vérifier l'installation
flutter doctor

# Récupérer les dépendances
flutter pub get

# Lancer la génération de code (le cas échéant pour Riverpod/Freezed)
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run
```

## 3. Ajout de Données ou de Badges
Les tables SQLite, les badges, et les adversaires du "Duel" sont seedés automatiquement via la classe `DatabaseHelper`.
- Pour ajouter un badge: Insérez un élément dans la variable temporaire de test au fichier `lib/core/services/database_helper.dart` (methode `_seedBadges()` ou `_seedDuelBadges()`).
- Si les tables ont changé de structure, incrémentez `_dbVersion` dans `DatabaseHelper` et peuplez la méthode `_onUpgrade`.

## 4. Interaction avec M7 (Gamification)
Chaque nouveau module doit toujours récompenser le joueur après sa conclusion.
Exemple pour déclencher la gamification :
```dart
final xpResult = await ref.read(addXPProvider)(
    sourceType: 'mon_module',
    sourceName: 'Description pour l\'historique',
    overrideAmount: 50,
);
```
Faire appel à ce provider gère automatiquement le rafraîchissement UI, l'évaluation du Streak de connexion, et l'actualisation des jalons de réussite.

## 5. Exécution des Tests
Le projet suit une logique de Test Driven Architecture pour les cas métiers fondamentaux. Pour valider que rien ne se casse dans M7 :
```bash
flutter test test/features/gamification/
```
Un total de 62+ tests assure l'intégrité algorithmique des streaks, records, badges et jalons.
