import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/domain/models/task_filter.dart';
import 'package:todo_list/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:todo_list/features/tasks/presentation/providers/task_filter_providers.dart';
import 'package:todo_list/features/tasks/presentation/screens/add_task_screen.dart';
import 'package:todo_list/features/tasks/presentation/widgets/task_tile.dart';
import 'package:todo_list/features/countries/presentation/screens/countries_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Task List'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CountriesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (context, ref, child) {
                final currentFilter = ref.watch(currentTaskFilterProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: TaskFilter.values.map((filter) {
                    final isSelected = currentFilter == filter;
                    return FilterChip(
                      label: Text(filter.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(currentTaskFilterProvider.notifier).state =
                              filter;
                        }
                      },
                      selectedColor: Colors.blue.shade200,
                      checkmarkColor: Colors.blue.shade800,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final filteredTasksAsyncValue = ref.watch(
                  filteredTasksProvider,
                );
                return switch (filteredTasksAsyncValue) {
                  AsyncValue<List<Task>>(error: null, value: [...]) =>
                    filteredTasksAsyncValue.value!.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay tareas para mostrar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                filteredTasksAsyncValue.value?.length ?? 0,
                            itemBuilder: (context, index) {
                              final task =
                                  filteredTasksAsyncValue.value![index];
                              return TaskTile(
                                task: task,
                                onDelete: (id) async {
                                  await ref
                                      .read(tasksRepositoryProvider)
                                      .deleteTask(task);
                                  ref.invalidate(initialTasksProvider);
                                },
                                onToggleCompleted: (id, completed) {
                                  ref
                                      .read(tasksRepositoryProvider)
                                      .saveTask(
                                        task.copyWith(completed: completed),
                                      );
                                  ref.invalidate(initialTasksProvider);
                                },
                              );
                            },
                          ),
                  AsyncValue<List<Task>>(hasError: true, error: Object()) =>
                    Text('Error: ${filteredTasksAsyncValue.error.toString()}'),
                  _ => const Center(child: CircularProgressIndicator()),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
