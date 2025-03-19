import 'package:app/screens/complaints_screen.dart';
import 'package:app/screens/dashboard_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/register_user_screen.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> Routes(RouteSettings settings) {
    switch (settings.name) {
      case "/splash":
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case "/":
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case "/register":
        return MaterialPageRoute(builder: (_) => RegisterUserScreen());
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case "/complaints":
        return MaterialPageRoute(builder: (_) => ComplaintsScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  Scaffold(body: Center(child: Text("Página no encontrada"))),
        );
    }
  }
}
