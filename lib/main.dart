import 'package:app/Interceptors/auth_interceptor.dart';
import 'package:app/config/http.dart';
import 'package:app/constants/mode.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/routes/app_routes.dart';
import 'package:app/theme/custom_theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    dio.interceptors.clear();
    dio.interceptors.add(LogInterceptor());
    dio.interceptors.add(AuthInterceptor(dio, authProvider, navigatorKey));

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Radio Patrulla 110',
      theme: CustomTheme().settingsTheme(Mode.lightMode),
      darkTheme: CustomTheme().settingsTheme(Mode.darkMode),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.routes,
    );
  }
}
