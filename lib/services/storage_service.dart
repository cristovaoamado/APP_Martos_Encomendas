import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/models/user.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _apiUrlKey = 'api_base_url';
  static const String _connectionTimeoutKey = 'connection_timeout';  // ✅ NOVO
  static const String _receiveTimeoutKey = 'receive_timeout';        // ✅ NOVO

  final SharedPreferences _prefs;

  // Construtor que recebe SharedPreferences
  StorageService(this._prefs);

  // ========== API URL methods ==========
  
  /// Guardar URL da API
  Future<void> saveApiUrl(String url) async {
    final cleanUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
    await _prefs.setString(_apiUrlKey, cleanUrl);
    if (kDebugMode) {
      print('✅ URL da API guardada: $cleanUrl');
    }
  }

  /// Obter URL da API
  String? getApiUrl() {
    return _prefs.getString(_apiUrlKey);
  }

  /// Verificar se URL está configurada
  bool hasApiUrl() {
    final url = getApiUrl();
    return url != null && 
           url.isNotEmpty && 
           (url.startsWith('http://') || url.startsWith('https://'));
  }

  /// Obter URL completa da API (com /api)
  String getFullApiUrl() {
    final baseUrl = getApiUrl();
    if (baseUrl == null || baseUrl.isEmpty) {
      // Fallback para localhost
      return 'http://127.0.0.1:5000/api';
    }
    return '$baseUrl/api';
  }

  /// Limpar URL da API
  Future<void> clearApiUrl() async {
    await _prefs.remove(_apiUrlKey);
  }

  // ========== Timeout methods ========== ✅ NOVO
  
  /// Guardar Connection Timeout (em segundos)
  Future<void> saveConnectionTimeout(int seconds) async {
    await _prefs.setInt(_connectionTimeoutKey, seconds);
    if (kDebugMode) {
      print('✅ Connection Timeout guardado: ${seconds}s');
    }
  }

  /// Obter Connection Timeout (padrão: 30 segundos)
  int getConnectionTimeout() {
    return _prefs.getInt(_connectionTimeoutKey) ?? 30;
  }

  /// Guardar Receive Timeout (em segundos)
  Future<void> saveReceiveTimeout(int seconds) async {
    await _prefs.setInt(_receiveTimeoutKey, seconds);
    if (kDebugMode) {
      print('✅ Receive Timeout guardado: ${seconds}s');
    }
  }

  /// Obter Receive Timeout (padrão: 30 segundos)
  int getReceiveTimeout() {
    return _prefs.getInt(_receiveTimeoutKey) ?? 30;
  }

  /// Limpar timeouts
  Future<void> clearTimeouts() async {
    await _prefs.remove(_connectionTimeoutKey);
    await _prefs.remove(_receiveTimeoutKey);
  }

  // ========== Token methods ==========
  
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  // ========== User methods ==========
  
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  Future<User?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // ========== Clear methods ==========
  
  /// Limpar dados de autenticação (token + user)
  Future<void> clearAuth() async {
    await clearToken();
    await clearUser();
  }

  /// Limpar todos os dados
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
