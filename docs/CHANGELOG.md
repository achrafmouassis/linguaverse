# Changelog - LinguaVerse

## [v1.1.0] - 2024-04
Cette version finalise les modules de Réalité Augmentée (M4), de Duel d'Arène (M6) et de centralisation de Gamification (M7).

### Ajouté
- **Module M7 (Gamification) complet** : Gestion du Streak, intégration du gain d'XP, badges (Première Victoire, Curieux, Exploreur, Connecté, etc.), et jalons avec synchronisation bidirectionnelle.
- **Service M4 (AR Scanner)** : Nouveau workflow local + Google ML Kit pour la reconnaissance d'objet en temps réel. Text Scanner branché à un service Traduction (Mock ou Claude).
- **Service M6 (Arena Duel)** : Un flow de duel complet gérant un mock de matchmaking, un QCM duel vs un bot, et des requêtes multi-modales (vitesse, emojis).
- **Service Central d'XP** : L'implémentation de `addXPProvider` standardisant la réception d'expérience entre toutes les activités (duels, tests, mini-jeux).

### Corrigé
- **Crash AR M4** : Suppression d'une "Race condition" critique lors de l'arrêt de la détection de frame vidéo pour prendre une photo avec la caméra.
- **Failures Silencieuses M4** : Amélioration du `ar_translation_service.dart` pour ne plus crasher ou rester vide sans clé API (fallback de secours "Mock" disponible et actif s'il manque le `.env`).
- **Logique d'XP Manquante** : L'XP gagnée n'entraînait pas d'activités pour poursuivre un "streak", le `addXPProvider` déclenche désormais automatiquement une mise à jour globale.
- **Couleurs Hardcodées** : Harmonisation UI via la structuration globale dans `AppColors` pour tous les niveaux.
- **Base de Données M6** : Fix de la table et des migrations pour supporter correctement les stats des Duels (Wins, Matches, Perfects).

### Techniques
- Nettoyage automatique des syntaxes Dart (`dart fix --apply`).
- Réécriture et sécurisation avec types stricts sur `ProgressionService` grâce aux `Transactions` de SQLite de `sqflite` (gestion des cas de nullité dans la progression).
