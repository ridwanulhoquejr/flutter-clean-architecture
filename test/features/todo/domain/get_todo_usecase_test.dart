import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/core/usecase/usecase.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/repositories/todo_repository.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/usecases/get_todo_usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hand-rolled fake — keeps the test dependency-free (no mocktail/codegen).
class _FakeTodoRepository implements TodoRepository {
  _FakeTodoRepository(this._result);
  final Either<Failure, List<Todo>> _result;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async => _result;
}

void main() {
  const tTodos = [
    Todo(userId: 1, id: 1, title: 'first', completed: false),
  ];

  test('returns todos from the repository on success', () async {
    final useCase = GetAllTodos(_FakeTodoRepository(const Right(tTodos)));

    final result = await useCase(NoParams());

    expect(result, const Right<Failure, List<Todo>>(tTodos));
  });

  test('forwards a failure from the repository', () async {
    const failure = ServerFailure('boom', 500);
    final useCase = GetAllTodos(_FakeTodoRepository(const Left(failure)));

    final result = await useCase(NoParams());

    expect(result, const Left<Failure, List<Todo>>(failure));
  });
}
