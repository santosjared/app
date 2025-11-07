import 'package:app/models/complaints_client_model.dart';
import 'package:app/models/complaints_model.dart';
import 'package:app/models/previa_model.dart';
import 'package:app/screens/complaints_screen.dart';
import 'package:app/screens/emergency_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/screens/previa_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/register_user_screen.dart';
import 'package:app/screens/reset_password_screen.dart';
import 'package:app/screens/send_to_code_screen.dart';
import 'package:app/screens/send_to_email_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/dashboard_screen.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case "/Dashboard":
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case "/register":
        return MaterialPageRoute(builder: (_) => RegisterUserScreen());
      case "/emergency":
        return MaterialPageRoute(builder: (_) => EmergencyScreen());
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case "/send-email":
        return MaterialPageRoute(builder: (_) => SendToEmailScreen());
      case "/send-code":
        final args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => SendToCodeScreen(email: args));
      case "/reset-password":
        final ars = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(token: ars),
        );
      case "/complaints":
        final args = settings.arguments as ComplaintsModel?;
        return MaterialPageRoute(
          builder: (_) => ComplaintsScreen(complaint: args),
        );

      case "/profile":
        final args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ProfileScreen(email: args));
      case "/previa":
        final args = settings.arguments as Map<String, dynamic>;
        final PreviaModel complaint = args['complaint'];
        final String title = args['title'];
        return MaterialPageRoute(
          builder: (_) => PreviaScreen(data: complaint, title: title),
        );
      case "/loadingcomplaints":
        final args = settings.arguments as ComplaintsClientModel;
        return MaterialPageRoute(builder: (_) => LoadingPage(complaints: args));
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  Scaffold(body: Center(child: Text("Página no encontrada"))),
        );
    }
  }
}
