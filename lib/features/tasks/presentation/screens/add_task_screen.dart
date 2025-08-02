import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/domain/repositories/tasks_repository.dart';

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({super.key});

  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(tasksRepositoryProvider)
                      .saveTask(Task(title: titleController.text));
                  ref.invalidate(initialTasksProvider);
                  Navigator.pop(context);
                },
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
