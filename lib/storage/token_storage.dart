import 'package:app/constants/extencion_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _storage = FlutterSecureStorage();
  static Future<void> saveToken(String refreshToken) async {
    await _storage.write(key: Token.refresh.token, value: refreshToken);
  }

  static Future<String?> getRefreshToken() async =>
      await _storage.read(key: Token.refresh.token);
  static Future<void> removeRefreshToken() async =>
      await _storage.delete(key: Token.refresh.token);
}
