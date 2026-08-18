# 🌲 Orman Hazinesi

**7+ yaş çocuklar için Flutter macera platformer oyunu!**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Flame](https://img.shields.io/badge/Flame-1.18-orange.svg)](https://flame-engine.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green.svg)](https://flutter.dev)

---

## 🎮 Oyun Özellikleri

- **5 Eğlenceli Level** - Artan zorlukla birlikte yeni mekanikler
- **Akıllı Düşman AI** - Takip, devriye ve saldırı stratejileri
- **3 Farklı Hazine Tipi** - Altın (10pt), Mücevher (30pt), Yıldız (50pt)
- **Hareketli & Yok olan Platformlar** - Level ilerledikçe daha zor
- **Boss Level** - 5. levelda güçlü bir boss karşılıyor seni
- **İstatistik Sistemi** - Oyun süresi, toplam hazine, en yüksek skor
- **Başarı/Rozet Sistemi** - 7 farklı başarı
- **Leaderboard** - En yüksek skorunu takip et
- **Ses & Müzik** - Mute/unmute desteği

---

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio veya VS Code
- Android 8.0+ veya iOS 11.0+

### Adımlar

```bash
# Repoyu klonla
git clone https://github.com/wjxvdb8s5g-hash/orman-hazinesi.git
cd orman-hazinesi

# Bağımlılıkları yükle
flutter pub get

# Android'de çalıştır
flutter run -d android

# iOS'ta çalıştır
flutter run -d ios

# Release build
flutter build apk --release
flutter build ipa
```

---

## 📁 Proje Yapısı

```
lib/
├── main.dart                    # Uygulama başlangıç noktası
├── screens/
│   ├── menu_screen.dart         # Ana menü
│   ├── game_screen.dart         # Oyun ekranı
│   ├── game_over_screen.dart    # Oyun bitti ekranı
│   ├── level_complete_screen.dart # Level tamamlandı ekranı
│   ├── settings_screen.dart     # Ayarlar ekranı
│   ├── leaderboard_screen.dart  # Skor tablosu
│   └── stats_screen.dart        # İstatistikler
├── game/
│   ├── game_controller.dart     # Ana oyun motoru (Flame)
│   ├── player.dart              # Oyuncu karakteri & fizik
│   ├── enemy.dart               # Düşman karakteri
│   ├── collectible.dart         # Toplanabilir hazineler
│   ├── platform.dart            # Platform bileşeni
│   ├── level_manager.dart       # Level düzenini yükler
│   └── ai_brain.dart            # Düşman yapay zekası
├── models/
│   ├── level.dart               # Level konfigürasyonu
│   ├── game_state.dart          # Oyun durumu (Provider)
│   ├── player_stats.dart        # Oyuncu istatistikleri
│   └── achievement.dart         # Başarı/rozet modeli
├── services/
│   ├── audio_service.dart       # Ses yönetimi
│   ├── game_service.dart        # Oyun servis katmanı
│   ├── storage_service.dart     # SharedPreferences wrapper
│   └── stats_service.dart       # İstatistik hesaplama
└── widgets/
    ├── game_widget.dart          # Flame GameWidget wrapper
    └── hud.dart                 # HUD (skor, can, level)
```

---

## 🕹️ Kontroller

| Buton | Eylem |
|-------|-------|
| ⬅ Sol Ok | Sola hareket |
| ➡ Sağ Ok | Sağa hareket |
| ⬆ Yukarı | Zıpla |
| ⏸ Pause | Oyunu duraklat |

---

## 🏆 Başarılar

| Başarı | Açıklama |
|--------|----------|
| ⭐ İlk Adım | 1000 puan kazan |
| 🌟 Yıldız Oyuncu | 5000 puan kazan |
| 💰 Hazine Avcısı | 10 hazine topla |
| 👑 Hazine Ustası | 50 hazine topla |
| 🗺️ Maceracı | 3. seviyeye ulaş |
| 🏆 Orman Kahramanı | Son seviyeye ulaş |
| 🎮 Bağımlı Oyuncu | 5 oyun oyna |

---

## 📱 Platform Desteği

| Platform | Minimum | Hedef |
|----------|---------|-------|
| Android | 8.0 (API 26) | 14.0 (API 34) |
| iOS | 11.0 | 17.0 |

---

## 🤖 AI Düşman Davranışları

Düşman AI 3 farklı mod arasında dinamik olarak geçiş yapar:

1. **Devriye (Patrol)** - Oyuncuya uzak olduğunda ileri geri yürür
2. **Takip (Chase)** - Oyuncu 280px yakınına girdiğinde takip eder
3. **Sıkışma önleme** - Engellere takıldığında otomatik yön değiştirir

Level ilerledikçe düşman hızı ve sayısı artar. 5. levelde bir Boss düşman var!

---

## 📊 Teknik Detaylar

- **FPS Hedefi**: 60 FPS
- **Game Engine**: Flame 1.18.0
- **State Management**: Provider 6.x
- **Local Storage**: SharedPreferences
- **Fizik**: Özel gravity + collision sistemi
- **Animasyon**: Canvas tabanlı prosedürel animasyon

---

## 📄 Lisans

MIT License - Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

*Orman Hazinesi - Eğlenceli, eğitici ve bağımlılık yapan bir macera oyunu! 🌲✨*
