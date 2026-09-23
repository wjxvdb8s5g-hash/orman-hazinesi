import 'package:audioplayers/audioplayers.dart';
import '../services/storage_service.dart';

/// Ses yönetim servisi
class AudioService {
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;
  bool _isInitialized = false;

  bool get isMuted => _isMuted;

  Future<void> init() async {
    _isInitialized = true;
    await _bgmPlayer.setVolume(0.5);
    await _sfxPlayer.setVolume(0.8);
  }

  /// Depodan mute durumunu yükle
  void loadMuteState(StorageService storage) {
    _isMuted = storage.getBool('is_muted') ?? false;
    _applyMuteState();
  }

  void _applyMuteState() {
    _bgmPlayer.setVolume(_isMuted ? 0 : 0.5);
    _sfxPlayer.setVolume(_isMuted ? 0 : 0.8);
  }

  Future<void> toggleMute(StorageService storage) async {
    _isMuted = !_isMuted;
    _applyMuteState();
    await storage.setBool('is_muted', _isMuted);
  }

  /// Arka plan müziği çal (asset bulunamazsa sessizce geç)
  Future<void> playBGM(String assetPath) async {
    if (!_isInitialized) return;
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Asset bulunamazsa sessizce geç
    }
  }

  Future<void> stopBGM() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  /// Ses efekti çal
  Future<void> playSFX(String assetPath) async {
    if (!_isInitialized || _isMuted) return;
    try {
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
