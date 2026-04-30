# LinguaVerse 🌍

> Application mobile d'apprentissage des langues — Flutter/Dart  
> ENSIAS Taroudant · Module Développement Mobile & Metaverse · 2025–2026

## 👥 Équipe

| Membre | Rôle | Modules | Branches |
|---|---|---|---|
| Hiba EL OUAFI | Auth Lead · IA | M1 Auth · M8 IA Quiz | feature/auth-onboarding · feature/ai-quiz |
| Zineb BOUGHEDDA | SRS · Gamification | M2 Leçons · M7 Gamification | feature/lessons-srs · feature/gamification |
| Abdelmoughit MOURADI | Quiz · Firebase | M5 Quiz · M6 Duel | feature/quiz-five-types · feature/duel-realtime |
| Achraf MOUASIS | Audio · ML | M3 TTS · M4 STT | feature/audio-tts-service · feature/pronunciation |

**Encadrant :** Pr. Latifa RASSAM

---

## 🚀 Démarrage rapide (5 minutes)

### 1. Cloner le projet
```bash
git clone https://github.com/EQUIPE/linguaverse.git
cd linguaverse
```

### 2. Installer les dépendances
```bash
flutter pub get
cd ios && pod install && cd ..
```

### 3. Configurer Firebase

Pour que les services Firebase fonctionnent correctement (Auth, base de données), chaque développeur doit configurer les clés sur son environnement local :

**Pour Android :**
1. Télécharger ou récupérer le fichier `google-services.json` du projet.
2. Le placer directement dans le dossier `android/app/` :
```bash
cp chemin/vers/google-services.json android/app/
```

**Pour iOS :**
1. Télécharger ou récupérer le fichier `GoogleService-Info.plist`.
2. Le placer dans le dossier `ios/Runner/` :
```bash
cp chemin/vers/GoogleService-Info.plist ios/Runner/
```

> **⚠️ ATTENTION :** Ces fichiers contiennent les clés privées du projet. Ils ne doivent **absolument jamais** être inclus dans les commits (ils sont déjà stipulés dans le `.gitignore`).

### 4. Configurer les clés API
```bash
cp .env.example .env
# Éditer .env et remplir GOOGLE_API_KEY (pour Gemini)
```

### 5. Lancer l'application
```bash
flutter run
flutter run -d 'iPhone 15 Pro'
flutter run -d chrome
```

---

## 🌟 Dernières Mises à Jour (Réalisées)

*   **Migration IA :** Passage de Claude 3 à **Google Gemini 1.5 Flash** pour la génération gratuite et rapide des quiz.
*   **Moteur de Jeu "AI Quiz" :** Création d'une interface de jeu interactive indépendante avec feedback immédiat, animations, et timer dynamique (30 secondes par question).
*   **Gamification & XP :** Calcul automatique de l'XP à la fin des quiz (+10 XP/bonne réponse, bonus parfait de +50 XP) avec synchronisation locale (SQLite) et distante (Firestore).
*   **Sécurité et Auth :** Intégration complète de la fonctionnalité **"Mot de passe oublié"** (envoi d'e-mails via Firebase) et ajout d'un **Bouton de Déconnexion** fluide sur l'écran d'accueil.
*   **Robustesse :** Gestion de l'erreur 503 (serveurs Gemini surchargés) avec message convivial, et renforcement extrême du parsing JSON via des prompts explicites d'échappement des guillemets.

---

## 🏗️ Architecture

```
lib/
├── main.dart
├── app.dart
├── router.dart
├── core/services/
│   ├── audio_service.dart
│   ├── database_helper.dart
│   ├── srs_service.dart
│   └── claude_api_service.dart
├── features/
│   ├── auth/
│   ├── lessons/
│   ├── quiz/
│   ├── gamification/
│   ├── ai_quiz/
│   └── ar/
└── shared/
    ├── widgets/
    ├── theme/
    └── utils/
```

**Pattern :** MVVM + Clean Architecture

---

## 🌿 Branches Git

```
main
  └── develop
        ├── feature/auth-onboarding
        ├── feature/ai-quiz
        ├── feature/lessons-srs
        ├── feature/gamification
        ├── feature/quiz-five-types
        ├── feature/duel-realtime
        ├── feature/audio-tts-service
        └── feature/pronunciation-challenge
```

---

## 📋 Commandes quotidiennes

```bash
flutter analyze
flutter test
dart format lib/
flutter pub get
```

---

## ⚠️ Règles importantes

1. Ne jamais committer `.env`, `google-services.json`, `GoogleService-Info.plist`
2. sqflite uniquement pour la DB locale
3. Travailler uniquement dans `lib/features/<ton_module>/`
4. Toujours rebase sur develop avant PR
5. Conventional commits obligatoires : `feat|fix|chore|test|docs(scope): message`

---

## 📦 Stack technique

| Catégorie | Technologie | Version |
|---|---|---|
| Framework | Flutter / Dart | 3.22+ |
| State | flutter_riverpod | 2.5+ |
| Navigation | go_router | 14+ |
| DB locale | sqflite | 2.3+ |
| Auth | firebase_auth | Latest |
| TTS | flutter_tts | 4.2+ |
| STT | speech_to_text | 7.0+ |
| AR | ar_flutter_plugin | 0.7.3+ |
| ML | google_mlkit_object_detection | 0.12+ |
| IA | Google Gemini API (gemini-1.5-flash) | — |
| Charts | fl_chart | 0.69+ |

---

*LinguaVerse — ENSIAS Taroudant · Pr. Latifa RASSAM · 2025–2026*
