import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart' as flame;
import '../game/game_controller.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/player_stats.dart';
import '../services/audio_service.dart';
import '../services/game_service.dart';
import '../widgets/hud.dart';
import 'game_over_screen.dart';
import 'level_complete_screen.dart';

/// Oyun ekranı
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameController? _gameController;
  bool _showPauseMenu = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGame();
    });
  }

  void _initGame() {
    final gameState = context.read<GameState>();
    final levelConfig = Level.getLevel(gameState.currentLevel) ?? Level.levels.first;
    final audio = context.read<AudioService>();
    audio.playBGM('audio/game_bgm.mp3');

    setState(() {
      _gameController = GameController(
        gameState: gameState,
        levelConfig: levelConfig,
        onGameOver: _onGameOver,
        onLevelComplete: _onLevelComplete,
        onTreasureCollected: () {
          audio.playSFX('audio/collect.mp3');
        },
      );
    });
  }

  void _onGameOver() async {
    final gameState = context.read<GameState>();
    final stats = context.read<PlayerStats>();
    await GameService().finalizeGame(gameState, stats);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GameOverScreen()),
    );
  }

  void _onLevelComplete() {
    final audio = context.read<AudioService>();
    audio.playSFX('audio/level_complete.mp3');
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LevelCompleteScreen()),
    ).then((_) {
      if (!mounted) return;
      final gameState = context.read<GameState>();
      // nextLevel was already called in LevelCompleteScreen for non-last levels
      if (gameState.currentLevel <= Level.levels.length) {
        setState(() => _initGame());
      }
      // If last level was completed, LevelCompleteScreen already handles navigation
    });
  }

  void _togglePause() {
    final gameState = context.read<GameState>();
    gameState.togglePause();
    setState(() => _showPauseMenu = gameState.isPaused);
  }

  @override
  Widget build(BuildContext context) {
    if (_gameController == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B5E20),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Oyun görünümü
          flame.GameWidget(game: _gameController!),

          // HUD
          const HUD(),

          // Duraklat butonu
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: _togglePause,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.pause, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Kontrol butonları
          _buildControls(),

          // Duraklat menüsü
          if (_showPauseMenu) _buildPauseMenu(),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sol/sağ hareket
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                _ControlButton(
                  icon: Icons.arrow_back,
                  onTapDown: () => _gameController?.moveLeft(),
                  onTapUp: () => _gameController?.stopHorizontal(),
                ),
                const SizedBox(width: 12),
                _ControlButton(
                  icon: Icons.arrow_forward,
                  onTapDown: () => _gameController?.moveRight(),
                  onTapUp: () => _gameController?.stopHorizontal(),
                ),
              ],
            ),
          ),
          // Zıplama
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _ControlButton(
              icon: Icons.arrow_upward,
              onTapDown: () => _gameController?.jump(),
              onTapUp: () {},
              large: true,
              color: const Color(0xFFFF6F00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPauseMenu() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFD700), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⏸ DURAKLADI',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _PauseButton(
                label: '▶ Devam Et',
                onTap: _togglePause,
                color: const Color(0xFF2E7D32),
              ),
              const SizedBox(height: 12),
              _PauseButton(
                label: '🏠 Ana Menü',
                onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
                color: const Color(0xFFBF360C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final bool large;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.onTapDown,
    required this.onTapUp,
    this.large = false,
    this.color = const Color(0xFF37474F),
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 56.0;
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapUp,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: large ? 32 : 26),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _PauseButton({
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
