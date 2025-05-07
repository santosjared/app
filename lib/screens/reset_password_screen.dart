import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repitPasswordController = TextEditingController();
  bool obscurenew = true;
  bool obscurerepit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Recuperar contraseña', loading: false),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start, // Alineación de los elementos a la izquierda
          children: [
            SizedBox(height: 5),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurenew = !obscurenew;
                    });
                  },
                  icon: Icon(
                    obscurenew ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: obscurenew,
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: repitPasswordController,
              decoration: InputDecoration(
                labelText: 'Repita la contraseña',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurerepit = !obscurerepit;
                    });
                  },
                  icon: Icon(
                    obscurerepit ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: obscurerepit,
            ),
            SizedBox(height: 10),
            Container(
              width:
                  double.infinity, // El botón ocupará todo el ancho disponible
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Establecer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
