import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'game_controller.dart';
import 'platform.dart' as gp;
import 'enemy.dart';
import 'collectible.dart';
import '../models/level.dart';

/// Level düzenini yükleyen yönetici
class LevelManager {
  final GameController game;
  final Random _rng = Random();

  LevelManager(this.game);

  Future<void> loadLevel(Level level) async {
    // Zemin platformu
    _addGround(level);
    // Üst platformlar
    _addPlatforms(level);
    // Düşmanlar
    _addEnemies(level);
    // Hazineler
    _addCollectibles(level);
    // Arka plan dekorasyon
    _addBackground(level);
  }

  void _addGround(Level level) {
    // Ana zemin
    for (int i = 0; i < 10; i++) {
      game.add(gp.GamePlatform(
        position: Vector2(i * 320.0, game.size.y - 50),
        size: Vector2(320, 50),
        color: level.groundColor,
      ));
    }
  }

  void _addPlatforms(Level level) {
    final platformData = _getPlatformData(level.number);
    for (final data in platformData) {
      final type = data['moving'] == true
          ? gp.PlatformType.moving
          : data['disappearing'] == true
              ? gp.PlatformType.disappearing
              : gp.PlatformType.static_;

      game.add(gp.GamePlatform(
        position: Vector2(data['x'] as double, data['y'] as double),
        size: Vector2(data['w'] as double, 24),
        type: type,
        moveSpeed: type == gp.PlatformType.moving ? level.platformSpeed : 0,
        color: type == gp.PlatformType.moving
            ? const Color(0xFF7B1FA2)
            : const Color(0xFF388E3C),
      ));
    }
  }

  List<Map<String, dynamic>> _getPlatformData(int levelNum) {
    final h = game.size.y;
    switch (levelNum) {
      case 1:
        return [
          {'x': 200.0, 'y': h - 170, 'w': 160.0},
          {'x': 450.0, 'y': h - 260, 'w': 140.0},
          {'x': 700.0, 'y': h - 200, 'w': 180.0},
          {'x': 950.0, 'y': h - 310, 'w': 120.0},
          {'x': 1150.0, 'y': h - 220, 'w': 160.0},
          {'x': 1400.0, 'y': h - 290, 'w': 140.0},
          {'x': 1650.0, 'y': h - 180, 'w': 200.0},
          {'x': 1900.0, 'y': h - 270, 'w': 130.0},
          {'x': 2100.0, 'y': h - 200, 'w': 150.0},
          {'x': 2400.0, 'y': h - 250, 'w': 160.0},
          {'x': 2700.0, 'y': h - 310, 'w': 120.0},
          {'x': 2950.0, 'y': h - 200, 'w': 180.0},
        ];
      case 2:
        return [
          {'x': 180.0, 'y': h - 190, 'w': 140.0, 'moving': true},
          {'x': 420.0, 'y': h - 280, 'w': 120.0},
          {'x': 680.0, 'y': h - 220, 'w': 160.0, 'moving': true},
          {'x': 930.0, 'y': h - 330, 'w': 110.0},
          {'x': 1180.0, 'y': h - 250, 'w': 150.0},
          {'x': 1420.0, 'y': h - 300, 'w': 130.0, 'moving': true},
          {'x': 1700.0, 'y': h - 200, 'w': 180.0},
          {'x': 1950.0, 'y': h - 290, 'w': 120.0},
          {'x': 2200.0, 'y': h - 220, 'w': 160.0, 'moving': true},
          {'x': 2450.0, 'y': h - 270, 'w': 140.0},
          {'x': 2700.0, 'y': h - 330, 'w': 110.0},
          {'x': 2950.0, 'y': h - 210, 'w': 170.0},
        ];
      case 3:
        return [
          {'x': 160.0, 'y': h - 200, 'w': 120.0},
          {'x': 380.0, 'y': h - 300, 'w': 100.0, 'moving': true},
          {'x': 600.0, 'y': h - 230, 'w': 130.0},
          {'x': 850.0, 'y': h - 350, 'w': 100.0},
          {'x': 1100.0, 'y': h - 270, 'w': 140.0, 'moving': true},
          {'x': 1360.0, 'y': h - 320, 'w': 110.0},
          {'x': 1580.0, 'y': h - 210, 'w': 150.0},
          {'x': 1830.0, 'y': h - 300, 'w': 120.0, 'moving': true},
          {'x': 2080.0, 'y': h - 240, 'w': 140.0},
          {'x': 2330.0, 'y': h - 350, 'w': 100.0},
          {'x': 2600.0, 'y': h - 280, 'w': 130.0, 'moving': true},
          {'x': 2850.0, 'y': h - 230, 'w': 160.0},
        ];
      case 4:
        return [
          {'x': 150.0, 'y': h - 210, 'w': 110.0, 'disappearing': true},
          {'x': 360.0, 'y': h - 310, 'w': 100.0, 'moving': true},
          {'x': 580.0, 'y': h - 240, 'w': 120.0},
          {'x': 820.0, 'y': h - 370, 'w': 90.0, 'disappearing': true},
          {'x': 1050.0, 'y': h - 290, 'w': 130.0, 'moving': true},
          {'x': 1300.0, 'y': h - 330, 'w': 100.0},
          {'x': 1550.0, 'y': h - 220, 'w': 140.0, 'disappearing': true},
          {'x': 1800.0, 'y': h - 310, 'w': 110.0, 'moving': true},
          {'x': 2050.0, 'y': h - 260, 'w': 130.0},
          {'x': 2300.0, 'y': h - 380, 'w': 90.0, 'disappearing': true},
          {'x': 2550.0, 'y': h - 300, 'w': 120.0, 'moving': true},
          {'x': 2800.0, 'y': h - 240, 'w': 150.0},
        ];
      case 5: // Boss level
        return [
          {'x': 200.0, 'y': h - 220, 'w': 130.0},
          {'x': 450.0, 'y': h - 330, 'w': 110.0, 'moving': true},
          {'x': 700.0, 'y': h - 250, 'w': 140.0, 'disappearing': true},
          {'x': 950.0, 'y': h - 390, 'w': 100.0},
          {'x': 1200.0, 'y': h - 310, 'w': 120.0, 'moving': true},
          {'x': 1500.0, 'y': h - 230, 'w': 160.0},
          {'x': 1800.0, 'y': h - 370, 'w': 100.0, 'disappearing': true},
          {'x': 2100.0, 'y': h - 290, 'w': 130.0, 'moving': true},
          {'x': 2400.0, 'y': h - 200, 'w': 170.0},
          {'x': 2700.0, 'y': h - 350, 'w': 110.0},
          {'x': 2900.0, 'y': h - 240, 'w': 200.0}, // Boss arena
        ];
      default:
        return [];
    }
  }

