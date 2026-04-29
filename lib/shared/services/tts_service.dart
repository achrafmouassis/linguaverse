import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _init();
  }

  Future<void> _init() async {
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text, String languageId) async {
    final String locale = _mapLanguageIdToLocale(languageId);
    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
  }

  String _mapLanguageIdToLocale(String id) {
    switch (id.toLowerCase()) {
      case 'ar':
        return 'ar-SA';
      case 'fr':
        return 'fr-FR';
      case 'en':
        return 'en-US';
      case 'es':
        return 'es-ES';
      case 'it':
        return 'it-IT';
      case 'tr':
        return 'tr-TR';
      case 'de':
        return 'de-DE';
      default:
        return 'en-US';
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
