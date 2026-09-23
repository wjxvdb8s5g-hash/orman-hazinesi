import '../models/player_stats.dart';

/// İstatistik yardımcı servisi
class StatsService {
  /// Top 5 skoru hesapla (basit versiyon - lokal tek kayıt)
  static List<Map<String, dynamic>> getLeaderboard(PlayerStats stats) {
    // Lokal depolamada tek kayıt var; birden fazla giriş gelecekte eklenebilir
    if (stats.highScore == 0) return [];
    return [
      {
        'rank': 1,
        'name': 'Sen',
        'score': stats.highScore,
        'level': stats.highestLevelReached,
      }
    ];
  }
}
