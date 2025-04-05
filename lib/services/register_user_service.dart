import 'dart:io';
import 'package:app/config/http.dart';
import 'package:app/models/register_user.dart';

class RegisterUserService {
  Future<bool> register(RegisterUser user) async {
    try {
      final response = await dio.post('/clients', data: user.toJson());

      if (response.statusCode == HttpStatus.created) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkEmail(String email) async {
    try {
      final response = await dio.get('/clients/check-email/$email');
      if (response.statusCode == HttpStatus.ok) {
        return response.data['result'];
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
