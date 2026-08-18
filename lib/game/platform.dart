import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

/// Platform tipi
enum PlatformType { static_, moving, disappearing }

/// Platform bileşeni
class GamePlatform extends PositionComponent with HasGameRef, CollisionCallbacks {
  final PlatformType type;
  final double moveSpeed;
  final Color color;

  double _moveDir = 1;
  final double _startX;
  static const double _moveDistance = 120;

  double _disappearTimer = 0;
  bool _isVisible = true;

  GamePlatform({
    required Vector2 position,
    required Vector2 size,
    this.type = PlatformType.static_,
    this.moveSpeed = 0,
    this.color = const Color(0xFF5D4037),
  })  : _startX = position.x,
        super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (type == PlatformType.moving && moveSpeed > 0) {
      position.x += _moveDir * moveSpeed * dt;
      if ((position.x - _startX).abs() >= _moveDistance) {
        _moveDir *= -1;
      }
    }

    if (type == PlatformType.disappearing) {
      _disappearTimer += dt;
      if (_disappearTimer > 3.0) {
        _isVisible = !_isVisible;
        _disappearTimer = 0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isVisible) return;
    super.render(canvas);
    _drawPlatform(canvas);
  }

  void _drawPlatform(Canvas canvas) {
    // Platform gövdesi
    final paint = Paint()..color = color;
    canvas.drawRoundRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(6),
      ),
      paint,
    );

    // Üst dekorasyon (çimen)
    if (color == const Color(0xFF5D4037) || color == const Color(0xFF388E3C)) {
      final grassPaint = Paint()..color = const Color(0xFF66BB6A);
      canvas.drawRoundRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.x, 8),
          const Radius.circular(4),
        ),
        grassPaint,
      );
    }

    // Hareket eden platform için ışıltı efekti
    if (type == PlatformType.moving) {
      final glowPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRoundRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 1, size.x - 2, size.y - 2),
          const Radius.circular(5),
        ),
        glowPaint,
      );
    }
  }
}
