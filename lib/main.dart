import 'package:encomendas_app/core/theme/app_theme.dart';
import 'package:encomendas_app/presentation/screens/auth/login_screen.dart';
import 'package:encomendas_app/presentation/screens/encomenda/create_encomenda_screen.dart';
import 'package:encomendas_app/presentation/screens/encomenda/encomendas_list_screen.dart';
import 'package:encomendas_app/presentation/screens/home/home_screen.dart';
import 'package:encomendas_app/presentation/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/providers/providers.dart';
import 'services/storage_service.dart';
import 'presentation/screens/startup/startup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializar SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // ✅ Criar StorageService
  final storageService = StorageService(prefs);

  runApp(
    ProviderScope(
      overrides: [
        // ✅ Sobrescrever provider com instância real
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encomendas App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const StartupScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/encomenda/list': (context) => const EncomendasListScreen(),
        '/encomenda/create': (context) => const CreateEncomendaScreen(),
      },
    );
  }
}
