import 'package:app/constants/extencion_token.dart';
import 'package:app/models/login.dart';
import 'package:app/models/user_data.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/google_auth_service.dart';
import 'package:app/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  String? _refreshToken;
  UserData? _user;
  bool _rememberMe = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  UserData? get user => _user;
  bool get rememberMe => _rememberMe;
  String? get error => _error;

  Future<bool> login(Login login, bool rememberMe) async {
    final response = await AuthService.login(login);
    if (response != null) {
      _token = response[Token.access.token];
      _refreshToken = response[Token.refresh.token];
      _user = UserData.fromJson(response['user']);
      _isAuthenticated = true;
      _rememberMe = rememberMe;

      if (rememberMe) {
        await TokenStorage.saveToken(_refreshToken ?? '');
        // await UserStorage.saveUser(response['userData']);
      }

      notifyListeners();
      return true;
    } else {
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> refresh() async {
    String? tokenTem = refreshToken ?? await TokenStorage.getRefreshToken();

    if (tokenTem != null) {
      final response = await AuthService.refreshToken(tokenTem);
      if (response != null) {
        _token = response[Token.access.token];
        _refreshToken = response[Token.refresh.token];
        _isAuthenticated = true;
        _user = UserData.fromJson(response['user']);

        if (rememberMe) {
          await TokenStorage.saveToken(_refreshToken ?? '');
        }

        notifyListeners();
        return true;
      }
      return false;
    }

    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  Future<bool> logout() async {
    await TokenStorage.removeRefreshToken();
    _token = null;
    _refreshToken = null;
    _rememberMe = false;
    _error = null;
    _isAuthenticated = false;
    if (_user?.provider == 'google') {
      try {
        await GoogleSignIn().signOut();
      } catch (e) {
        print('Error cerrando sesión de Google: $e');
      }
    }
    final logout = await AuthService.logout(_user?.id ?? '');
    _user = null;
    notifyListeners();
    return logout;
  }

  void setUser(UserData? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> authGoogle(bool rememberMe) async {
    final response = await GoogleAuthService.signInWithGoogle();

    if (response == null) {
      _error = "No response from Google Sign-In.";
      notifyListeners();
      return false;
    }

    if (response.containsKey('error')) {
      _error = response['error'];
      notifyListeners();
      return false;
    }

    if (response.containsKey(Token.access.token) &&
        response.containsKey(Token.refresh.token) &&
        response.containsKey('user')) {
      _token = response[Token.access.token];
      _refreshToken = response[Token.refresh.token];
      _user = UserData.fromJson(response['user']);
      _isAuthenticated = true;
      _rememberMe = rememberMe;
      if (rememberMe) {
        await TokenStorage.saveToken(_refreshToken!);
      }

      notifyListeners();
      return true;
    }

    _error = "Invalid response structure.";
    notifyListeners();
    return false;
  }
}
