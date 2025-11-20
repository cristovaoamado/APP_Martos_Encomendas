import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Storage key para as configurações
const _settingsKey = 'app_settings';

/// Provider para SharedPreferences
final _sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// Provider para as configurações da aplicação
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier(ref);
});

/// Provider para verificar se settings já foram carregados
final settingsLoadedProvider = Provider<bool>((ref) {
  final notifier = ref.watch(settingsProvider.notifier);
  return notifier.isLoaded;
});

/// Notifier para gerir as configurações
class SettingsNotifier extends StateNotifier<AppSettings> {
  final Ref _ref;
  SharedPreferences? _prefs;
  bool _isLoaded = false;

  SettingsNotifier(this._ref) : super(kDefaultSettings) {
    _loadSettings();
  }

  /// Verificar se já foi carregado
  bool get isLoaded => _isLoaded;

  /// Carregar configurações do storage
  Future<void> _loadSettings() async {
    try {
      if (kDebugMode) {
        print('🔄 Iniciando carregamento de configurações...');
      }

      final prefsAsync = await _ref.read(_sharedPreferencesProvider.future);
      _prefs = prefsAsync;

      final settingsJson = _prefs?.getString(_settingsKey);

      if (kDebugMode) {
        print('🔍 DEBUG _loadSettings:');
        print('   settingsJson: $settingsJson');
      }

      if (settingsJson != null && settingsJson.isNotEmpty) {
        final map = json.decode(settingsJson) as Map<String, dynamic>;
        state = AppSettings.fromJson(map);
        if (kDebugMode) {
          print('✅ Configurações carregadas: ${state.apiBaseUrl}');
        }
      } else {
        state = kDefaultSettings;
        if (kDebugMode) {
          print('⚠️ Sem configurações - apiBaseUrl: "${state.apiBaseUrl}"');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao carregar configurações: $e');
      }
      state = kDefaultSettings;
    } finally {
      _isLoaded = true;
      if (kDebugMode) {
        print('✅ Carregamento completo. isLoaded = true');
      }
    }
  }

  /// Atualizar URL da API
  Future<void> updateApiUrl(String newUrl) async {
    try {
      // Limpar trailing slashes
      final cleanUrl = newUrl.trim().replaceAll(RegExp(r'/+$'), '');

      // Validar URL
      if (cleanUrl.isEmpty) {
        throw Exception('URL não pode estar vazio');
      }

      if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
        throw Exception('URL deve começar com http:// ou https://');
      }

      final newSettings = state.copyWith(
        apiBaseUrl: cleanUrl,
        lastUpdated: DateTime.now(),
      );

      await _saveSettings(newSettings);
      state = newSettings;

      if (kDebugMode) {
        print('✅ URL da API atualizado: $cleanUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao atualizar URL: $e');
      }
      rethrow;
    }
  }

  /// Atualizar timeouts
  Future<void> updateTimeouts({
    int? connectionTimeout,
    int? receiveTimeout,
  }) async {
    try {
      final newSettings = state.copyWith(
        connectionTimeoutSeconds:
            connectionTimeout ?? state.connectionTimeoutSeconds,
        receiveTimeoutSeconds: receiveTimeout ?? state.receiveTimeoutSeconds,
        lastUpdated: DateTime.now(),
      );

      await _saveSettings(newSettings);
      state = newSettings;

      if (kDebugMode) {
        print('✅ Timeouts atualizados');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao atualizar timeouts: $e');
      }
      rethrow;
    }
  }

  /// Guardar configurações no storage
  Future<void> _saveSettings(AppSettings settings) async {
    try {
      if (_prefs == null) {
        final prefsAsync = await _ref.read(_sharedPreferencesProvider.future);
        _prefs = prefsAsync;
      }

      final settingsJson = json.encode(settings.toJson());
      await _prefs?.setString(_settingsKey, settingsJson);
      if (kDebugMode) {
        print('✅ Configurações guardadas');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao guardar configurações: $e');
      }
      rethrow;
    }
  }

  /// Resetar para configurações padrão
  Future<void> resetToDefaults() async {
    try {
      if (_prefs == null) {
        final prefsAsync = await _ref.read(_sharedPreferencesProvider.future);
        _prefs = prefsAsync;
      }

      await _prefs?.remove(_settingsKey);
      state = kDefaultSettings;
      if (kDebugMode) {
        print('✅ Configurações resetadas para padrão');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erro ao resetar configurações: $e');
      }
      rethrow;
    }
  }

  /// Verificar se configurações estão definidas (URL não vazia)
  bool get isConfigured {
    final result =
        state.apiBaseUrl.isNotEmpty &&
        (state.apiBaseUrl.startsWith('http://') ||
            state.apiBaseUrl.startsWith('https://'));

    if (kDebugMode) {
      print('🔍 isConfigured check:');
      print('   apiBaseUrl: "${state.apiBaseUrl}"');
      print('   isEmpty: ${state.apiBaseUrl.isEmpty}');
      print('   startsWith http: ${state.apiBaseUrl.startsWith('http://')}');
      print('   startsWith https: ${state.apiBaseUrl.startsWith('https://')}');
      print('   RESULT: $result');
    }

    return result;
  }

  /// Obter URL completa da API (com /api)
  /// Se não configurado, usa localhost como fallback
  String get fullApiUrl {
    if (state.apiBaseUrl.isEmpty) {
      // Fallback para localhost (só para evitar crashes)
      return 'http://127.0.0.1:5000/api';
    }
    return '${state.apiBaseUrl}/api';
  }
}

/// Provider para verificar se está configurado
final isConfiguredProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsProvider);
  // Configurado = URL não vazia E válida
  final result =
      settings.apiBaseUrl.isNotEmpty &&
      (settings.apiBaseUrl.startsWith('http://') ||
          settings.apiBaseUrl.startsWith('https://'));

  if (kDebugMode) {
    print('📍 isConfiguredProvider:');
    print('   apiBaseUrl: "${settings.apiBaseUrl}"');
    print('   result: $result');
  }

  return result;
});

/// Provider para URL completa da API
final apiUrlProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsProvider);
  if (settings.apiBaseUrl.isEmpty) {
    // Fallback para localhost
    return 'http://127.0.0.1:5000/api';
  }
  return '${settings.apiBaseUrl}/api';
});
