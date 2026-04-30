import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service de lecture audio pour les fichiers audio locaux.
/// Distinct du TTS (FlutterTts) qui génère la voix à la volée.
/// Gère la lecture des fichiers dans assets/audio/
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _player.setReleaseMode(ReleaseMode.stop);
    _isInitialized = true;
  }

  /// Joue un fichier audio depuis les assets.
  /// [assetPath] chemin relatif depuis assets/ (ex: 'audio/arabic/salam.mp3')
  Future<void> playAsset(String assetPath) async {
    await initialize();
    try {
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Fichier audio non trouvé → fallback silencieux
    }
  }

  /// Sons de feedback
  Future<void> playCorrect() async => playAsset('audio/fx/correct.mp3');
  Future<void> playWrong() async => playAsset('audio/fx/wrong.mp3');
  Future<void> playLevelUp() async => playAsset('audio/fx/levelup.mp3');

  Future<void> stop() async => _player.stop();

  void dispose() => _player.dispose();
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
