import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/core/usecase/usecase.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/usecase/get_todo_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetAllTodos _getAllTodo;

  TodoBloc({
    required GetAllTodos getTodo,
  })  : _getAllTodo = getTodo,
        super(TodoInitial()) {
    on<TodoEvent>((_, emit) => emit(TodoLoadInProgress()));
    on<TodoGetPressed>(_onGetTodos);
  }

  void _onGetTodos(
    TodoGetPressed event,
    Emitter<TodoState> emit,
  ) async {
    // emit(TodoLoadInProgress());
    final res = await _getAllTodo(NoParams());

    res.fold(
      (l) => emit(TodoLoadFailure(l)),
      (r) => emit(TodoLoadSuccess(r)),
    );
  }
}
