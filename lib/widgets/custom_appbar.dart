import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String path;
  final bool loading;
  const CustomAppbar({
    super.key,
    required this.title,
    required this.path,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      backgroundColor: Color.fromARGB(255, 0, 142, 150),
      foregroundColor: Colors.white,
      leading:
          loading
              ? null
              : IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, path);
                },
                icon: Icon(Icons.navigate_before),
              ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
