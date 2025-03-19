import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final String? isAuthenticated = await AuthService().ValidateAccessToken();

    await Future.delayed(Duration(seconds: 2)); // Simula carga

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        isAuthenticated == null ? "/login" : "/",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
