enum TaskFilter {
  all,
  completed,
  pending;

  String get displayName {
    switch (this) {
      case TaskFilter.all:
        return 'Todas';
      case TaskFilter.completed:
        return 'Completadas';
      case TaskFilter.pending:
        return 'Pendientes';
    }
  }
}
