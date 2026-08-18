import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'game_controller.dart';

enum CollectibleType { coin, gem, star }

/// Toplanabilir nesne (hazine, altın, mücevher)
class Collectible extends PositionComponent
    with HasGameRef<GameController>, CollisionCallbacks {
  final CollectibleType type;
  final int value;

  bool _collected = false;
  double _floatTimer = 0;
  double _baseY = 0;

  static const double _size = 28;

  Collectible({
    required Vector2 position,
    this.type = CollectibleType.coin,
  })  : value = _valueFor(type),
        super(
          position: position,
          size: Vector2.all(_size),
          anchor: Anchor.center,
        ) {
    _baseY = position.y;
  }

  static int _valueFor(CollectibleType t) {
    switch (t) {
      case CollectibleType.gem:
        return 30;
      case CollectibleType.star:
        return 50;
      default:
        return 10;
    }
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox()..isSolid = false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_collected) return;

    // Sallanma animasyonu
    _floatTimer += dt * 2.5;
    position.y = _baseY + sin(_floatTimer) * 5;
  }

  void collect() {
    if (_collected) return;
    _collected = true;
    gameRef.treasureCollected(value);
    gameRef.collectibles.remove(this);
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    if (_collected) return;
    super.render(canvas);
    _drawCollectible(canvas);
  }

  void _drawCollectible(Canvas canvas) {
    switch (type) {
      case CollectibleType.coin:
        _drawCoin(canvas);
        break;
      case CollectibleType.gem:
        _drawGem(canvas);
        break;
      case CollectibleType.star:
        _drawStar(canvas);
        break;
    }
  }

  void _drawCoin(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFFFD700);
    canvas.drawCircle(Offset(_size / 2, _size / 2), _size / 2, paint);
    final innerPaint = Paint()..color = const Color(0xFFFFF176);
    canvas.drawCircle(Offset(_size / 2, _size / 2), _size / 3, innerPaint);
    // ₺ sembolü
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '₺',
        style: TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(_size / 2 - textPainter.width / 2, _size / 2 - textPainter.height / 2));
  }

  void _drawGem(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF00BCD4);
    final path = Path()
      ..moveTo(_size / 2, 2)
      ..lineTo(_size - 4, _size / 2)
      ..lineTo(_size / 2, _size - 2)
      ..lineTo(4, _size / 2)
      ..close();
    canvas.drawPath(path, paint);
    // Parlama
    final shinePaint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawCircle(Offset(_size * 0.35, _size * 0.3), 4, shinePaint);
  }

  void _drawStar(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFFFEB3B);
    final path = _starPath(_size / 2, _size / 2, _size / 2 - 2, _size / 4, 5);
    canvas.drawPath(path, paint);
  }

  Path _starPath(double cx, double cy, double outerR, double innerR, int points) {
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }
}
