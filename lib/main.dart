import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/storage_service.dart';
import 'data/providers/providers.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/encomenda/encomendas_list_screen.dart';
import 'presentation/screens/encomenda/create_encomenda_screen.dart';
import 'presentation/screens/encomenda/encomenda_detail_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/encomendas': (context) => const EncomendasListScreen(),
        '/encomenda/create': (context) => const CreateEncomendaScreen(),
      },
      onGenerateRoute: (settings) {
        // Rota dinâmica para detalhes da encomenda
        if (settings.name?.startsWith('/encomenda/') == true) {
          final uri = Uri.parse(settings.name!);
          if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'encomenda') {
            final id = int.tryParse(uri.pathSegments[1]);
            if (id != null) {
              return MaterialPageRoute(
                builder: (context) => EncomendaDetailScreen(idEncomenda: id),
                settings: settings,
              );
            }
          }
        }
        return null;
      },
      onUnknownRoute: (settings) {
        // Rota de fallback caso nenhuma rota seja encontrada
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Página não encontrada')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Página não encontrada',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    settings.name ?? 'Rota desconhecida',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                    icon: const Icon(Icons.home),
                    label: const Text('Voltar ao início'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
