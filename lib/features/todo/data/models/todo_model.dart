import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';

/// Data-layer representation of [Todo]. Equality/props are inherited from the
/// [Equatable] base entity, so they are not redeclared here.
///
/// Null-handling lives here (the API boundary), keeping the domain entity
/// strongly typed.
class TodoModel extends Todo {
  const TodoModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        userId: json["userId"] as int? ?? 0,
        id: json["id"] as int? ?? 0,
        title: json["title"] as String? ?? '',
        completed: json["completed"] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
