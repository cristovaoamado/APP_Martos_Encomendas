import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/models/user.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  final SharedPreferences _prefs;

  // Construtor que recebe SharedPreferences
  StorageService(this._prefs);

  // Token methods
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  // User methods
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

  // Clear auth data (token + user)
  Future<void> clearAuth() async {
    await clearToken();
    await clearUser();
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
