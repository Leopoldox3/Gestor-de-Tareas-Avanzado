import 'package:flutter/material.dart';
import 'package:todo_list/features/tasks/domain/models/task.dart';
import 'package:todo_list/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:todo_list/features/tasks/presentation/screens/edit_task_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(int id) onDelete;
  final Function(int id, bool completed) onToggleCompleted;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: task.completed ? TextDecoration.lineThrough : null,
            color: task.completed ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          'ID: ${task.id} • ${task.completed ? 'Completada' : 'Pendiente'}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        leading: Checkbox(
          value: task.completed,
          onChanged: (value) => onToggleCompleted(task.id!, value ?? false),
          activeColor: Colors.green,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(task: task),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onDelete(task.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
