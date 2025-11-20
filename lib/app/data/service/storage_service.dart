import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  static const String _authTokenKey = 'auth_token';

  /// Inisialisasi service untuk mendapatkan instance SharedPreferences.
  /// Panggil ini di main.dart sebelum Get.put()
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // --- Manajemen Token ---

  Future<void> saveToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
    if (kDebugMode) print('💾 Token saved');
  }

  Future<String?> getToken() async {
    return _prefs.getString(_authTokenKey);  
  }

  Future<void> clearToken() async {
    await _prefs.remove(_authTokenKey);
    if (kDebugMode) print('🗑 Token cleared');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}