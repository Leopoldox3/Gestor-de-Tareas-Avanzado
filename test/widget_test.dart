import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/domain/repositories/tasks_repository.dart';

void main() {
  testWidgets('TaskListScreen debe mostrar la UI correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialTasksProvider.overrideWith((ref) => Future.value(<Task>[])),
          tasksRepositoryProvider.overrideWith((ref) => MockTasksRepository()),
        ],
        child: const MaterialApp(home: TaskListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Task List'), findsOneWidget);
    expect(find.byIcon(Icons.public), findsOneWidget);
    expect(find.byIcon(Icons.add_box), findsOneWidget);
  });
}

class MockTasksRepository implements TasksRepository {
  @override
  Future<List<Task>> fetchInitialTasks() async {
    return [];
  }

  @override
  Future<void> saveTask(Task task) async {}

  @override
  Future<void> deleteTask(Task task) async {}
}
