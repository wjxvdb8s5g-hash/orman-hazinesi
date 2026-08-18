import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import 'game_screen.dart';
import 'menu_screen.dart';

/// Level tamamlama ekranı
class LevelCompleteScreen extends StatelessWidget {
  const LevelCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();
    final isLastLevel = gameState.currentLevel >= Level.levels.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 12),
                Text(
                  isLastLevel ? 'OYUN TAMAMLANDI!' : 'LEVEL TAMAMLANDI!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFFFD700),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Level ${gameState.currentLevel}',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xFF90CAF9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                // Yıldızlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('⭐', style: TextStyle(fontSize: 44)),
                    Text('⭐', style: TextStyle(fontSize: 52)),
                    Text('⭐', style: TextStyle(fontSize: 44)),
                  ],
                ),
                const SizedBox(height: 28),
                // Skor bilgisi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Toplam Puan: ${gameState.score}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (!isLastLevel)
                  _LevelButton(
                    label: '➡ Sonraki Level',
                    color: const Color(0xFF2E7D32),
                    onTap: () {
                      gameState.nextLevel();
                      Navigator.pop(context);
                    },
                  ),
                if (isLastLevel)
                  _LevelButton(
                    label: '🏆 Tebrikler!',
                    color: const Color(0xFFFF6F00),
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MenuScreen()),
                      (r) => false,
                    ),
                  ),
                const SizedBox(height: 14),
                _LevelButton(
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

class _LevelButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _LevelButton({required this.label, required this.color, required this.onTap});

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
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
