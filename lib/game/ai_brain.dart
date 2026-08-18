import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Akıllı düşman yapay zekası
class AIBrain {
  final dynamic enemy; // Enemy referansı
  final double moveSpeed;

  // AI durumu
  bool _isPatrolling = true;
  bool _isChasing = false;
  double _patrolDirection = 1; // 1 = sağ, -1 = sol
  double _patrolTimer = 0;
  static const double _patrolChangeInterval = 2.5;
  static const double _chaseRange = 280;
  static const double _attackRange = 50;

  // Engel algılama
  double _stuckTimer = 0;
  double _lastX = 0;

  AIBrain({required this.enemy, required this.moveSpeed});

  /// Her frame'de hız hesapla
  Vector2 computeVelocity(Vector2 myPos, Vector2 playerPos, double dt) {
    final dx = playerPos.x - myPos.x;
    final distance = dx.abs();

    // Sıkışma kontrolü
    _stuckTimer += dt;
    if (_stuckTimer >= 0.8) {
      if ((myPos.x - _lastX).abs() < 5) {
        _patrolDirection *= -1; // Yön değiştir
      }
      _lastX = myPos.x;
      _stuckTimer = 0;
    }

    // Takip menzili
    if (distance < _chaseRange) {
      _isChasing = true;
      _isPatrolling = false;
    } else {
      _isChasing = false;
      _isPatrolling = true;
    }

    if (_isChasing) {
      // Oyuncuyu takip et
      final dir = dx > 0 ? 1.0 : -1.0;
      return Vector2(dir * moveSpeed * 1.2, 0);
    } else {
      // Devriye - ileri geri yürü
      _patrolTimer += dt;
      if (_patrolTimer >= _patrolChangeInterval) {
        _patrolTimer = 0;
        _patrolDirection *= -1;
      }
      return Vector2(_patrolDirection * moveSpeed * 0.7, 0);
    }
  }

  void reverseDirection() {
    _patrolDirection *= -1;
  }

  bool get isChasing => _isChasing;
}
