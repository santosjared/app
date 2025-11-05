import 'package:app/config/env_config.dart';
import 'package:app/config/http.dart';
import 'package:app/models/user_data.dart';
import 'package:dio/dio.dart';
import '../models/login.dart';

class AuthService {
  static Future<Map<dynamic, dynamic>?> login(Login login) async {
    try {
      final response = await dio.post(
        '${EnvConfig.apiUrl}/auth',
        data: login.toJson(),
      );
      return response.data;
    } catch (e) {
      _handleErrors(e);
      return null;
    }
  }

  static Future<Map<dynamic, dynamic>?> refreshToken(String token) async {
    final Dio plainDio = Dio();

    try {
      final response = await plainDio.post(
        '${EnvConfig.apiUrl}/auth/refresh-token',
        data: {'token': token},
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      return response.data;
    } catch (e) {
      _handleErrors(e);
      return null;
    }
  }

  static Future<bool> logout(String id) async {
    try {
      final response = await dio.delete('${EnvConfig.apiUrl}/auth/logout/$id');
      print(response.data);
      print(response.statusCode);
      return true;
    } catch (e) {
      _handleErrors(e);
      return false;
    }
  }

  Future<UserData?> resetPassword(String token, String password) async {
    try {
      final response = await dio.put(
        '/auth/reset-password',
        data: {'token': token, 'password': password},
      );

      await Future.delayed(Duration(seconds: 2));
      return UserData.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  }

  static _handleErrors(e) {
    if (e is DioException) {
      print('⚠️ DioException:');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Request: ${e.requestOptions}');
    } else {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        print('Sin conexión a internet');
      }
      print('❌ Otro error: $e');
    }
  }
}
