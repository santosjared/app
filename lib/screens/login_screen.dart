import 'package:app/screens/dashboard_screen.dart';
import 'package:app/screens/send_to_email_screen.dart';
import 'package:app/services/facebook_auth_service.dart';
import 'package:app/services/google_auth_service.dart';
// import 'package:app/services/twitter_auth_service.dart';
import 'package:app/widgets/custom_divider.dart';
import 'package:app/widgets/sample_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/login.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool isLoading = false;
  bool _obscureText = true;
  bool isError = false;

  void _login() async {
    isError = false;
    setState(() {
      isLoading = true;
    });

    Login user = Login(
      email: emailController.text,
      password: passwordController.text,
    );

    bool success = await authService.login(user);

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      isError = true;
    }
  }

  Future<void> loginWithGoogle() async {
    final token = await GoogleAuthService().signInWithGoogle();
    if (token != null) {
      await sendTokenToBackend(token);
    }
  }

  Future<void> loginWithFacebook() async {
    final token = await FacebookAuthService().signInWithFacebook();
    if (token != null) {
      await sendTokenToBackend(token);
    }
  }

  Future<void> loginWithTwitter() async {
    // final token = await TwitterAuthService().signInWithTwitter();
    // if (token != null) {
    //   await sendTokenToBackend(token);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección del título
                Center(
                  child: Text(
                    'BIENVENIDO A RADIO PATRULLA 110 POTOSÍ - BOLIVIA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      // color: Palette.lightPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Denuncia cualquier hecho delictivo de forma rápida y segura. '
                  'Nuestra plataforma está diseñada para brindarte un acceso directo a las autoridades.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    // color: Palette.lightPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (isError)
                  Card.filled(
                    color: const Color.fromARGB(
                      255,
                      254,
                      175,
                      175,
                      // ignore: deprecated_member_use
                    ).withOpacity(0.6),
                    child: SampleCard(
                      cardName: 'Correo electrónico o contraseña es incorrecto',
                    ),
                  ),
                if (isError) const SizedBox(height: 14.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.person),
                    enabledBorder:
                        isError
                            ? OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    enabledBorder:
                        isError
                            ? OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                            )
                            : null,
                  ),
                  obscureText: _obscureText,
                ),

                // Botón de login y enlaces adicionales
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text('Ingresar invitado'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SendToEmailScreen(),
                          ),
                        );
                      },
                      child: const Text('¿Olvidó su contraseña?'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child:
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: _login,
                            child: Text('Iniciar sesión'),
                          ),
                ),
                const SizedBox(height: 10),
                CustomDivider(text: 'o iniciar sesión con'),
                const SizedBox(height: 10),

                // Botones de redes sociales
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: loginWithGoogle,
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: loginWithFacebook,
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: loginWithTwitter,
                      icon: const FaIcon(FontAwesomeIcons.xTwitter),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Enlace de registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tiene una cuenta?',
                      style: TextStyle(
                        fontSize: 15,
                        // color: Palette.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text('Registrarse'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendTokenToBackend(String token) {}
}
