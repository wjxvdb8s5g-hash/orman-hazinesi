import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/player_stats.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

/// Ana menü ekranı
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _titleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
    );

    // Müziği başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audio = context.read<AudioService>();
      audio.playBGM('audio/menu_bgm.mp3');
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo ve başlık
              ScaleTransition(
                scale: _titleAnimation,
                child: Column(
                  children: [
                    const Text('🌲', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 8),
                    Text(
                      'ORMAN HAZİNESİ',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFFD700),
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 3),
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Macera Seni Bekliyor!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA5D6A7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Yüksek skor göstergesi
              Consumer<PlayerStats>(
                builder: (_, stats, __) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        'En Yüksek: ${stats.highScore}',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Menü butonları
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MenuButton(
                      label: '🎮 OYNA',
                      color: const Color(0xFFFF6F00),
                      onTap: _startGame,
                      large: true,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MenuButton(
                          label: '🏆 Sırala',
                          color: const Color(0xFF1565C0),
                          onTap: () => _navigate(const LeaderboardScreen()),
                        ),
                        const SizedBox(width: 12),
                        _MenuButton(
                          label: '📊 İstatistik',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => _navigate(const StatsScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MenuButton(
                          label: '⚙️ Ayarlar',
                          color: const Color(0xFF37474F),
                          onTap: () => _navigate(const SettingsScreen()),
                        ),
                        const SizedBox(width: 12),
                        Consumer<AudioService>(
                          builder: (ctx, audio, _) => _MenuButton(
                            label: audio.isMuted ? '🔇 Ses Kapalı' : '🔊 Ses Açık',
                            color: const Color(0xFF00695C),
                            onTap: () async {
                              final storage = ctx.read<StorageService>();
                              await audio.toggleMute(storage);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Altbilgi
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '7+ • Macera & Platform Oyunu',
                  style: TextStyle(color: Color(0xFF81C784), fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame() {
    final gameState = context.read<GameState>();
    gameState.startGame();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }

  void _navigate(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool large;

  const _MenuButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: large ? 220 : 150,
        height: large ? 56 : 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: large ? 22 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
