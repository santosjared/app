

import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final String path;
  const CustomAppbar({super.key, required this.title, required this.path});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: Color.fromARGB(255, 0, 142, 150),
        foregroundColor: Colors.white,
        leading: IconButton(
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