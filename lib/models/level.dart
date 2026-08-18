import 'package:flutter/foundation.dart';
import 'dart:ui';

/// Level konfigürasyonu
class Level {
  final int number;
  final String name;
  final Color skyColor;
  final Color groundColor;
  final int enemyCount;
  final double enemySpeed;
  final int treasureCount;
  final double platformSpeed; // Hareketli platformlar için
  final bool hasBoss;
  final int targetScore;

  const Level({
    required this.number,
    required this.name,
    required this.skyColor,
    required this.groundColor,
    required this.enemyCount,
    required this.enemySpeed,
    required this.treasureCount,
    required this.platformSpeed,
    required this.hasBoss,
    required this.targetScore,
  });

  /// Oyundaki 5 level tanımı
  static const List<Level> levels = [
    Level(
      number: 1,
      name: 'Ormanın Girişi',
      skyColor: Color(0xFF87CEEB),
      groundColor: Color(0xFF228B22),
      enemyCount: 2,
      enemySpeed: 60,
      treasureCount: 5,
      platformSpeed: 0,
      hasBoss: false,
      targetScore: 200,
    ),
    Level(
      number: 2,
      name: 'Derin Orman',
      skyColor: Color(0xFF5FA85F),
      groundColor: Color(0xFF1B5E20),
      enemyCount: 3,
      enemySpeed: 80,
      treasureCount: 6,
      platformSpeed: 40,
      hasBoss: false,
      targetScore: 400,
    ),
    Level(
      number: 3,
      name: 'Kayalık Geçit',
      skyColor: Color(0xFF4A7C59),
      groundColor: Color(0xFF5D4037),
      enemyCount: 4,
      enemySpeed: 100,
      treasureCount: 7,
      platformSpeed: 60,
      hasBoss: false,
      targetScore: 700,
    ),
    Level(
      number: 4,
      name: 'Gizli Mağara',
      skyColor: Color(0xFF1A237E),
      groundColor: Color(0xFF37474F),
      enemyCount: 5,
      enemySpeed: 120,
      treasureCount: 8,
      platformSpeed: 80,
      hasBoss: false,
      targetScore: 1000,
    ),
    Level(
      number: 5,
      name: 'Boss Kalesi',
      skyColor: Color(0xFF4A0000),
      groundColor: Color(0xFF212121),
      enemyCount: 3,
      enemySpeed: 100,
      treasureCount: 10,
      platformSpeed: 60,
      hasBoss: true,
      targetScore: 1500,
    ),
  ];

  static Level? getLevel(int number) {
    if (number < 1 || number > levels.length) return null;
    return levels[number - 1];
  }
}
