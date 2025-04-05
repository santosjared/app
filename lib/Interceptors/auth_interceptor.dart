import 'dart:io';

import 'package:app/services/auth_service.dart';
import 'package:app/storage/token_storage.dart';
import 'package:app/storage/user_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthService authService = AuthService();
  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken != null) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      print("Token expirado. Intentando refrescar...");
      final refreshed = await authService.RefreshToken();
      if (refreshed) {
        print("Token refrescado. Reintentando solicitud...");
        final options = err.requestOptions;
        options.headers["Authorization"] =
            "Bearer ${await TokenStorage.getAccessToken()}";

        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(e as DioException);
        }
      } else {
        print("No se pudo refrescar el token. Redirigiendo al login...");
        await TokenStorage.removeAccessToken();
        await TokenStorage.removeRefreshToken();
        await UserStorage.removeUser();
      }
    }
    handler.next(err);
  }
}
