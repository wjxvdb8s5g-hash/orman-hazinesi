import 'package:flutter/foundation.dart';

/// Oyunun genel durumunu yöneten sınıf
class GameState extends ChangeNotifier {
  int _currentLevel = 1;
  int _score = 0;
  int _lives = 3;
  int _totalTreasures = 0;
  bool _isPaused = false;
  bool _isGameOver = false;
  bool _isLevelComplete = false;
  DateTime? _sessionStart;

  int get currentLevel => _currentLevel;
  int get score => _score;
  int get lives => _lives;
  int get totalTreasures => _totalTreasures;
  bool get isPaused => _isPaused;
  bool get isGameOver => _isGameOver;
  bool get isLevelComplete => _isLevelComplete;

  /// Yeni oyun başlat
  void startGame() {
    _currentLevel = 1;
    _score = 0;
    _lives = 3;
    _totalTreasures = 0;
    _isPaused = false;
    _isGameOver = false;
    _isLevelComplete = false;
    _sessionStart = DateTime.now();
    notifyListeners();
  }

  /// Hazine toplandığında
  void collectTreasure(int value) {
    _score += value;
    _totalTreasures++;
    notifyListeners();
  }

  /// Can kayb et
  void loseLife() {
    _lives--;
    if (_lives <= 0) {
      _isGameOver = true;
    }
    notifyListeners();
  }

  /// Level tamamlandı
  void completeLevel() {
    _isLevelComplete = true;
    // Level bonusu
    _score += 500 * _currentLevel;
    notifyListeners();
  }

  /// Sonraki levele geç
  void nextLevel() {
    _currentLevel++;
    _isLevelComplete = false;
    notifyListeners();
  }

  /// Oyunu duraklat/devam et
  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  /// Oturum süresini saniye cinsinden döndür
  int get sessionDurationSeconds {
    if (_sessionStart == null) return 0;
    return DateTime.now().difference(_sessionStart!).inSeconds;
  }

  /// Oyunu sıfırla
  void reset() {
    startGame();
  }
}
