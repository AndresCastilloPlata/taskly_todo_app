import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taskly_todo_app/core/theme/app_theme.dart';
import 'package:taskly_todo_app/features/tasks/presentation/screens/task_list_screen.dart';

void main() {
  runApp(ProviderScope(child: const TasklyApp()));
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskly',
      theme: AppTheme.light,
      home: const TaskListScreen(),
    );
  }
}
