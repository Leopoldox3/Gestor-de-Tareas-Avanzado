import 'task.dart';

extension TaskSQLiteExtension on Task {
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'completed': completed ? 1 : 0};
  }
}

Task taskFromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    completed: (map['completed'] as int) == 1,
  );
}
