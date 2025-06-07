import 'package:app/models/login.dart';
import 'package:app/models/user_data.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/validator.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});
  @override
  State<ResetPasswordScreen> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPasswordScreen> {
  final AuthService authService = AuthService();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repitPasswordController = TextEditingController();
  bool _obscurenew = true;
  bool _obscurerepit = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        _isLoading = true;
      });
      final UserData? data = await authService.resetPassword(
        widget.token,
        newPasswordController.text,
      );
      if (data != null) {
        Login user = Login(
          email: data.email,
          password: newPasswordController.text,
        );
        bool isAutenticate = await authProvider.login(user, true);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, isAutenticate ? '/' : '/login');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ha ocurrido un error al resetear la contraseña'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Recuperar contraseña', loading: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurenew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurenew = !_obscurenew;
                      });
                    },
                  ),
                ),
                obscureText: _obscurenew,
                validator: (value) {
                  String? error = Validator.validate(value, [
                    Validator.isRequired(
                      message: 'El campo Contraseña es Requerido.',
                    ),
                    Validator.isString(
                      message:
                          'El campo Contraseña deber ser una cadena de caracteres.',
                    ),
                    Validator.length(
                      8,
                      32,
                      message:
                          'El campo Contraseña debe ser como mínimo 8 y como máximo 32 caracteres.',
                    ),
                  ]);
                  return error;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: repitPasswordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurerepit ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurerepit = !_obscurerepit;
                      });
                    },
                  ),
                ),
                obscureText: _obscurerepit,
                validator: (value) {
                  String? error = Validator.validate(value, [
                    Validator.isRequired(
                      message: 'El campo Contraseña es Requerido.',
                    ),
                    Validator.isString(
                      message:
                          'El campo Contraseña deber ser una cadena de caracteres.',
                    ),
                    Validator.length(
                      8,
                      32,
                      message:
                          'El campo Contraseña debe ser como mínimo 8 y como máximo 32 caracteres.',
                    ),
                  ]);
                  if (error == null && value != newPasswordController.text) {
                    return 'Las contraseñas no coinciden.';
                  }
                  return error;
                },
              ),
              SizedBox(height: 10),
              _isLoading
                  ? Center(child: const CircularProgressIndicator())
                  : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text('Establecer'),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
