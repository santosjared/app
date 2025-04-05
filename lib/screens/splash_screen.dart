import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService auth = AuthService();
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  void _initApp() async {
    bool access = await auth.ValidateAccessToApp();
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacementNamed(context, access ? '/' : '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
