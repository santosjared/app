import 'package:app/screens/reset_password_screen.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class SendToCodeScreen extends StatefulWidget {
  final String email;
  const SendToCodeScreen({super.key, required this.email});
  @override
  _sendToCode createState() => _sendToCode(email);
}

class _sendToCode extends State<SendToCodeScreen> {
  final String email;
  _sendToCode(this.email);

  final TextEditingController codeController = TextEditingController();

  void _sendCode() async {
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
    );
  }

  String obfuscateEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].length < 3) {
      return 'Correo no válido';
    }
    final username = parts[0];
    final domain = parts[1];

    final textStart = username.substring(0, 4);
    final textEnd = username.substring(username.length - 2);
    String obfuscated = '';

    for (int i = 4; i < username.length - 2; i++) {
      obfuscated += '*';
    }
    return '$textStart$obfuscated$textEnd@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Recuperar Contraseña',
        path: '/send_to_email',
      ),
      body: SingleChildScrollView(
        // Agregamos SingleChildScrollView
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: 'Código de verificación'),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text:
                    'Se ha enviado un código de verificación al correo electrónico ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: obfuscateEmail(email),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text:
                        ', ve a tu correo electrónico y ingresa el código de verificación',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: Icon(Icons.send),
                  label: Text('Volver a Enviar'),
                ),
                ElevatedButton.icon(
                  onPressed: _sendCode,
                  icon: Icon(Icons.check),
                  label: Text('Verificar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
