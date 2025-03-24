import 'package:app/models/register_user.dart';
import 'package:app/screens/dashboard_screen.dart';
import 'package:app/services/register_user_service.dart';
import 'package:app/widgets/custom_input.dart';
import 'package:flutter/material.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterUserScreen createState() => _RegisterUserScreen();
}

class _RegisterUserScreen extends State<RegisterUserScreen> {
  final RegisterUserService registerService = RegisterUserService();
  bool isLoading = false;
  bool _obscureText = true;
  bool isError = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ciController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController contryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register() async {
    setState(() {
      isLoading = true;
    });
    RegisterUser user = RegisterUser(
      name: nameController.text,
      lastName: lastnameController.text,
      ci: ciController.text,
      contry: contryController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
    );

    bool success = await registerService.register(user);

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
        backgroundColor: Color.fromARGB(255, 0, 142, 150),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: Icon(Icons.navigate_before),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              // Expande los campos de entrada para que los botones queden abajo
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomInputField(
                      labelText: 'Nombres',
                      controller: nameController,
                      prefixIcon: Icon(Icons.person_4),
                    ),
                    CustomInputField(
                      labelText: 'Apellidos',
                      controller: lastnameController,
                      prefixIcon: Icon(Icons.person_4),
                    ),
                    CustomInputField(
                      labelText: 'Ci o pasaporte',
                      controller: ciController,
                      prefixIcon: Icon(Icons.sticky_note_2),
                    ),
                    CustomInputField(
                      labelText: 'Número de celular',
                      controller: phoneController,
                      prefixIcon: Icon(Icons.phone),
                    ),
                    CustomInputField(
                      labelText: 'País',
                      controller: contryController,
                      prefixIcon: Icon(Icons.flag_rounded),
                    ),
                    CustomInputField(
                      labelText: 'Correo',
                      controller: emailController,
                      prefixIcon: Icon(Icons.email),
                    ),
                    CustomInputField(
                      labelText: 'Contraseña',
                      controller: passwordController,
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
                      obscureText: _obscureText,
                    ),
                  ],
                ),
              ),
            ),
            // Botones fijos abajo
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
    );
  }
}
