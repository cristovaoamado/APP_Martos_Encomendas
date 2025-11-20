import 'package:encomendas_app/data/providers/providers.dart';
import 'package:encomendas_app/presentation/screens/auth/login_screen.dart';
import 'package:encomendas_app/presentation/screens/home/home_screen.dart';
import 'package:encomendas_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Garantir inicialização dos bindings do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Criar instância do StorageService
  final storageService = StorageService(sharedPreferences);

  runApp(
    ProviderScope(
      overrides: [
        // Sobrescrever o storageServiceProvider com a instância real
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Gestão de Encomendas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
