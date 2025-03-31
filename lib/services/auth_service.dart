import 'dart:convert';
import 'package:app/config/env_config.dart';
import 'package:app/storage/token_storage.dart';
import 'package:app/utils/http_code.dart';
import '../models/login.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = TokenStorage();

  Future<bool> login(Login user) async {
    try {
      var url = Uri.parse('${EnvConfig.apiUrl}/auth');

      // Realiza la solicitud POST con los datos correctos
      var response = await http.post(
        url,
        body: {
          'email': user.email,
          'password': user.password,
        }, // Usa los datos del usuario
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      await Future.delayed(Duration(seconds: 2));
      if (response.statusCode == HttpCode.OK) {
        print('Conexión exitosa');
        return true;
      } else {
        print('Error en la conexión. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Manejo de errores de conexión
      print('Error de conexión: $e');
      return false;
    }
  }

  Future<String?> ValidateAccessToken() async {
    String? accessToken = await _storage.getAccessToken();
    if (accessToken == null) {
      return await _refreshToken();
    }
    return accessToken;
  }

  Future<String?> _refreshToken() async {
    String? refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return null;

    var url = Uri.https(EnvConfig.apiUrl, 'whatsit/create');
    final response = await http.post(
      url,
      body: jsonEncode({'refreshToken': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == HttpCode.OK) {
      final data = jsonDecode(response.body);
      await _storage.saveToken(data['accessToken'], refreshToken);
      return data['accessToken'];
    } else {
      return null;
    }
  }
}
