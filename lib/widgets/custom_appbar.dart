import 'package:app/config/whatsapp_config.dart';
import 'package:app/services/whatsapp_service.dart';
import 'package:app/theme/custom_color.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppbar({super.key, required this.title});

  void _openWhatsapp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    bool success = await WhatsappService.openWhatsApp(
      WhatsappConfig.phone,
      message: WhatsappConfig.message,
    );

    if (!success) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Tenemos problemas al abrir WhatsApp. Por favor, intente más tarde.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = CustomColor.of(context);

    return AppBar(
      title: const Text('Inicio'),
      backgroundColor: colors.primary.main,
      foregroundColor: colors.primary.contrastText,
      shadowColor: Colors.black,
      actions: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () => _openWhatsapp(context),
            style: ElevatedButton.styleFrom(backgroundColor: colors.error.main),
            child: Text('Emergecia'),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
