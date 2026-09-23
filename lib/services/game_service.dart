import '../models/player_stats.dart';
import '../models/game_state.dart';

/// Oyun servisi - oyun başlangıç/bitiş mantığı
class GameService {
  /// Oyun bittiğinde istatistikleri güncelle
  Future<void> finalizeGame(GameState gameState, PlayerStats stats) async {
    await stats.updateAfterGame(
      score: gameState.score,
      durationSeconds: gameState.sessionDurationSeconds,
      treasures: gameState.totalTreasures,
      levelReached: gameState.currentLevel,
    );
  }
}
