part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class TodoLoadInProgress extends TodoState {}

final class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;

  TodoLoadSuccess(this.todos);
}

final class TodoLoadFailure extends TodoState {
  final Failure failure;

  TodoLoadFailure(this.failure);
}
