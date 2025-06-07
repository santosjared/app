import 'dart:async';

import 'package:app/services/send_code_service.dart';
import 'package:app/services/send_email_service.dart';
import 'package:app/utils/validator.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/sample_card.dart';
import 'package:flutter/material.dart';

class SendToCodeScreen extends StatefulWidget {
  final String email;
  const SendToCodeScreen({super.key, required this.email});
  @override
  State<SendToCodeScreen> createState() => _SendToCode();
}

class _SendToCode extends State<SendToCodeScreen> {
  final SendCodeService sendCodeService = SendCodeService();
  final SendEmailService sendEmailService = SendEmailService();

  final TextEditingController codeController = TextEditingController();

  bool _isLoading = false;
  bool _error = false;
  int _resendCooldown = 0;
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;

  void _startCooldownTimer() {
    setState(() {
      _resendCooldown = 60;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCooldown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendCooldown--;
        });
      }
    });
  }

  void _resendEmail() async {
    if (_resendCooldown > 0) return;

    bool success = await sendEmailService.verifayEmail(widget.email);

    if (success) {
      _startCooldownTimer();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tenemos problemas al enviar el código al correo. Por favor, inténtelo más tarde.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  void _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = false;
      });
      String? token = await sendCodeService.verifayCode(
        widget.email,
        codeController.text,
      );

      setState(() {
        _isLoading = false;
      });
      if (token != null && mounted) {
        Navigator.pushNamed(context, '/reset-password', arguments: token);
      } else {
        setState(() {
          _error = true;
        });
      }
    }
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
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Recuperar Contraseña', loading: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              if (_error)
                Card.filled(
                  color: const Color.fromARGB(
                    255,
                    254,
                    175,
                    175,
                  ).withOpacity(0.6),
                  child: SampleCard(
                    cardName: 'Código de verificacion no válido',
                  ),
                ),
              if (_error) const SizedBox(height: 10),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Código de verificación',
                ),
                validator: (value) {
                  String? error = Validator.validate(value, [
                    Validator.matches(
                      RegExp(r'^[0-9]+$'),
                      message: 'Debe intruducir solo numeros',
                    ),
                    Validator.length(
                      6,
                      6,
                      message: 'Debe contener 6 digitos de numeros',
                    ),
                  ]);
                  return error;
                },
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text:
                      'Se ha enviado un código de verificación al correo electrónico ',
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: obfuscateEmail(widget.email),
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
              _isLoading
                  ? Center(child: const CircularProgressIndicator())
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _resendCooldown == 0 ? _resendEmail : null,
                        icon: Icon(Icons.send),
                        label: Text(
                          _resendCooldown == 0
                              ? 'Volver a Enviar'
                              : 'Reenviar en ${_resendCooldown}s',
                        ),
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
      ),
    );
  }
}
