/// Başarı/rozet modeli
class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
  });

  /// Tüm başarıların listesi
  static const List<Achievement> all = [
    Achievement(
      id: 'score_1000',
      title: 'İlk Adım',
      description: '1000 puan kazan',
      emoji: '⭐',
    ),
    Achievement(
      id: 'score_5000',
      title: 'Yıldız Oyuncu',
      description: '5000 puan kazan',
      emoji: '🌟',
    ),
    Achievement(
      id: 'treasure_10',
      title: 'Hazine Avcısı',
      description: '10 hazine topla',
      emoji: '💰',
    ),
    Achievement(
      id: 'treasure_50',
      title: 'Hazine Ustası',
      description: '50 hazine topla',
      emoji: '👑',
    ),
    Achievement(
      id: 'level_3',
      title: 'Maceracı',
      description: '3. seviyeye ulaş',
      emoji: '🗺️',
    ),
    Achievement(
      id: 'level_5',
      title: 'Orman Kahramanı',
      description: 'Son seviyeye ulaş',
      emoji: '🏆',
    ),
    Achievement(
      id: 'games_5',
      title: 'Bağımlı Oyuncu',
      description: '5 oyun oyna',
      emoji: '🎮',
    ),
  ];

  static Achievement? findById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
