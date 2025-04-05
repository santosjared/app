import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _lastname = '';
  String _email = '';

  String get username => _username;
  String get lastname => _lastname;
  String get email => _email;

  void setUserData(UserModel user) {
    _username = user.name;
    _lastname = user.lastName;
    _email = user.email;
    notifyListeners();
  }
}
