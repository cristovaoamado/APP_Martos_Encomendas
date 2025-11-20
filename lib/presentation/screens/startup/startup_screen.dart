import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/providers.dart';
import '../settings/settings_screen.dart';
import '../auth/login_screen.dart';

/// Ecrã de inicialização que verifica se a app está configurada
class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkConfigurationAndNavigate();
  }

  Future<void> _checkConfigurationAndNavigate() async {
    if (kDebugMode) {
      print('🚀 StartupScreen - Iniciando verificação...');
    }

    // ✅ Aguardar um momento para garantir que tudo está inicializado
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // ✅ Obter StorageService
    final storageService = ref.read(storageServiceProvider);

    // ✅ Verificar se URL está configurada
    final isConfigured = storageService.hasApiUrl();

    if (kDebugMode) {
      print('');
      print('🔍 ========== VERIFICAÇÃO FINAL ==========');
      print('   URL da API: ${storageService.getApiUrl() ?? "(vazia)"}');
      print('   isConfigured: $isConfigured');
      print('==========================================');
      print('');
    }

    if (!mounted) return;

    if (!isConfigured) {
      if (kDebugMode) {
        print('❌ NÃO configurado → Indo para SettingsScreen');
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const SettingsScreen(isInitialSetup: true),
        ),
      );
    } else {
      if (kDebugMode) {
        print('✅ Configurado → Indo para LoginScreen');
      }
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 80, color: Colors.blue.shade700),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'A carregar configurações...',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
