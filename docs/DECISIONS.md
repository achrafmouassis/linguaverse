# Architectural Decision Records (ADR) - LinguaVerse v1.1.0

## ADR-001 : Approche Locale First (Offline Validation)
**Contexte:** L'application doit gérer des validations d'apprentissage et la progression sans backend.
**Décision:** Utiliser `sqflite` comme single source of truth pour la gamification. L'état d'XP, les Streaks, et les Badges sont totalement gérés localement et répliqués dans les instances Riverpod au chargement.
**Conséquences:** Les données des utilisateurs pourront être perdues s'ils vident le cache de l'app ou réinstallent, jusqu'à l'implémentation de synchronisation cloud (Firebase).

## ADR-002 : Centralisation de la Gamification
**Contexte:** Chaque feature indépendante (AR Scanner, Quiz, Duel) a son propre business flow pour distribuer de l'XP.
**Décision:** Obligation de passer par un point unique de callback : `addXPProvider`. Les services des modules externes injectent le Provider ou s'inversent via Riverpod, plutôt que de manipuler directement SQLite.
**Conséquences:** Résilience garantie sur la cohérence des Stats (Milestones évalués, Streak maintenu au bon moment). Code UI soulagé car `addXPProvider` "fire and forget".

## ADR-003 : Mock Data & Modes de Repli
**Contexte:** Tout développeur testant l'AR n'a peut-être pas toujours une clé API Claude valide, et pour le Duel il n'y a pas encore de WebSocket ni matchmaking Backend.
**Décision:** Le Mock Pattern a été généralisé dans M6 et M4. M6 simule du lag humain (bots calculant le temps). M4 détecte l'absence de secret et renvoie une réponse simulée après un timeout.
**Conséquences:** Les développeurs peuvent packager ou relire le code de toutes les fonctionnalités de l'App sans interférences bloquantes externes.
