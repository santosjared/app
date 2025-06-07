import 'package:app/services/send_email_service.dart';
import 'package:app/utils/validator.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/sample_card.dart';
import 'package:flutter/material.dart';

class SendToEmailScreen extends StatefulWidget {
  const SendToEmailScreen({super.key});
  @override
  State<SendToEmailScreen> createState() => _SendToEmail();
}

class _SendToEmail extends State<SendToEmailScreen> {
  final TextEditingController emailController = TextEditingController();
  final SendEmailService sendEmailService = SendEmailService();

  bool isLoading = false;
  bool isError = false;

  final _formKey = GlobalKey<FormState>();

  void _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        isError = false;
      });

      bool success = await sendEmailService.verifayEmail(emailController.text);
      setState(() {
        isLoading = false;
      });
      if (success) {
        if (!mounted) return;
        Navigator.pushNamed(
          context,
          '/send-code',
          arguments: emailController.text,
        );
      } else {
        setState(() {
          isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Recuperar Contraseña', loading: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (isError)
                Card.filled(
                  color: const Color.fromARGB(
                    255,
                    254,
                    175,
                    175,
                  ).withOpacity(0.6),
                  child: SampleCard(
                    cardName: 'Correo electrónico no registrado',
                  ),
                ),
              if (isError) const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  enabledBorder:
                      isError
                          ? OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          )
                          : null,
                ),
                validator: (value) {
                  String? error = Validator.validate(value, [
                    Validator.isRequired(
                      message: 'El campo Correo electrónico es Requerido.',
                    ),
                    Validator.isString(
                      message:
                          'El campo Correo electrónico deber ser una cadena de caracteres.',
                    ),
                    Validator.matches(
                      RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ),
                      message: 'El campo Correo electrónico es de tipo email.',
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
      ),
    );
  }
}
