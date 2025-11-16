import 'package:encomendas_app/data/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

// Provider para o repositório de autenticação
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final storageService = ref.read(storageServiceProvider);
  return AuthRepository(apiService, storageService);
});

// Estado de autenticação
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => user != null;
}

// Notifier de autenticação
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = await _repository.getCurrentUser();
    if (user != null) {
      state = state.copyWith(user: user);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> loginWithPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.loginWithPin(pin);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState();
  }
}

// Provider principal de autenticação
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});
