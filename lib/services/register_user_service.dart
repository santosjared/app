import 'package:app/config/env_config.dart';
import 'package:app/models/register_user.dart';
import 'package:app/utils/http_code.dart';
import 'package:http/http.dart' as http;

class RegisterUserService {
  Future<bool> register(RegisterUser user) async {
    try {
      var url = Uri.parse('${EnvConfig.apiUrl}/clients');
      var response = await http.post(
        url,
        body: {
          'name': user.name,
          'lastName': user.lastName,
          'email': user.email,
          'phone': user.phone,
          'password': user.password,
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == HttpCode.OK) {
        print('Conexión exitosa');
        return true;
      } else {
        print('Error en la conexión. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Manejo de errores de conexión
      print('Error de conexión: $e');
      return false;
    }
  }
}
