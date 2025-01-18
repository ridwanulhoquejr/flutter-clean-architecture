part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

final class TodoGetPressed extends TodoEvent {}

final class TodoDeletePressed extends TodoEvent {}

final class TodoAddPressed extends TodoEvent {}

final class TodoRetriedPressed extends TodoEvent {}
