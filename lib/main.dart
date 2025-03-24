import 'package:app/constants/mode.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/theme/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radio Patrulla 110',
      theme: CustomTheme().settingsTheme(Mode.lightMode),
      darkTheme: CustomTheme().settingsTheme(Mode.darkMode),
      themeMode: ThemeMode.system,
      initialRoute: "/splash", // Comienza con SplashScreen
      onGenerateRoute: AppRoutes.Routes,
    );
  }
}
