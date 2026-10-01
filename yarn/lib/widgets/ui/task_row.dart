import 'package:flutter/material.dart';
import 'package:yarn/models/task.dart';

class TaskRow extends StatelessWidget {
  final Task task;

  const TaskRow({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${task.createdBy} · ${_recurrence()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.check_outlined),
        ],
      ),
    );
  }

  String _recurrence() {
    // Adjust to your Task model's field names
    return 'Every ${task.every ?? 1} ${task.repUnit}';
  }
}
