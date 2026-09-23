import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/player_stats.dart';
import 'menu_screen.dart';
import 'game_screen.dart';

/// Oyun bitti ekranı
class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();
    final stats = context.read<PlayerStats>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A0000), Color(0xFF7B0000), Color(0xFFB71C1C)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('💀', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 16),
                const Text(
                  'OYUN BİTTİ',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFFD700),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 32),
                // Skor kartı
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFFFD700), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      _ScoreRow(label: '🏅 Puan', value: '${gameState.score}'),
                      const Divider(color: Colors.white24),
                      _ScoreRow(
                          label: '💰 Hazine',
                          value: '${gameState.totalTreasures}'),
                      const Divider(color: Colors.white24),
                      _ScoreRow(
                          label: '🗺️ Level',
                          value: '${gameState.currentLevel}'),
                      const Divider(color: Colors.white24),
                      _ScoreRow(
                          label: '🏆 En Yüksek',
                          value: '${stats.highScore}'),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Butonlar
                _ActionButton(
                  label: '🔄 Tekrar Oyna',
                  color: const Color(0xFFFF6F00),
                  onTap: () {
                    final gs = context.read<GameState>();
                    gs.startGame();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                ),
                const SizedBox(height: 14),
                _ActionButton(
                  label: '🏠 Ana Menü',
                  color: const Color(0xFF37474F),
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MenuScreen()),
                    (r) => false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final String value;
  const _ScoreRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 54,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
