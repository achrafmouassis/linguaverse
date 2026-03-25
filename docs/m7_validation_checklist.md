# Checklist de validation manuelle — Module M7
À tester sur device réel (ou émulateur) avec `flutter run`

## Comment accéder au Panel DEV
1. Lancer l'app en mode debug : `flutter run`
2. Sur la HomePage → bouton 🔬 (flottant en bas à droite)
3. Le Panel de test M7 s'ouvre

---

## BLOC 1 · XP et niveaux

[ ] Taper "Leçon terminée +50 XP" → le compteur XP monte de 50
[ ] Taper "Quiz parfait +100 XP" → le compteur XP monte de 100
[ ] Taper "+500 XP" puis aller sur Dashboard → la barre XP est correcte
[ ] Taper "+2000 XP" pour force une montée de niveau
      → un dialog ou animation de level up s'affiche
      → le niveau affiché passe de N à N+1
[ ] Vérifier que `levelTitle` change au bon niveau
      (Apprenti à niveau 3, Étudiant à 6, etc.)
[ ] La barre XP sur la HomePage reflète bien les changements

## BLOC 2 · Streak

[ ] Taper "Activité aujourd'hui" → streak_days reste stable (déjà compté)
[ ] Fermer l'app, revenir le lendemain (ou simuler avec la DB)
      → streak_days s'incrémente de 1
[ ] Taper "Streak cassé (simulation)" → streak_days revient à 1
[ ] L'icône feu 🔥 sur la HomePage affiche le bon chiffre
[ ] Taper "Forcer streak=14" → le compteur passe à 14
[ ] streak_best ne diminue jamais même après un streak cassé

## BLOC 3 · Badges

[ ] État initial → aller sur l'écran Badges → tout est verrouillé (gris)
[ ] Taper "Forcer streak=7 + check badges"
      → le badge 🔥 "Semaine de feu" apparaît en doré dans la galerie
      → un overlay d'attribution s'affiche (animation)
[ ] Refaire la même action → le badge ne se double pas
[ ] Taper "+500 XP" puis "Vérifier tous les badges"
      → si totalXP >= 1000, le badge ⭐ "1 000 XP" apparaît
[ ] Les badges "Commun" n'ont pas de ring animé
[ ] Les badges "Légendaire" ont un ring doré qui tourne
[ ] Tap sur un badge verrouillé → BottomSheet avec la progression
[ ] Tap sur un badge débloqué → BottomSheet avec la date d'obtention

## BLOC 4 · Leaderboard

[ ] Aller sur l'écran Classement → affiche les données sans crash
[ ] L'utilisateur courant (user_123) est mis en évidence en violet
[ ] Les 3 premiers ont un podium visuel (hauteurs différentes)
[ ] Filtrer par langue → les données changent (ou restent si pas de données)
[ ] Le widget leaderboard de la HomePage affiche bien les mêmes données

## BLOC 5 · Jalons

[ ] Aller sur l'écran Jalons → affiche les jalons actifs sans crash
[ ] Taper "Synchro jalons" → les barres de progression se mettent à jour
[ ] Forcer streak=7 puis synchro → le jalon "Streak 7 jours" passe à 100%
[ ] Animation de complétion d'un jalon s'affiche correctement
[ ] La section "Complétés" liste les jalons terminés

## BLOC 6 · Dashboard Progression

[ ] Le graphique barres (XP par jour) affiche bien 7 barres
[ ] Tap sur une barre → tooltip avec le montant XP du jour
[ ] Le graphique courbe (progression niveau) ne crashe pas si peu de données
[ ] L'anneau XP se remplit avec animation au chargement
[ ] Les 3 stats (streak / badges / mots) sont cohérentes avec la DB

## BLOC 7 · Navigation et transitions

[ ] Toutes les routes /gamification/* sont accessibles sans crash
[ ] La transition fade+slide est fluide (pas de saccade)
[ ] Bouton retour depuis chaque écran fonctionne
[ ] La HomePage recharge correctement après une action dans M7

## BLOC 8 · Dark Mode / Light Mode

[ ] Toggle Dark/Light (bouton DEV) sur chaque écran M7
[ ] Aucun texte blanc invisible en light mode
[ ] Aucun fond noir illisible en light mode
[ ] Les couleurs des badges restent lisibles dans les deux modes

## BLOC 9 · Performance

[ ] Scroll fluide sur la liste des badges (pas de jank)
[ ] Scroll fluide sur le leaderboard (pas de rebuild inutile)
[ ] Ouvrir et fermer l'app 3 fois → pas de crash au rechargement de la DB
[ ] Aucun "AnimationController was disposed" dans les logs

## BLOC 10 · Cas limites

[ ] Utilisateur sans aucune activité → Dashboard affiche un état vide propre
[ ] XP = 0, Streak = 0 → aucun crash, valeurs affichées à 0
[ ] Appuyer très vite sur les boutons XP → pas de doublons en DB
[ ] Couper internet (si Firebase connecté) → app continue de fonctionner en local

---

## Résultat attendu
Tous les blocs cochés → M7 validé, prêt pour le merge sur develop
