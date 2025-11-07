import 'package:app/theme/custom_color.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppbar({super.key, required this.title});

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
            onPressed: () {
              Navigator.pushNamed(context, '/emergency');
            },
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
