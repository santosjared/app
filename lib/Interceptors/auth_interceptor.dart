import 'dart:io';
import 'package:app/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthProvider authProvider;
  final GlobalKey<NavigatorState> navigatorKey;
  AuthInterceptor(this.dio, this.authProvider, this.navigatorKey);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = authProvider.token;
    if (accessToken != null) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      final refreshed = await authProvider.refresh();
      if (refreshed) {
        final options = err.requestOptions;
        options.headers["Authorization"] = "Bearer ${authProvider.token}";

        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.reject(e as DioException);
        }
      } else {
        if (authProvider.isAuthenticated) {
          authProvider.logout();
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            "/login",
            (route) => false,
          );
        }
      }
    }
    handler.next(err);
  }
}
