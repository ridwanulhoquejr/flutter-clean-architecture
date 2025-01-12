import 'package:clean_architecture_with_bloc/features/todo/domain/entities/todo.dart';
import 'package:equatable/equatable.dart';

class TodoModel extends Todo with EquatableMixin {
  TodoModel({
    required super.userId,
    required super.id,
    required super.title,
    required super.completed,
  });

  @override
  List<Object?> get props => [userId, id, title, completed];

  @override
  bool get stringify => true;

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
