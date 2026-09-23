import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

/// HUD (Head-Up Display) - skor, can ve level göstergesi
class HUD extends StatelessWidget {
  const HUD({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (_, gameState, __) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Skor
                _HUDItem(
                  emoji: '🏅',
                  label: '${gameState.score}',
                  color: const Color(0xFFFFD700),
                ),
                const SizedBox(width: 16),
                // Level
                _HUDItem(
                  emoji: '🗺️',
                  label: 'L${gameState.currentLevel}',
                  color: const Color(0xFF90CAF9),
                ),
                const SizedBox(width: 16),
                // Hazine
                _HUDItem(
                  emoji: '💰',
                  label: '${gameState.totalTreasures}',
                  color: const Color(0xFFFFE082),
                ),
                const Spacer(),
                // Canlar
                Row(
                  children: List.generate(3, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        i < gameState.lives ? '❤️' : '🖤',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HUDItem extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _HUDItem({required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(offset: Offset(1, 1), color: Colors.black, blurRadius: 2),
            ],
          ),
        ),
      ],
    );
  }
}
