import 'package:clean_architecture_with_bloc/core/network/interceptors/api_interceptor.dart';
import 'package:clean_architecture_with_bloc/core/network/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Builds the app's [Dio] instance.
///
/// Exposed as a factory ([create]) instead of a static singleton so it can be
/// registered in the service locator and swapped/mocked in tests.
class DioClient {
  const DioClient._();

  static Dio create({
    String baseUrl = 'https://jsonplaceholder.typicode.com',
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
        sendTimeout: const Duration(seconds: 45),
      ),
    );

    dio.interceptors.add(ApiInterceptor());

    // Verbose request/response (incl. headers, which may carry auth tokens)
    // only in debug builds — never leak them in release logs.
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  }
}
