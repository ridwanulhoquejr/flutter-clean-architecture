import 'package:clean_architecture_with_bloc/core/utils/colored_logger.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor() : super();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add headers fro all requests
    options.headers.addAll({
      "System-key": "Hello this is system key",
      "App-Language": "en",
      "Content-Type": "application/json",
    });

    ColoredLogger.White.log('Initial headers: ${options.headers}');
    return handler.next(options);
  }
}

//custom extension for showing the origin, host
extension RequestOptionsToStringX on RequestOptions {
  String toCustomString() {
    return 'method: $method, path: $path, origin: ${headers["Origin"]}, host: ${headers["Host"]}';
  }
}
