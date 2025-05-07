import 'dart:io';
import 'package:app/config/env_config.dart';
import 'package:app/config/http.dart';
import 'package:app/constants/extencion_token.dart';
import 'package:app/storage/token_storage.dart';
import 'package:app/storage/user_storage.dart';
import '../models/login.dart';

class AuthService {
  Future<bool> login(Login login, bool remeberme) async {
    try {
      var response = await dio.post(
        '${EnvConfig.apiUrl}/auth',
        data: login.toJson(),
      );

      if (remeberme) {
        TokenStorage.saveToken(
          response.data[Token.access.token],
          response.data[Token.refresh.token],
        );
      }
      final userData = response.data['userData'] ?? {};
      UserStorage.saveUser(userData);
      return true;
    } catch (e) {
      TokenStorage.removeAccessToken();
      TokenStorage.removeRefreshToken();
      UserStorage.removeUser();
      return false;
    }
  }

  Future<bool> ValidateAccessToApp() async {
    String? accessToken = await TokenStorage.getAccessToken();
    if (accessToken != null) {
      return await RefreshToken();
    }
    return false;
  }

  Future<bool> RefreshToken() async {
    try {
      String? refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await dio.post(
        '${EnvConfig.apiUrl}/auth/refresh-token',
        data: {'token': refreshToken},
      );

      print(response.statusCode);
      print(response.data);
      if (response.statusCode == HttpStatus.created) {
        await TokenStorage.saveToken(
          response.data[Token.access.token],
          response.data[Token.access.token],
        );
        final userData = response.data['userData'] ?? {};
        UserStorage.saveUser(userData);
        return true;
      }
      return false;
    } catch (e) {
      print('error en refreshToken: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      TokenStorage.removeAccessToken();
      TokenStorage.removeRefreshToken();
      UserStorage.removeUser();
    } catch (e) {
      print(e);
    }

    return true;
  }
}
