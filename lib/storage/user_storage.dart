import 'package:app/constants/users.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserStorage {
  static final _storage = FlutterSecureStorage();
  static Future<void> saveUser(Object? user) async {
    String value = jsonEncode(user);
    await _storage.write(key: UserConstants.userData.value, value: value);
  }

  static Future<String?> getUser() async =>
      await _storage.read(key: UserConstants.userData.value);
  static Future<void> removeUser() async =>
      await _storage.delete(key: UserConstants.userData.value);
}
