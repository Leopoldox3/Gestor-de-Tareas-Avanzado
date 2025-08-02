import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';

abstract class TasksRemoteDataSource {
  Future<List<Task>> getInitialTasks();
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final baseURL = 'https://jsonplaceholder.typicode.com';
  final httpClient = http.Client();

  @override
  Future<List<Task>> getInitialTasks() async {
    final response = await httpClient.get(
      Uri.parse('$baseURL/todos'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      return jsonResponse.map((json) {
        return Task(
          id: json['id'] as int,
          title: json['title'] as String,
          completed: json['completed'] as bool,
        );
      }).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}

final tasksRemoteDataSourceProvider = Provider<TasksRemoteDataSource>(
  (ref) => TasksRemoteDataSourceImpl(),
);
