import 'package:app/config/env_config.dart';
import 'package:app/utils/http_code.dart';
import 'package:http/http.dart' as http;

class SendEmailService {
  Future<bool> verifayEmail(String email) async {
    try {
      var url = Uri.parse('${EnvConfig.apiUrl}/verifayEmail');

      var response = await http.post(url, body: {'email': email});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      await Future.delayed(Duration(seconds: 2));
      if (response.statusCode == HttpCode.OK) {
        return true;
      } else {
        return true;
      }
    } catch (e) {
      print('Error de Conexion: $e');
      return true;
    }
  }
}
