import 'package:clean_architecture_with_bloc/features/todo/data/models/todo_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'todo_retrofit_client.g.dart';

@RestApi()
abstract class TodoRetroFitClient {
  factory TodoRetroFitClient(
    Dio dio, {
    String baseUrl,
  }) = _TodoRetroFitClient;

  @GET('/todos')
  Future<List<TodoModel>> getTodos();
}
