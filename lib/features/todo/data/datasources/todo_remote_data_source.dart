import 'package:clean_architecture_with_bloc/core/error/exceptions.dart';
import 'package:clean_architecture_with_bloc/features/todo/data/datasources/todo_retrofit_client.dart';
import 'package:clean_architecture_with_bloc/features/todo/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final TodoRetroFitClient retroFitClient;

  TodoRemoteDataSourceImpl(this.retroFitClient);

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      return await retroFitClient.getTodos();
    } on Exception catch (e) {
      // our custom exception handler
      throw ServerException.handleException(e);
    }
  }
}
