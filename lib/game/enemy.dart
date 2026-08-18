import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'ai_brain.dart';
import 'game_entities.dart';

enum EnemyType { normal, fast, boss }

/// Düşman karakteri
class Enemy extends PositionComponent with HasGameRef, CollisionCallbacks, HarmfulComponent {
  final EnemyType type;
  final double speed;
  late AIBrain _brain;

  Vector2 _velocity = Vector2.zero();
  static const double _gravity = 980;
  bool _isOnGround = false;

  double _animTimer = 0;
  int _animFrame = 0;

  static const double enemyWidth = 44;
  static const double enemyHeight = 48;

  Enemy({
    required Vector2 position,
    this.type = EnemyType.normal,
    required this.speed,
  }) : super(
          position: position,
          size: Vector2(
            type == EnemyType.boss ? 80 : enemyWidth,
            type == EnemyType.boss ? 88 : enemyHeight,
          ),
          anchor: Anchor.bottomCenter,
        ) {
    _brain = AIBrain(enemy: this, moveSpeed: speed);
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  PositionComponent? _findPlayer() {
    try {
      return gameRef.children.whereType<PlayerComponent>().first as PositionComponent;
    } catch (_) {
      return null;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final player = _findPlayer();
    if (player != null) {
      final aiVelocity = _brain.computeVelocity(position, player.position, dt);
      _velocity.x = aiVelocity.x;
    }

    // Yerçekimi
    _velocity.y += _gravity * dt;
    if (_velocity.y > 700) _velocity.y = 700;

    position += _velocity * dt;
    _isOnGround = false;

    // Ekrandan çıkmasını engelle
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
      _brain.reverseDirection();
    }
    if (position.x > 3200 - size.x / 2) {
      position.x = 3200 - size.x / 2;
      _brain.reverseDirection();
    }

    // Animasyon
    _animTimer += dt;
    if (_animTimer >= 0.12) {
      _animTimer = 0;
      _animFrame = (_animFrame + 1) % 4;
    }
  }

  void landOnGround() {
    _isOnGround = true;
    _velocity.y = 0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawEnemy(canvas);
  }

  void _drawEnemy(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    Color bodyColor;
    Color eyeColor;
    switch (type) {
      case EnemyType.fast:
        bodyColor = const Color(0xFFFF5722);
        eyeColor = Colors.yellow;
        break;
      case EnemyType.boss:
        bodyColor = const Color(0xFF7B1FA2);
        eyeColor = const Color(0xFFFF1744);
        break;
      default:
        bodyColor = const Color(0xFFD32F2F);
        eyeColor = Colors.yellow;
    }

    // Gövde
    final bodyPaint = Paint()..color = bodyColor;
    canvas.drawRoundRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.1, h * 0.3, w * 0.8, h * 0.55),
        const Radius.circular(6),
      ),
      bodyPaint,
    );

    // Kafa
    final headPaint = Paint()..color = bodyColor.withOpacity(0.9);
    canvas.drawOval(Rect.fromLTWH(w * 0.15, h * 0.02, w * 0.7, h * 0.38), headPaint);

    // Gözler
    final eyePaint = Paint()..color = eyeColor;
    canvas.drawCircle(Offset(w * 0.33, h * 0.18), w * 0.1, eyePaint);
    canvas.drawCircle(Offset(w * 0.67, h * 0.18), w * 0.1, eyePaint);

    // Öfkeli kaşlar
    final browsePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.22, h * 0.10),
      Offset(w * 0.42, h * 0.14),
      browsePaint,
    );
    canvas.drawLine(
      Offset(w * 0.58, h * 0.14),
      Offset(w * 0.78, h * 0.10),
      browsePaint,
    );

    // Bacaklar - yürüyüş animasyonu
    final legPaint = Paint()..color = bodyColor.withOpacity(0.85);
    final legOffset = _animFrame % 2 == 0 ? 3.0 : -3.0;
    canvas.drawRoundRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.82, w * 0.22, h * 0.16 + legOffset),
        const Radius.circular(4),
      ),
      legPaint,
    );
    canvas.drawRoundRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.58, h * 0.82, w * 0.22, h * 0.16 - legOffset),
        const Radius.circular(4),
      ),
      legPaint,
    );

    // Boss için daha büyük dikenler
    if (type == EnemyType.boss) {
      final spikePaint = Paint()..color = const Color(0xFFFFD600);
      for (int i = 0; i < 5; i++) {
        final dx = w * 0.15 + i * w * 0.18;
        canvas.drawPath(
          Path()
            ..moveTo(dx, h * 0.02)
            ..lineTo(dx + 7, h * -0.08)
            ..lineTo(dx + 14, h * 0.02),
          spikePaint,
        );
      }
    }
  }
}