  void _addEnemies(Level level) {
    final spawnXs = _getEnemySpawnXs(level.number);

    for (int i = 0; i < level.enemyCount && i < spawnXs.length; i++) {
      EnemyType type = EnemyType.normal;
      if (level.hasBoss && i == 0) {
        type = EnemyType.boss;
      } else if (i % 3 == 2) {
        type = EnemyType.fast;
      }

      final enemy = Enemy(
        position: Vector2(spawnXs[i], game.size.y - 100),
        type: type,
        speed: level.enemySpeed * (type == EnemyType.fast ? 1.4 : 1.0),
      );
      game.enemies.add(enemy);
      game.add(enemy);
    }
  }

  List<double> _getEnemySpawnXs(int levelNum) {
    final step = 3200.0 / 8;
    return List.generate(8, (i) => 400.0 + i * step);
  }

  void _addCollectibles(Level level) {
    final positions = _getCollectiblePositions(level.number);
    final h = game.size.y;

    for (int i = 0; i < level.treasureCount && i < positions.length; i++) {
      CollectibleType type;
      if (i % 5 == 4) {
        type = CollectibleType.star;
      } else if (i % 3 == 2) {
        type = CollectibleType.gem;
      } else {
        type = CollectibleType.coin;
      }

      final c = Collectible(
        position: Vector2(positions[i][0], h - positions[i][1]),
        type: type,
        onCollected: (val, self) {
          game.collectibles.remove(self);
          game.treasureCollected(val);
        },
      );
      game.collectibles.add(c);
      game.add(c);
    }
  }

  List<List<double>> _getCollectiblePositions(int levelNum) {
    return [
      [250, 220], [480, 300], [720, 240], [980, 360],
      [1200, 270], [1450, 320], [1700, 210], [1960, 300],
      [2150, 250], [2420, 290],
    ];
  }

  void _addBackground(Level level) {
    // Ağaçlar ve çiçekler (dekoratif component)
    game.add(_ForestBackground(levelConfig: level));
  }
}

/// Orman arka plan dekorasyonu
class _ForestBackground extends Component with HasGameRef {
  final Level levelConfig;
  _ForestBackground({required this.levelConfig});

  @override
  void render(Canvas canvas) {
    _drawForest(canvas);
  }

  void _drawForest(Canvas canvas) {
    final random = Random(42);
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * 3200;
      final y = gameRef.size.y - 50;
      _drawTree(canvas, x, y, random);
    }
  }

  void _drawTree(Canvas canvas, double x, double y, Random rng) {
    final h = 60.0 + rng.nextDouble() * 60;
    // Gövde
    final trunkPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(Rect.fromLTWH(x - 6, y - h, 12, h), trunkPaint);
    // Yapraklar
    final leavesPaint = Paint()..color = const Color(0xFF388E3C).withOpacity(0.85);
    canvas.drawCircle(Offset(x, y - h - 20), 28 + rng.nextDouble() * 16, leavesPaint);
  }
}
