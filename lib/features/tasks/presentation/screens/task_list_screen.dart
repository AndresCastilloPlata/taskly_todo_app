import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_todo_app/features/tasks/presentation/providers/task_list_provider.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
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
              ? const Center(
                child: Text('No tasks yet!', style: TextStyle(fontSize: 18)),
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
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration:
                              task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        value: task.isDone,
                        onChanged: (_) {
                          ref
                              .read(taskListProvider.notifier)
                              .toggleTask(task.id);
                        },
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
            title: const Text('Add Task'),

            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter task title'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
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
