import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/features/tasks/data/data_sources/tasks_local_data_source.dart';
import 'package:todo_list/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';

abstract class TasksRepository {
  Future<List<Task>> fetchInitialTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(Task task);
}

class TaskRepositoryImpl implements TasksRepository {
  final TasksRemoteDataSource remoteDataSource;
  final TasksLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Task>> fetchInitialTasks() async {
    final localTasks = await localDataSource.getTasks();

    if (localTasks == null || localTasks.isEmpty) {
      final networkTasks = await remoteDataSource.getInitialTasks();
      await localDataSource.insertTasksList(networkTasks);
      return networkTasks;
    }

    return localTasks;
  }

  @override
  Future<void> saveTask(Task task) async {
    await localDataSource.saveTask(task);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await localDataSource.deleteTask(task);
  }
}

final tasksRepositoryProvider = Provider<TasksRepository>(
  (ref) => TaskRepositoryImpl(
    remoteDataSource: ref.watch(tasksRemoteDataSourceProvider),
    localDataSource: ref.watch(tasksLocalDataSourceProvider),
  ),
);

final initialTasksProvider = FutureProvider<List<Task>>((ref) {
  final repository = ref.watch(tasksRepositoryProvider);
  return repository.fetchInitialTasks();
});
