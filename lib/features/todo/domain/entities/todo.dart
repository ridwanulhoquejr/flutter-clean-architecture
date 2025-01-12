import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  const Todo({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  @override
  List<Object?> get props => [userId, id, title, completed];

  @override
  toString() {
    return 'Todo { userId: $userId, id: $id, title: $title, completed: $completed }';
  }

  Todo copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
