import 'package:flutter/material.dart';
import 'task.dart';

void showTaskDetailDialog({
  required BuildContext context,
  required Task task,
  required int index,
  required Function(int index) onDelete,
  required Function(Task updatedTask) onUpdate,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Mô tả: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${task.description.isNotEmpty ? task.description : 'Không có'}',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Trạng thái: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${task.isDone == true ? 'Đã xong' : 'Chưa xong'}',
                  style: TextStyle(
                    color: task.isDone == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(index);
            },
            child: const Text('Xóa'),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onUpdate(task);
            },
            child: const Text('Sửa'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}
