import 'package:app/config/http.dart';

class SendCodeService {
  Future<String?> verifayCode(String email, String code) async {
    try {
      final response = await dio.post(
        '/clients/verifay-code',
        data: {'email': email, 'code': code},
      );

      await Future.delayed(Duration(seconds: 2));
      return response.data['token'];
    } catch (e) {
      print('Error de Conexion: $e');

      return null;
    }
  }
}
