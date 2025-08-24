import 'package:flutter/material.dart';
import 'taskCard.dart';
import 'addTask.dart';
import 'editTask.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';
import 'task_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasks');

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoHome(),
    );
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  late Box<Task> taskBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskBox = Hive.box<Task>('tasks');
  }

  // xử lý logic khi nhấn thêm task
  // Hàm thêm Task
  void _addTask(String title, String description, Color color) {
    final task = Task(
      title: title,
      description: description,
      colorValue: color.toARGB32(),
    );
    taskBox.add(task);
    setState(() {});
  }

  // hàm thay đổi trạng thái
  void _toggleTask(int index) {
    final task = taskBox.getAt(index);
    if (task != null) {
      task.isDone = !task.isDone;
      task.save();
      setState(() {});
    }
  }

  // Hàm xóa Task
  void _deleteTask(int index) {
    taskBox.deleteAt(index);
    setState(() {});
  }

  //Hàm sửa Task
  void _updateTask(int index, Task updatedTask) {
    taskBox.putAt(index, updatedTask);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.,
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 150, 169),
                Color.fromARGB(255, 97, 222, 222),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có công việc nào',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }
          final tasks = box.values.toList();
          return ListView.separated(
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(
                task: task,
                onDelete: () {
                  return _deleteTask(index);
                },
                onEdit: () {
                  // hiển thị form chỉnh sửa task gọi từ editTask.dart
                  showEditTaskForm(
                    context: context,
                    editTask: task,
                    onSave: (updatedTask) {
                      _updateTask(index, updatedTask);
                    },
                  );
                },
                onToggle: () {
                  // thay đổi trạng thái
                  return _toggleTask(index);
                },
                onTap: () {
                  // hiển thị chi tiết công việc gọi từ task_detail.dart
                  showTaskDetailDialog(
                    context: context,
                    task: task,
                    index: index,
                    onDelete: (index) {
                      _deleteTask(index);
                    },
                    onUpdate: (updatedTask) {
                      _updateTask(index, updatedTask);
                    },
                  );
                },
              );
            },
            padding: const EdgeInsets.symmetric(vertical: 12),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: tasks.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTaskForm(context: context, onSave: _addTask);
        },
        backgroundColor: const Color.fromARGB(255, 63, 210, 195),
        child: const Icon(Icons.add),
      ),
    );
  }
}
