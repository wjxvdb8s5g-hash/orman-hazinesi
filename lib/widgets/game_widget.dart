import 'package:flutter/material.dart';
import 'package:flame/game.dart' as flame;
import '../game/game_controller.dart';

/// Flame oyununu saran Flutter widget'ı
class GameWidgetWrapper extends StatelessWidget {
  final GameController game;
  const GameWidgetWrapper({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return flame.GameWidget(game: game);
  }
}
