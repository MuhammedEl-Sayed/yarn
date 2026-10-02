import 'package:flutter/material.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  final String? roomName;
  final VoidCallback onToggle;

  const TaskRow({
    super.key,
    required this.task,
    required this.onToggle,
    this.roomName,
  });

  static const _swatches = [
    Color(0xFFE5A58E),
    Color(0xFFB9C7AE),
    Color(0xFFEBCB8B),
    Color(0xFF7C9CC4),
  ];
  static const _doneGreen = Color(0xFF7A9A78);

  String get _subtitle {
    final unit = task.repUnit.isEmpty
        ? ''
        : task.repUnit[0].toUpperCase() + task.repUnit.substring(1);
    return [
      ?roomName,
      if (task.assignedTo.isNotEmpty) task.assignedTo.join(', '),
      unit,
    ].where((s) => s.isNotEmpty).join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final done = task.isDoneToday;
    final swatch = _swatches[task.id.hashCode.abs() % _swatches.length];
    final muted = AppColors.ink.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: swatch.withValues(alpha: done ? 0.5 : 1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style:
                      AppText.body(
                        16,
                        weight: FontWeight.w800,
                        color: done ? muted : AppColors.ink,
                      ).copyWith(
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                ),
                const SizedBox(height: 2),
                Text(_subtitle, style: AppText.body(13, color: muted)),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? _doneGreen : Colors.transparent,
                    border: Border.all(
                      color: done ? _doneGreen : AppColors.line,
                      width: 2,
                    ),
                  ),
                  child: done
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
