import 'package:app/config/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:app/config/env_config.dart';

class GoogleAuthService {
  static Future<Map<dynamic, dynamic>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        print('No se pudo obtener el idToken de Google.');
        return {
          'error': 'No se pudo autenticar con Google. Inténtalo de nuevo.',
        };
      }
      final response = await dio.post(
        '${EnvConfig.apiUrl}/auth/google',
        data: {'token': idToken},
      );
      return response.data;
    } on FirebaseAuthException catch (e) {
      print('Error de Firebase: ${e.message}');
      return {
        'error':
            'Tenemos problemas con logueo por google porfavor intelos mas tarde.',
      };
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_failed' && e.message?.contains('10:') == true) {
        print(
          'Error de configuración: faltan las huellas SHA-1 en Firebase.\n'
          'Asegúrate de agregar el SHA-1 en la consola de Firebase.',
        );
      } else {
        print('Error de plataforma: ${e.message}');
      }
      return {
        'error':
            'Tenemos problemas con logueo por google porfavor intelos mas tarde.',
      };
    } catch (e) {
      print('Error inesperado: $e');
      return {
        'error':
            'Tenemos problemas con logueo por google porfavor intelos mas tarde.',
      };
    }
  }
}
