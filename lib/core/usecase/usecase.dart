import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

// This is the abstract class that all use cases will implement
// It has two generic types, SuccessType and Params

// so in the domain layer, we should implement this interface for each use case

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
