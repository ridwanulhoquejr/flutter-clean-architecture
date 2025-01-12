import 'package:clean_architecture_with_bloc/features/todo/data/models/todo_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'todo_retrofit_client.g.dart';

@RestApi()
abstract class TodoRetroFitClient {
  factory TodoRetroFitClient(
    Dio dio,
  ) = _TodoRetroFitClient;

  @GET('/todos')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
    'Custom-Header': 'My custom header',
  })
  Future<List<TodoModel>> getTodos();
}
