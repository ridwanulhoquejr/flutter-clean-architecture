import 'package:dio/dio.dart' show DioException;

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(
    this.message, {
    this.statusCode,
  });

  factory ServerException.fromDioException(DioException e) {
    return ServerException(
      e.message ?? e.error.toString(),
      statusCode: e.response?.statusCode,
    );
  }

  factory ServerException.fromException(Exception e) {
    return ServerException(e.toString());
  }

  factory ServerException.handleException(dynamic e) {
    if (e is DioException) {
      return ServerException.fromDioException(e);
    } else if (e is Exception) {
      return ServerException.fromException(e);
    } else {
      return const ServerException('Something went wrong!');
    }
  }
}
