import 'package:flutter/material.dart';
import 'main.dart';
import 'task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const TaskCard({
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Color(task.colorValue), // chinh sua nhan gia tri mau
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tieu de
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // minh hoa cac icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () => onDelete(),
                    icon: Icon(Icons.delete, color: Colors.white),
                  ),

                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () => onEdit(),
                    icon: Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
              Checkbox(
                value: task.isDone,
                onChanged: (_) => onToggle(),
                checkColor: Colors.white,
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
