import 'package:app/config/http.dart';

class SendEmailService {
  Future<bool> verifayEmail(String email) async {
    try {
      final response = await dio.post(
        '/clients/verifay-email',
        data: {'email': email},
      );

      await Future.delayed(Duration(seconds: 2));
      return response.data.toString().toLowerCase() == 'true';
    } catch (e) {
      print('Error de Conexion: $e');

      return false;
    }
  }
}
