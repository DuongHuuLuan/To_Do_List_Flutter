import 'package:flutter/material.dart';
import 'taskCard.dart';
import 'addTask.dart';
import 'editTask.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task.dart';

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Tasks'),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Chưa có công việc nào'));
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
                  showEditTaskForm(
                    context: context,
                    editTask: task,
                    onSave: (updatedTask) {
                      _updateTask(index, updatedTask);
                    },
                  );
                },
                onToggle: () {
                  return _toggleTask(index);
                },
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(task.title),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mô tả: ${task.description.isNotEmpty ? task.description : 'Không có'}',
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Trạng thái: ${task.isDone == true ? 'Đã xong' : 'Chưa xong'}',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              showEditTaskForm(
                                context: context,
                                editTask: task,
                                onSave: (updatedTask) {
                                  _updateTask(index, updatedTask);
                                },
                              );
                            },
                            child: const Text("Sửa"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteTask(index);
                            },
                            child: const Text('Xóa'),
                          ),

                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          ),
                        ],
                      );
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
        child: const Icon(Icons.add),
      ),
    );
  }
  // noi dung
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //       title: const Text('My Tasks'),
  //     ),
  //     body: ValueListenableBuilder(
  //       valueListenable: taskBox.listenable(),
  //       builder: (context, Box<Task> box,_){
  //     ListView.separated(
  //       itemBuilder: (context, index) {
  //         final task = _tasks[index];
  //         return TaskCard(
  //           task: task,
  //           onToggle: () {
  //             setState(() {
  //               task.isDone = !task.isDone;
  //             });
  //           },
  //           // hiển thị chi tiết công việc khi người dùng nhấn vào gọi callback đến taskCard
  //           onTap: () {
  //             showDialog(
  //               context: context,
  //               builder: (_) {
  //                 return AlertDialog(
  //                   title: Text(task.title),
  //                   content: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(
  //                         'Mô tả: ${task.description.isNotEmpty ? task.description : "Không có"}',
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text(
  //                         'Trạng thái ${task.isDone == true ? 'Đã xong' : 'Chưa xong'}',
  //                       ),
  //                     ],
  //                   ),
  //                   actions: [
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         showEditTaskForm(
  //                           context: context,
  //                           editTask: task,
  //                           onSave: (updatedTask) {
  //                             _updateTask(index, updatedTask);
  //                           },
  //                         );
  //                       },
  //                       child: const Text('Sửa'),
  //                     ),

  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         _deleteTask(index);
  //                       },
  //                       child: const Text(
  //                         'Xóa',
  //                         style: TextStyle(color: Colors.red),
  //                       ),
  //                     ),

  //                     TextButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       child: const Text('Đóng'),
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       },
  //       padding: const EdgeInsets.symmetric(vertical: 12),
  //       separatorBuilder: (_, __) {
  //         return const SizedBox(height: 12);
  //       },
  //       itemCount: _tasks.length,
  //     ),
  //     }
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         showAddTaskForm(context: context, onSave: _addTask);
  //       },
  //       child: const Icon(Icons.add),
  //     ),
  //     ),
  //   );
  // }
}
