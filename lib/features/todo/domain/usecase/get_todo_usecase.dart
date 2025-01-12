import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/core/usecase/usecase.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/repository/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  GetAllTodos(this.repository);

  @override
  Future<Either<Failure, List<Todo>>> call(NoParams _) async {
    return await repository.getTodos();
  }
}

// if we have any params, we can pass it to the call method
// but need to create a class for the params
