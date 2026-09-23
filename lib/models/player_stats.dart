import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// Oyuncu istatistiklerini yöneten sınıf
class PlayerStats extends ChangeNotifier {
  final StorageService _storage;

  int _highScore = 0;
  int _totalPlayTimeSeconds = 0;
  int _totalTreasuresCollected = 0;
  int _totalGamesPlayed = 0;
  int _highestLevelReached = 1;
  List<String> _unlockedAchievements = [];

  PlayerStats(this._storage) {
    _loadStats();
  }

  int get highScore => _highScore;
  int get totalPlayTimeSeconds => _totalPlayTimeSeconds;
  int get totalTreasuresCollected => _totalTreasuresCollected;
  int get totalGamesPlayed => _totalGamesPlayed;
  int get highestLevelReached => _highestLevelReached;
  List<String> get unlockedAchievements => List.unmodifiable(_unlockedAchievements);

  String get formattedPlayTime {
    final hours = _totalPlayTimeSeconds ~/ 3600;
    final minutes = (_totalPlayTimeSeconds % 3600) ~/ 60;
    final seconds = _totalPlayTimeSeconds % 60;
    if (hours > 0) return '${hours}s ${minutes}d ${seconds}sn';
    if (minutes > 0) return '${minutes}d ${seconds}sn';
    return '${seconds}sn';
  }

  /// Depodan istatistikleri yükle
  void _loadStats() {
    _highScore = _storage.getInt('high_score') ?? 0;
    _totalPlayTimeSeconds = _storage.getInt('total_play_time') ?? 0;
    _totalTreasuresCollected = _storage.getInt('total_treasures') ?? 0;
    _totalGamesPlayed = _storage.getInt('total_games') ?? 0;
    _highestLevelReached = _storage.getInt('highest_level') ?? 1;
    _unlockedAchievements = _storage.getStringList('achievements') ?? [];
    notifyListeners();
  }

  /// Oyun bittikten sonra istatistikleri güncelle
  Future<void> updateAfterGame({
    required int score,
    required int durationSeconds,
    required int treasures,
    required int levelReached,
  }) async {
    _totalGamesPlayed++;
    _totalPlayTimeSeconds += durationSeconds;
    _totalTreasuresCollected += treasures;

    if (score > _highScore) {
      _highScore = score;
      await _storage.setInt('high_score', _highScore);
    }

    if (levelReached > _highestLevelReached) {
      _highestLevelReached = levelReached;
      await _storage.setInt('highest_level', _highestLevelReached);
    }

    await _storage.setInt('total_games', _totalGamesPlayed);
    await _storage.setInt('total_play_time', _totalPlayTimeSeconds);
    await _storage.setInt('total_treasures', _totalTreasuresCollected);

    // Başarı kontrolü
    await _checkAchievements(score, treasures, levelReached);

    notifyListeners();
  }

  /// Başarıları kontrol et ve kaydet
  Future<void> _checkAchievements(int score, int treasures, int level) async {
    bool changed = false;

    if (score >= 1000 && !_unlockedAchievements.contains('score_1000')) {
      _unlockedAchievements.add('score_1000');
      changed = true;
    }
    if (score >= 5000 && !_unlockedAchievements.contains('score_5000')) {
      _unlockedAchievements.add('score_5000');
      changed = true;
    }
    if (_totalTreasuresCollected >= 10 && !_unlockedAchievements.contains('treasure_10')) {
      _unlockedAchievements.add('treasure_10');
      changed = true;
    }
    if (_totalTreasuresCollected >= 50 && !_unlockedAchievements.contains('treasure_50')) {
      _unlockedAchievements.add('treasure_50');
      changed = true;
    }
    if (level >= 3 && !_unlockedAchievements.contains('level_3')) {
      _unlockedAchievements.add('level_3');
      changed = true;
    }
    if (level >= 5 && !_unlockedAchievements.contains('level_5')) {
      _unlockedAchievements.add('level_5');
      changed = true;
    }
    if (_totalGamesPlayed >= 5 && !_unlockedAchievements.contains('games_5')) {
      _unlockedAchievements.add('games_5');
      changed = true;
    }

    if (changed) {
      await _storage.setStringList('achievements', _unlockedAchievements);
    }
  }

  /// Tüm istatistikleri sıfırla
  Future<void> resetStats() async {
    _highScore = 0;
    _totalPlayTimeSeconds = 0;
    _totalTreasuresCollected = 0;
    _totalGamesPlayed = 0;
    _highestLevelReached = 1;
    _unlockedAchievements = [];
    await _storage.clearAll();
    notifyListeners();
  }
}
