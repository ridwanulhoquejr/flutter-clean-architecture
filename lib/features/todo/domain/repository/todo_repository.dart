import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TodoRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
}
