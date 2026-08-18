import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'platform.dart' as game_platform;
import 'collectible.dart';
import 'enemy.dart';

enum PlayerState { idle, running, jumping, hurt }

/// Oyuncu karakteri
class PlayerCharacter extends PositionComponent
    with HasGameRef, CollisionCallbacks {
  final VoidCallback onDeath;

  // Fizik
  Vector2 _velocity = Vector2.zero();
  static const double _gravity = 980;
  static const double _jumpForce = -480;
  static const double _moveSpeed = 200;
  static const double _maxFallSpeed = 700;

  bool _isOnGround = false;
  bool _isHurt = false;
  double _hurtTimer = 0;
  static const double _hurtDuration = 1.2;
  int _direction = 0; // -1 sol, 0 dur, 1 sağ

  PlayerState _state = PlayerState.idle;

  // Animasyon zamanlayıcı
  double _animTimer = 0;
  int _animFrame = 0;

  static const double playerWidth = 40;
  static const double playerHeight = 52;

  PlayerCharacter({
    required Vector2 position,
    required this.onDeath,
  }) : super(
          position: position,
          size: Vector2(playerWidth, playerHeight),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(playerWidth - 8, playerHeight),
      position: Vector2(4, 0),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isHurt) {
      _hurtTimer -= dt;
      if (_hurtTimer <= 0) _isHurt = false;
    }

    // Yatay hareket
    _velocity.x = _direction * _moveSpeed;

    // Yerçekimi
    _velocity.y += _gravity * dt;
    if (_velocity.y > _maxFallSpeed) _velocity.y = _maxFallSpeed;

    // Pozisyonu güncelle
    position += _velocity * dt;

    // Animasyon durumu
    if (!_isOnGround) {
      _state = PlayerState.jumping;
    } else if (_direction != 0) {
      _state = PlayerState.running;
    } else {
      _state = PlayerState.idle;
    }

    // Animasyon karesi
    _animTimer += dt;
    if (_animTimer >= 0.1) {
      _animTimer = 0;
      _animFrame = (_animFrame + 1) % 4;
    }

    // Zemin sınırı - yere düştüyse can kaybı
    if (position.y > gameRef.size.y + 100) {
      onDeath();
    }

    _isOnGround = false;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is game_platform.GamePlatform) {
      _handlePlatformCollision(other, intersectionPoints);
    } else if (other is Enemy && !_isHurt) {
      _isHurt = true;
      _hurtTimer = _hurtDuration;
      onDeath();
    } else if (other is Collectible) {
      other.collect();
    }
  }

  void _handlePlatformCollision(
      game_platform.GamePlatform platform, Set<Vector2> points) {
    final avgY = points.map((p) => p.y).reduce((a, b) => a + b) / points.length;
    final playerBottom = position.y;
    final platformTop = platform.position.y;

    if (playerBottom - platformTop < 20 && _velocity.y > 0) {
      _isOnGround = true;
      _velocity.y = 0;
      position.y = platformTop;
    }
  }

  void moveLeft() => _direction = -1;
  void moveRight() => _direction = 1;
  void stopHorizontal() => _direction = 0;

  void jump() {
    if (_isOnGround) {
      _velocity.y = _jumpForce;
      _isOnGround = false;
    }
  }

  void respawn(Vector2 spawnPos) {
    position = spawnPos;
    _velocity = Vector2.zero();
    _isHurt = false;
    _hurtTimer = 0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawPlayer(canvas);
  }

  void _drawPlayer(Canvas canvas) {
    final isFlickering = _isHurt && (_hurtTimer * 6).round() % 2 == 0;
    if (isFlickering) return;

    // Gövde (yeşil ceket)
    final bodyPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;
    canvas.drawRoundRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 20, 24, 24),
        const Radius.circular(4),
      ),
      bodyPaint,
    );

    // Kafa (ten rengi)
    final headPaint = Paint()
      ..color = const Color(0xFFFFCC80)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromLTWH(10, 2, 20, 20),
      headPaint,
    );

    // Şapka
    final hatPaint = Paint()
      ..color = const Color(0xFF795548)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(6, 0, 28, 6), hatPaint);
    canvas.drawRect(Rect.fromLTWH(10, -6, 20, 8), hatPaint);

    // Gözler
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(15, 12), 2, eyePaint);
    canvas.drawCircle(const Offset(25, 12), 2, eyePaint);

    // Bacaklar - koşu animasyonu
    final legPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;

    if (_state == PlayerState.running) {
      final legOffset = _animFrame % 2 == 0 ? 4.0 : -4.0;
      canvas.drawRoundRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(10, 44, 9, 10 + legOffset),
          const Radius.circular(3),
        ),
        legPaint,
      );
      canvas.drawRoundRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(21, 44, 9, 10 - legOffset),
          const Radius.circular(3),
        ),
        legPaint,
      );
    } else {
      canvas.drawRoundRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(10, 44, 9, 10),
          const Radius.circular(3),
        ),
        legPaint,
      );
      canvas.drawRoundRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(21, 44, 9, 10),
          const Radius.circular(3),
        ),
        legPaint,
      );
    }
  }
}
