import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_todo_app/core/theme/app_theme.dart';
import 'package:taskly_todo_app/features/tasks/presentation/providers/task_list_provider.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          if (tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                ref.read(taskListProvider.notifier).clearAll();
              },
            ),
        ],
      ),
      body:
          tasks.isEmpty
              ? Center(
                child: const Text(
                  'You have no tasks yet!',
                  style: TextStyle(color: AppColors.gray),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Dismissible(
                    key: Key(task.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(taskListProvider.notifier).removeTask(task.id);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppColors.danger,
                      child: const Icon(Icons.delete, color: AppColors.white),
                    ),
                    child: FadeInLeft(
                      duration: Duration(
                        milliseconds: 400 + index * 100,
                      ), // leve efecto secencial
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color:
                              task.isDone ? Colors.green.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration:
                                      task.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  color:
                                      task.isDone
                                          ? AppColors.gray
                                          : AppColors.text,
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  task.isDone
                                      ? Icon(Icons.check_circle)
                                      : Icon(Icons.radio_button_unchecked),
                              color:
                                  task.isDone
                                      ? AppColors.success
                                      : AppColors.gray,
                              onPressed: () {
                                ref
                                    .read(taskListProvider.notifier)
                                    .toggleTask(task.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(context, ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Add Task'),

            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Enter task title'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = controller.text.trim();

                  if (title.isNotEmpty) {
                    ref.read(taskListProvider.notifier).addTask(title);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }
}
