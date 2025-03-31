import 'package:app/screens/send_to_code_screen.dart';
import 'package:app/services/send_email_service.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/sample_card.dart';
import 'package:flutter/material.dart';

class SendToEmailScreen extends StatefulWidget {
  const SendToEmailScreen({super.key});
  @override
  _SendToEmail createState() => _SendToEmail();
}

class _SendToEmail extends State<SendToEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final SendEmailService sendEmailService = SendEmailService();

  bool isLoading = false;
  bool isError = false;
  void _sendEmail() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    bool success = await sendEmailService.verifayEmail(emailController.text);

    setState(() {
      isLoading = false;
    });
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  const SendToCodeScreen(email: 'santosjared221234@gmail.com'),
        ),
      );
    } else {
      isError = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Recuperar Contraseña', path: '/login'),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (isError)
              Card.filled(
                color: const Color.fromARGB(
                  255,
                  254,
                  175,
                  175,
                ).withOpacity(0.6),
                child: SampleCard(cardName: 'Correo electrónico no registrado'),
              ),
            if (isError) const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                enabledBorder:
                    isError
                        ? OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                        )
                        : null,
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: const CircularProgressIndicator())
                : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sendEmail,
                        icon: Icon(Icons.navigate_next),
                        label: Text('Continuar'),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
