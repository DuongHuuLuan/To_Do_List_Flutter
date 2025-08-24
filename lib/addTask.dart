import 'package:flutter/material.dart';

// thêm task mới

void showAddTaskForm({
  required BuildContext context,
  required Function(String title, String description, Color color) onSave,
}) {
  String title = '';
  String description = '';
  Color selectedColor = Colors.teal;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Thêm công việc mới'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Tên công việc'),
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 5),
                TextField(
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
                  if (title.isNotEmpty) {
                    onSave(title, description, selectedColor);
                  }
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
