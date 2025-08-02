import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/domain/models/task_extensions.dart';

abstract class TasksLocalDataSource {
  Future<List<Task>?> getTasks();
  Future<void> saveTask(Task task);
  Future<void> deleteTask(Task task);
  Future<void> insertTasksList(List<Task> tasks);
}

class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  Database? _database;

  Future<void> _init() async {
    if (_database != null) return;

    _database = await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, completed INTEGER)',
        );
      },
    );
  }

  Future<void> _ensureInitialized() async {
    if (_database == null || !_database!.isOpen) {
      await _init();
    }
  }

  @override
  Future<List<Task>?> getTasks() async {
    await _ensureInitialized();

    final List<Map<String, dynamic>> maps = await _database!.query(
      'tasks',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) {
      return taskFromMap(maps[i]);
    });
  }

  @override
  Future<void> saveTask(Task task) async {
    await _ensureInitialized();

    final existingTask = task.id != null
        ? await _database!.query('tasks', where: 'id = ?', whereArgs: [task.id])
        : [];

    if (existingTask.isNotEmpty) {
      await _database!.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      return;
    } else {
      await _database!.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _ensureInitialized();
    await _database!.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  @override
  Future<void> insertTasksList(List<Task> tasks) async {
    await _ensureInitialized();
    final batch = _database!.batch();
    for (final task in tasks) {
      batch.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }
}

final tasksLocalDataSourceProvider = Provider<TasksLocalDataSource>(
  (ref) => TasksLocalDataSourceImpl(),
);
