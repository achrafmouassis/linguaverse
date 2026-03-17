class AppConstants {
  static const String claudeApiUrl    = 'https://api.anthropic.com/v1/messages';
  static const String claudeModel     = 'claude-3-haiku-20240307';
  static const int    claudeMaxTokens = 1000;
  static const int    aiQuotaPerDay   = 5;

  static const double srsDefaultEF    = 2.5;
  static const double srsMinEF        = 1.3;
  static const int    srsInitInterval = 1;

  static const int    quizPassScore   = 70;
  static const int    quizTimerSecs   = 30;
  static const int    quizMaxWords    = 15;

  static const double arConfidence    = 0.65;
  static const int    arFrameMs       = 500;
  static const int    arMaxObjects    = 5;

  static const double ttsDefaultRate  = 0.85;
  static const double ttsDefaultPitch = 1.0;
  static const Map<String, String> ttsLanguages = {
    'Anglais':   'en-US',
    'Français':  'fr-FR',
    'Espagnol':  'es-ES',
    'Arabe':     'ar-SA',
    'Allemand':  'de-DE',
    'Japonais':  'ja-JP',
    'Portugais': 'pt-BR',
  };
}

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 20.0;
  static const double xxl = 24.0;
  static const double giant = 32.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
  static const double full = 999.0;
}
