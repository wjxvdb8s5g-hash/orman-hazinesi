import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'player.dart';
import 'enemy.dart';
import 'collectible.dart';
import 'platform.dart' as game_platform;
import 'level_manager.dart';
import '../models/game_state.dart';
import '../models/level.dart';

/// Ana oyun motoru - Flame FlameGame
class GameController extends FlameGame
    with HasCollisionDetection {
  final GameState gameState;
  final Level levelConfig;
  final VoidCallback onGameOver;
  final VoidCallback onLevelComplete;
  final VoidCallback onTreasureCollected;

  late PlayerCharacter player;
  late LevelManager levelManager;

  // Platform ve Düşman listeleri
  final List<game_platform.GamePlatform> platforms = [];
  final List<Enemy> enemies = [];
  final List<Collectible> collectibles = [];

  // Kamera offset
  double _cameraX = 0;
  static const double _worldWidth = 3200;
  static const double _worldHeight = 600;

  GameController({
    required this.gameState,
    required this.levelConfig,
    required this.onGameOver,
    required this.onLevelComplete,
    required this.onTreasureCollected,
  });

  @override
  Color backgroundColor() => levelConfig.skyColor;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    levelManager = LevelManager(this);
    await levelManager.loadLevel(levelConfig);
    _spawnPlayer();
  }

  void _spawnPlayer() {
    player = PlayerCharacter(
      position: Vector2(100, size.y - 180),
      onDeath: _onPlayerDied,
    );
    add(player);
  }

  void _onPlayerDied() {
    gameState.loseLife();
    if (gameState.isGameOver) {
      onGameOver();
    } else {
      // Oyuncuyu yeniden başlat
      player.respawn(Vector2(100, size.y - 180));
    }
  }

  @override
  void update(double dt) {
    if (gameState.isPaused) return;
    super.update(dt);
    _updateCamera();
    _checkLevelComplete();
  }

  void _updateCamera() {
    // Kamerayı oyuncunun x pozisyonuna göre kaydır
    final targetX = player.position.x - size.x * 0.35;
    _cameraX = targetX.clamp(0.0, _worldWidth - size.x);
    camera.viewfinder.position = Vector2(_cameraX, 0);
  }

  void _checkLevelComplete() {
    // Tüm collectible'lar toplandıysa veya portal'a ulaşıldıysa
    if (collectibles.isEmpty && !gameState.isLevelComplete) {
      gameState.completeLevel();
      onLevelComplete();
    }
  }

  /// Hazine toplandı callback'i
  void treasureCollected(int value) {
    gameState.collectTreasure(value);
    onTreasureCollected();
  }

  // Kontrol metodları
  void moveLeft() => player.moveLeft();
  void moveRight() => player.moveRight();
  void stopHorizontal() => player.stopHorizontal();
  void jump() => player.jump();
}
