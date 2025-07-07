import 'package:app/models/user_model.dart';

class UserData extends UserModel {
  final String phone;
  final String? password;
  final String? id;
  final String? provider;

  UserData({
    required this.phone,
    this.password,
    this.id,
    required super.name,
    required super.email,
    required super.lastName,
    this.provider,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      id: json['_id'] ?? '',
      provider: json['provider'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
    };

    if (password != null) {
      data['password'] = password!;
    }

    return data;
  }
}
