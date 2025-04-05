import 'package:app/constants/extencion_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _storage = FlutterSecureStorage();
  static Future<void> saveToken(String accessToken, String refreshToken) async {
    await _storage.write(key: Token.access.token, value: accessToken);
    await _storage.write(key: Token.refresh.token, value: refreshToken);
  }

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: Token.access.token);
  static Future<String?> getRefreshToken() async =>
      await _storage.read(key: Token.refresh.token);
  static Future<void> removeAccessToken() async =>
      await _storage.delete(key: Token.access.token);
  static Future<void> removeRefreshToken() async =>
      await _storage.delete(key: Token.refresh.token);
}
