import 'package:dio/dio.dart';
import '../models/user.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../core/constants/api_constants.dart';

class AuthRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthRepository(this._apiService, this._storageService);

  /// Login com email e password
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      final user = User.fromJson(response.data);
      
      // Salvar token e user
      await _storageService.saveToken(user.token ?? '');
      await _storageService.saveUser(user);
      
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou password incorretos');
      }
      throw Exception('Erro ao fazer login: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  /// Login com PIN
  Future<User> loginWithPin(String pin) async {
    try {
      final response = await _apiService.post(
        ApiConstants.loginPinEndpoint,
        data: {
          'pin': pin,
        },
      );

      final user = User.fromJson(response.data);
      
      // Salvar token e user
      await _storageService.saveToken(user.token ?? '');
      await _storageService.saveUser(user);
      
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('PIN incorreto');
      }
      throw Exception('Erro ao fazer login com PIN: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer login com PIN: $e');
    }
  }

  /// Obter utilizador atual
  Future<User?> getCurrentUser() async {
    try {
      final token = await _storageService.getToken();
      if (token == null || token.isEmpty) return null;

      return await _storageService.getUser();
    } catch (e) {
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _storageService.clearToken();
    await _storageService.clearUser();
  }

  /// Verificar se está autenticado
  Future<bool> isAuthenticated() async {
    final token = await _storageService.getToken();
    return token != null && token.isNotEmpty;
  }
}
