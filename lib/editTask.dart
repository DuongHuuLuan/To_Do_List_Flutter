import 'package:flutter/material.dart';
import 'main.dart';
import 'task.dart';

void showEditTaskForm({
  required BuildContext context,
  required Task editTask,
  required Function(Task updatedTask) onSave,
}) {
  String title = editTask.title;
  String description = editTask.description;
  Color selectedColor = Color(editTask.colorValue);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Sửa công việc'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: title),
                  decoration: InputDecoration(labelText: 'Tên công việc'),
                  onChanged: (value) => title = value,
                ),

                TextField(
                  controller: TextEditingController(text: description),
                  decoration: InputDecoration(labelText: 'Mô tả'),
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 10),
                const Text('Chọn màu'),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 8,
                  children:
                      [
                        Colors.teal,
                        Colors.yellow,
                        Colors.blue,
                        Colors.red,
                        Colors.pink,
                        Colors.purple,
                        Colors.orange,
                      ].map((color) {
                        return GestureDetector(
                          onTap: () {
                            setStateDialog(() {
                              selectedColor = color;
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 18,
                            child: selectedColor == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedTask = Task(
                    title: title,
                    description: description,
                    colorValue: selectedColor.toARGB32(),
                    isDone: editTask.isDone,
                  );
                  onSave(updatedTask);
                  Navigator.pop(context);
                },
                child: const Text('Lưu'),
              ),
            ],
          );
        },
      );
    },
  );
}
