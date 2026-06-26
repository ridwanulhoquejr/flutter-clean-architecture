import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/usecases/get_todo_usecase.dart';
import 'package:clean_architecture_with_bloc/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTodoRepository implements TodoRepository {
  _FakeTodoRepository(this._result);
  final Either<Failure, List<Todo>> _result;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async => _result;
}

void main() {
  const tTodos = [Todo(userId: 1, id: 1, title: 'first', completed: false)];

  blocTest<TodoBloc, TodoState>(
    'emits [InProgress, Success] when todos load',
    build: () => TodoBloc(
      getTodo: GetAllTodos(_FakeTodoRepository(const Right(tTodos))),
    ),
    act: (bloc) => bloc.add(TodoGetPressed()),
    expect: () => [
      isA<TodoLoadInProgress>(),
      isA<TodoLoadSuccess>(),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'emits [InProgress, Failure] when the repository fails',
    build: () => TodoBloc(
      getTodo: GetAllTodos(
        _FakeTodoRepository(const Left(ServerFailure('boom', 500))),
      ),
    ),
    act: (bloc) => bloc.add(TodoGetPressed()),
    expect: () => [
      isA<TodoLoadInProgress>(),
      isA<TodoLoadFailure>(),
    ],
  );
}
