class RegisterUser {
  final String name;
  final String lastName;
  final String email;
  final String ci;
  final String phone;
  final String contry;
  final String password;

  RegisterUser({
    required this.name,
    required this.lastName,
    required this.ci,
    required this.contry,
    required this.email,
    required this.phone,
    required this.password,
  });
}
