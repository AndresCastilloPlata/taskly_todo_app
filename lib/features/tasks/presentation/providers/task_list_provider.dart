import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_todo_app/features/tasks/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]);

  final _uuid = const Uuid();

  void addTask(String title) {
    final newTask = Task(id: _uuid.v4(), title: title);
    state = [...state, newTask];
  }

  void toggleTask(String id) {
    state =
        state.map((task) {
          return task.id == id ? task.copyWith(isDone: !task.isDone) : task;
        }).toList();
  }

  void removeTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void clearAll() {
    state = [];
  }

  final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>(
    (ref) => TaskListNotifier(),
  );
}
