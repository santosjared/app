import 'package:app/models/login.dart';
import 'package:app/models/user_data.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/user_service.dart';
import 'package:app/utils/validator.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  _RegisterUserScreen createState() => _RegisterUserScreen();
}

class _RegisterUserScreen extends State<RegisterUserScreen> {
  final UserService registerService = UserService();
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool _obscureText = true;
  bool isError = false;
  String? forceErrorText;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _register() async {
    setState(() {
      isLoading = true;
    });
    forceErrorText = null;
    if (_formKey.currentState!.validate()) {
      bool existsEmail = await registerService.checkEmail(emailController.text);

      if (existsEmail) {
        forceErrorText = 'El Correo electrónico ya se encuentra registrado.';
        setState(() {
          isLoading = false;
        });
      } else {
        UserData user = UserData(
          name: nameController.text,
          lastName: lastnameController.text,
          email: emailController.text,
          phone: '+591${phoneController.text}',
          password: passwordController.text,
        );

        bool success = await registerService.register(user);

        if (success) {
          Login user = Login(
            email: emailController.text,
            password: passwordController.text,
          );
          bool isAutenticate = await authService.login(user, true);
          Navigator.pushReplacementNamed(
            context,
            isAutenticate ? '/' : '/login',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ha ocurrido un error al registrarse'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Registro de usuario', loading: isLoading),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                // Expande los campos de entrada para que los botones queden abajo
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          prefixIcon: Icon(Icons.person_4),
                        ),
                        validator: (value) {
                          String? error = Validator.validate(value, [
                            Validator.isRequired(
                              message: 'El campo Nombres es Requerido.',
                            ),
                            Validator.isString(
                              message:
                                  'El campo Nombres deber ser una cadena de caracteres.',
                            ),
                            Validator.matches(
                              RegExp(r'^[A-Za-z\s]+$'),
                              message:
                                  'El campo Nombres debe contener solo letras y espacio.',
                            ),
                            Validator.length(
                              4,
                              20,
                              message:
                                  'El campo Nombres debe ser como mínimo 4 y como máximo 20 caracteres.',
                            ),
                          ]);
                          return error;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: lastnameController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          prefixIcon: Icon(Icons.person_4),
                        ),
                        validator: (value) {
                          String? error = Validator.validate(value, [
                            Validator.isRequired(
                              message: 'El campo Apellidos es Requerido.',
                            ),
                            Validator.isString(
                              message:
                                  'El campo Apellidos deber ser una cadena de caracteres.',
                            ),
                            Validator.matches(
                              RegExp(r'^[A-Za-z\s]+$'),
                              message:
                                  'El campo Apellidos debe contener solo letras y espacio.',
                            ),
                            Validator.length(
                              4,
                              20,
                              message:
                                  'El campo Apellidos debe ser como mínimo 4 y como máximo 20 caracteres.',
                            ),
                          ]);
                          return error;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Número de celular',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          String? error = Validator.validate(value, [
                            Validator.isRequired(
                              message:
                                  'El campo Número de celular es Requerido.',
                            ),
                            Validator.matches(
                              RegExp(r'^\d+$'),
                              message: 'Debe introducir solo números',
                            ),
                            Validator.length(
                              6,
                              16,
                              message:
                                  'El campo Número de celular debe ser como mínimo 6 y como máximo 16 caracteres.',
                            ),
                          ]);
                          return error;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        forceErrorText: forceErrorText,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          String? error = Validator.validate(value, [
                            Validator.isRequired(
                              message:
                                  'El campo Correo electrónico es Requerido.',
                            ),
                            Validator.isString(
                              message:
                                  'El campo Correo electrónico deber ser una cadena de caracteres.',
                            ),
                            Validator.matches(
                              RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ),
                              message:
                                  'El campo Correo electrónico es de tipo email.',
                            ),
                            Validator.length(
                              8,
                              64,
                              message:
                                  'El campo Correo electrónico debe ser como mínimo 8 y como máximo 64 caracteres.',
                            ),
                          ]);
                          return error;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              // color: Palette.lightPrimary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureText,
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
                      SizedBox(height: 30),
                      if (isLoading) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              if (!isLoading)
                Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        icon: Icon(Icons.cancel),
                        label: Text('Cancelar'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _register,
                        icon: Icon(Icons.create),
                        label: Text('Crear cuenta'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
