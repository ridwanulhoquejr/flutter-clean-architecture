import 'package:equatable/equatable.dart';

/// Base failure type returned across the domain boundary.
///
/// Sealed so callers can exhaustively switch on the concrete kind, and
/// [Equatable] so bloc states comparing failures behave correctly.
sealed class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

/// A remote/server-side failure. Carries the HTTP status code when known.
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure([super.message, this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

/// No network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Not connected to a network!']);
}
