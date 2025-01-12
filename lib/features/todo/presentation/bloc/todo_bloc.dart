import 'package:clean_architecture_with_bloc/core/error/failures.dart';
import 'package:clean_architecture_with_bloc/core/usecase/usecase.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:clean_architecture_with_bloc/features/todo/domain/usecase/get_todo_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetAllTodos _getTodo;

  TodoBloc({
    required GetAllTodos getTodo,
  })  : _getTodo = getTodo,
        super(
          TodoInitial(),
        ) {
    // on<TodoEvent>((_, emit) => emit(TodoLoading()));
    on<GetTodosEvent>(_onGetTodos);
  }

  void _onGetTodos(
    GetTodosEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    final res = await _getTodo(NoParams());

    res.fold(
      (l) => emit(TodoFailure(l)),
      (r) => emit(TodoSuccess(r)),
    );
  }
}
