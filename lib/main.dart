import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'models/player_stats.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Yalnızca yatay yön
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Tam ekran modu
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  await audioService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => PlayerStats(storageService)),
        Provider<StorageService>.value(value: storageService),
        Provider<AudioService>.value(value: audioService),
      ],
      child: const OrmanHazinesiApp(),
    ),
  );
}

class OrmanHazinesiApp extends StatelessWidget {
  const OrmanHazinesiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orman Hazinesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D7A2D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MenuScreen(),
    );
  }
}
