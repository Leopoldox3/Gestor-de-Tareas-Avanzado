import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/domain/models/task_filter.dart';
import 'package:todo_list/features/tasks/domain/repositories/tasks_repository.dart';

final currentTaskFilterProvider = StateProvider<TaskFilter>(
  (ref) => TaskFilter.all,
);

final filteredTasksProvider = FutureProvider<List<Task>>((ref) async {
  final currentFilter = ref.watch(currentTaskFilterProvider);
  final allTasksAsyncValue = ref.watch(initialTasksProvider);

  return allTasksAsyncValue.when(
    data: (allTasks) {
      switch (currentFilter) {
        case TaskFilter.all:
          return allTasks;
        case TaskFilter.completed:
          return allTasks.where((task) => task.completed).toList();
        case TaskFilter.pending:
          return allTasks.where((task) => !task.completed).toList();
      }
    },
    loading: () => <Task>[],
    error: (error, stackTrace) => <Task>[],
  );
});
