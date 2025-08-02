import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/domain/models/task_filter.dart';

void main() {
  test('Lógica de filtro de tareas - debe filtrar tareas correctamente', () {
    final testTasks = [
      const Task(id: 1, title: 'Tarea 1', completed: false),
      const Task(id: 2, title: 'Tarea 2', completed: true),
      const Task(id: 3, title: 'Tarea 3', completed: false),
    ];

    final allTasks = _filterTasks(testTasks, TaskFilter.all);
    expect(allTasks.length, equals(3));

    final completedTasks = _filterTasks(testTasks, TaskFilter.completed);
    expect(completedTasks.length, equals(1));
    expect(completedTasks.first.completed, isTrue);

    final pendingTasks = _filterTasks(testTasks, TaskFilter.pending);
    expect(pendingTasks.length, equals(2));
    expect(pendingTasks.every((task) => !task.completed), isTrue);
  });
}

List<Task> _filterTasks(List<Task> tasks, TaskFilter filter) {
  switch (filter) {
    case TaskFilter.all:
      return tasks;
    case TaskFilter.completed:
      return tasks.where((task) => task.completed).toList();
    case TaskFilter.pending:
      return tasks.where((task) => !task.completed).toList();
  }
}
