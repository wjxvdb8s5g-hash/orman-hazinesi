import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_stats.dart';
import '../models/achievement.dart';

/// İstatistikler ekranı
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: const Text(
          '📊 İstatistikler',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1B5E20),
                  title: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'Tüm istatistikler silinecek. Emin misin?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('İptal', style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sıfırla', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                await context.read<PlayerStats>().resetStats();
              }
            },
            child: const Text('Sıfırla', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Consumer<PlayerStats>(
        builder: (_, stats, __) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatCard(
                title: 'Oyun İstatistikleri',
                children: [
                  _StatRow('🏆 En Yüksek Skor', '${stats.highScore}'),
                  _StatRow('🎮 Toplam Oyun', '${stats.totalGamesPlayed}'),
                  _StatRow('⏱️ Toplam Süre', stats.formattedPlayTime),
                  _StatRow('💰 Toplam Hazine', '${stats.totalTreasuresCollected}'),
                  _StatRow('🗺️ En Yüksek Level', '${stats.highestLevelReached}'),
                ],
              ),
              const SizedBox(height: 20),
              _StatCard(
                title: 'Başarılar (${stats.unlockedAchievements.length}/${Achievement.all.length})',
                children: Achievement.all.map((a) {
                  final unlocked = stats.unlockedAchievements.contains(a.id);
                  return _AchievementRow(achievement: a, unlocked: unlocked);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _StatCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;
  const _AchievementRow({required this.achievement, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            unlocked ? achievement.emoji : '🔒',
            style: TextStyle(
              fontSize: 24,
              color: unlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: unlocked ? Colors.white54 : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
        ],
      ),
    );
  }
}
