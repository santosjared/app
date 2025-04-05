import 'package:app/models/user_model.dart';

class RegisterUser extends UserModel {
  final String phone;
  final String password;

  RegisterUser({
    required this.phone,
    required this.password,
    required super.name,
    required super.email,
    required super.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
