// create a page for shwoing our Todos

import 'package:clean_architecture_with_bloc/core/utils/colored_logger.dart';
import 'package:clean_architecture_with_bloc/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {
        if (state is TodoLoadFailure) {
          ColoredLogger.Yellow.log(
              "state.failure.message: ${state.failure.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<TodoBloc>().add(TodoGetPressed());
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Todos',
              ),
            ),
            body: switch (state) {
              TodoInitial _ => Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(TodoGetPressed());
                    },
                    child: const Text('Get Todos'),
                  ),
                ),
              TodoLoadInProgress _ => const Center(
                  child: CircularProgressIndicator(),
                ),
              TodoLoadSuccess _ => ListView.builder(
                  itemCount: state.todos.length,
                  itemBuilder: (context, index) {
                    final todo = state.todos[index];
                    return ListTile(
                      title: Text(todo.title!),
                      subtitle: Text(todo.completed.toString()),
                    );
                  },
                ),
              TodoLoadFailure() => Center(
                  child: Text(
                    state.failure.message,
                  ),
                ),
            },
          ),
        );
      },
    );
  }
}
