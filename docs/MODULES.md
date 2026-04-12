# Les Modules (Features) - LinguaVerse v1.1.0

L'application LinguaVerse est structurée autour de plusieurs modules indépendants (les "M").

## M7 : Gamification & Progression (Cœur du Système)
Ce module agit tel un noyau central. TOUS les autres modules communiquent avec le M7 pour enregistrer les scores, badges et statistiques.

**Responsabilités :**
- **XP & Niveaux** : `ProgressionService` calcule les paliers de niveau (ex: Level 2 = 100 XP).
- **Streaks** : `StreakService` gère la fidélité journalière (exigences strictes : incrémentation si `diff == 1`).
- **Badges** : `BadgeService` récompense le joueur avec `ar_explorer`, `duel_champion` en lisant les stats globales.
- **Milestones** : Les jalons de progression (par ex: 10 leçons, 2 jours).
- **Mini-Jeux** : 4 jeux pour gagner de l'XP direct (Wordle, Emoji, Hangman, Synonymes).

## M4 : Scanner AR (Réalité Augmentée)
Ce module permet aux apprenants de pointer la caméra vers un objet réel ou un texte, puis obtenir une traduction à la volée.
- S'appuie sur le package de reconnaissance d'images `Google ML Kit`.
- Demande obligatoirement la permission `CAMERA` sous Android et iOS.
- Inclut un mock Claude API (`ArTranslationService`) pour simuler le LLM sans clé API lors du développement local.
- Déclenche un gain de 45 XP via `addXPProvider` lors du succès d'un scan.

## M6 : Arena (Duel Multijoueur)
Mode permettant un affrontement dynamique en temps réel sur du vocabulaire.
- S'articule autour du `DuelService` et `DuelArenaNotifier`.
- Mode actuellement jouable en Mock contre des "bots" intégrés.
- Offre une variété de modes ("QCM", "Emoji Battle", "Speed").
- Synchronisé nativement avec M7, garantit un gain XP via l'intégration dynamique du callback `addXPProvider` lors de la méthode `finalizeSession()`.

## Autres Modules (Projets futurs)
- M1 : Authentification & Firebase (Firebase Auth, Firestore DB)
- M2 : Leçons Structurées
- M3 : Quiz Avancés
- M5 : Prononciation & LLM Vocal
Ces modules sont représentés par des "Placeholder Pages" dans `router.dart` générant une bannière "Bientôt Disponible".
