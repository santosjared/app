import 'dart:io';
import 'package:app/config/http.dart';
import 'package:app/models/user_data.dart';

class UserService {
  Future<bool> register(UserData user) async {
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

  Future<UserData?> getUserData(String email) async {
    try {
      final response = await dio.get('/clients/$email');
      if (response.statusCode == HttpStatus.ok) {
        return UserData.fromJson(response.data['result']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateUserData(UserData user) async {
    try {
      print(user.toJson());
      final response = await dio.put(
        '/clients/${user.id}',
        data: user.toJson(),
      );
      if (response.statusCode == HttpStatus.ok) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
