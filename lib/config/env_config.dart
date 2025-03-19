import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String apiUrl = dotenv.env['API_URL'] ?? 'https://default-api.com';
}
