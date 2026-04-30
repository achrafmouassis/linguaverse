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

### 2. Fusionner les fonctionnalités (Si nécessaire)
Si vous devez intégrer le travail d'une branche spécifique (ex: AI Quiz) :
```bash
git checkout develop
git merge feature/ai-quiz
```

### 3. Installer les dépendances
```bash
flutter pub get
# Pour iOS uniquement :
# cd ios && pod install && cd ..
```

### 4. Configurer Firebase

Le projet nécessite les fichiers de configuration Firebase (exclus via `.gitignore`) :

**Pour Android :**
Placer `google-services.json` dans `android/app/`.

**Pour iOS :**
Placer `GoogleService-Info.plist` dans `ios/Runner/`.

### 5. Configurer les clés API
```bash
cp .env.example .env
# Éditer .env et remplir CLAUDE_API_KEY et FIREBASE_PROJECT_ID
```

### 6. Lancer l'application
```bash
flutter run
```

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
│   ├── auth/ (Stubs)
│   ├── lessons/
│   ├── quiz/
│   ├── gamification/ (Central)
│   ├── ai_quiz/ (v1.2.0)
│   ├── ar/
│   ├── duel/
│   └── home/
└── shared/
    ├── widgets/
    ├── theme/
    └── utils/
```

**Pattern :** MVVM + Clean Architecture + Riverpod

---

## 🌿 Branches Git

```
main
  └── develop (Dernière version stable v1.2.0)
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

## 📦 Stack technique (v1.2.0)

| Catégorie | Technologie | Version |
|---|---|---|
| Framework | Flutter / Dart | 3.4+ |
| State | flutter_riverpod | 2.5.1 |
| Navigation | go_router | 14.2.0 |
| DB locale | sqflite | 2.3.3 |
| Auth | Firebase Auth (Stubbed) | — |
| TTS | flutter_tts | 4.2.0 |
| STT | speech_to_text | 7.0.0 |
| AR | ar_flutter_plugin | 0.7.3 |
| ML | google_mlkit (Object, Text) | 0.12+ |
| IA | Claude API (via Dio) | — |

---

*LinguaVerse — ENSIAS Taroudant · Pr. Latifa RASSAM · 2025–2026*
*Version : 1.2.0-STABLE*
