import 'package:clean_architecture_with_bloc/core/network/interceptors/api_interceptor.dart';
import 'package:clean_architecture_with_bloc/core/network/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  // dio client instance
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 45),
    ),
  )..interceptors.addAll(
      [
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
        ApiInterceptor(),
      ],
    );
}
