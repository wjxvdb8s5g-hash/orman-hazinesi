import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';

/// Ayarlar ekranı
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: const Text(
          '⚙️ Ayarlar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _SettingsCard(
              title: 'Ses & Müzik',
              children: [
                Consumer<AudioService>(
                  builder: (ctx, audio, _) => _SettingsToggle(
                    label: 'Tüm Sesler',
                    emoji: audio.isMuted ? '🔇' : '🔊',
                    value: !audio.isMuted,
                    onChanged: (v) async {
                      final storage = ctx.read<StorageService>();
                      await audio.toggleMute(storage);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              title: 'Oyun Hakkında',
              children: [
                _InfoRow('🎮', 'Orman Hazinesi v1.0.0'),
                _InfoRow('👶', '7+ yaş'),
                _InfoRow('🌲', 'Platform macera oyunu'),
                _InfoRow('❤️', 'Flutter & Flame ile yapıldı'),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              title: 'Kontroller',
              children: [
                _InfoRow('⬅➡', 'Hareket etmek için ok tuşları'),
                _InfoRow('⬆️', 'Zıplamak için yukarı tuşu'),
                _InfoRow('⏸', 'Duraklat için sağ üst buton'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsCard({required this.title, required this.children});

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

class _SettingsToggle extends StatelessWidget {
  final String label;
  final String emoji;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsToggle({
    required this.label,
    required this.emoji,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String emoji;
  final String text;
  const _InfoRow(this.emoji, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
