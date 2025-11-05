import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app/providers/auth_provider.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthProvider authProvider;
  final GlobalKey<NavigatorState> navigatorKey;

  bool _isRefreshing = false;
  final List<QueuedRequest> _queue = [];

  AuthInterceptor(this.dio, this.authProvider, this.navigatorKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = authProvider.token;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == HttpStatus.unauthorized;
    final isLoginRequest = err.requestOptions.path.contains('/login');
    final isRefreshRequest = err.requestOptions.path.contains('/refresh-token');

    final hasRetried = err.requestOptions.extra['isRetry'] == true;

    if (isUnauthorized && !isLoginRequest && !isRefreshRequest && !hasRetried) {
      final originalRequest = err.requestOptions;
      originalRequest.extra['isRetry'] = true;

      final completer = Completer<Response>();
      _queue.add(
        QueuedRequest(requestOptions: originalRequest, completer: completer),
      );

      if (!_isRefreshing) {
        _isRefreshing = true;

        final success = await authProvider.refresh();

        _isRefreshing = false;
        if (success) {
          final newToken = authProvider.token;
          _processQueue(null, newToken);
        } else {
          _processQueue(err, null);
          if (authProvider.isAuthenticated) {
            authProvider.logout();
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        }
      }

      try {
        final response = await completer.future;
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(e as DioException);
      }
    }

    handler.next(err);
  }

  void _processQueue(DioException? error, String? token) {
    for (var item in _queue) {
      if (error != null || token == null) {
        item.completer.completeError(
          error ??
              DioException(
                requestOptions: item.requestOptions,
                error: 'Token refresh failed',
              ),
        );
      } else {
        final options = item.requestOptions;
        options.headers['Authorization'] = 'Bearer $token';

        dio
            .fetch(options)
            .then(
              (r) => item.completer.complete(r),
              onError: (e) => item.completer.completeError(e),
            );
      }
    }
    _queue.clear();
  }
}

class QueuedRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  QueuedRequest({required this.requestOptions, required this.completer});
}
