import 'package:app/constants/mode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = FlutterSecureStorage();
  Future<void> saveToken(String accessToken, String refreshToken) async {
    await _storage.write(key: Token.access.token, value: accessToken);
    await _storage.write(key: Token.refresh.token, value: refreshToken);
  }

  Future<String?> getAccessToken() async =>
      await _storage.read(key: Token.access.token);
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: Token.refresh.token);
}
