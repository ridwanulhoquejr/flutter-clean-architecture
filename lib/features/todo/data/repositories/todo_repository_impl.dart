import 'package:clean_architecture_with_bloc/core/constants/constants.dart';
import 'package:clean_architecture_with_bloc/core/error/exceptions.dart';
import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/core/network/connection_checker.dart';
import 'package:clean_architecture_with_bloc/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/repository/todo_repository.dart';
import 'package:fpdart/fpdart.dart';

class TodoRepositoryImpl implements TodoRepository {
  // data soruce dependency
  final TodoRemoteDataSource todoRemoteDataSource;
  final ConnectionChecker connectionChecker;

  TodoRepositoryImpl(
    this.todoRemoteDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(const Failure(Constants.noConnectionErrorMessage));
      }
      final result = await todoRemoteDataSource.getTodos();
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
