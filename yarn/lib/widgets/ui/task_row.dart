import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/models/user.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';

enum _Due { overdue, today, upcoming, done }

class TaskRow extends StatelessWidget {
  final Task task;
  final List<User> users;
  final String? roomName;
  final VoidCallback onToggle;
  final bool isEditMode;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const TaskRow({
    super.key,
    required this.task,
    required this.users,
    required this.onToggle,
    this.roomName,
    required this.isEditMode,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  static const _doneGreen = Color(0xFF7A9A78);

  String _fmt(DateTime d) => '${d.month}/${d.day}';

  ({_Due kind, String label})? get _due {
    final due = task.dueDate;

    if (task.isDone) {
      return (kind: _Due.done, label: due == null ? 'Done' : 'Next ${_fmt(due)}');
    }
    if (due == null) return null;

    final now = DateTime.now();
    final days = due.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (days < 0) return (kind: _Due.overdue, label: 'Overdue · ${_fmt(due)}');
    if (days == 0) return (kind: _Due.today, label: 'Today');
    if (days == 1) return (kind: _Due.upcoming, label: 'Tomorrow');
    return (kind: _Due.upcoming, label: _fmt(due));
  }

  String get _assignees => task.assignedTo
      .map((id) => users.where((u) => u.id == id).firstOrNull?.name)
      .whereType<String>()
      .join(', ');

  String get _subtitle => [
    ?roomName,
    _assignees,
    task.repeatLabel,
  ].where((s) => s.isNotEmpty).join(' · ');

  @override
  Widget build(BuildContext context) {
    final done = task.isDone;
    final muted = AppColors.ink.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
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
                if (_due case final due?) ...[
                  const SizedBox(height: 6),
                  _DuePill(kind: due.kind, label: due.label),
                ],
              ],
            ),
          ),

          !isEditMode
              ? GestureDetector(
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
                            ? const Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.ink,
                      onPressed: onEditTap,
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.accent,
                      onPressed: onDeleteTap,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _DuePill extends StatelessWidget {
  final _Due kind;
  final String label;
  const _DuePill({required this.kind, required this.label});

  @override
  Widget build(BuildContext context) {
    final (Color color, IconData icon) = switch (kind) {
      _Due.overdue => (const Color(0xFFE5A58E), Icons.schedule),
      _Due.today => (const Color(0xFFEBCB8B), Icons.wb_sunny_outlined),
      _Due.upcoming => (const Color(0xFF7C9CC4), Icons.event_outlined),
      _Due.done => (const Color(0xFF7A9A78), Icons.check_circle_outline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.ink.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppText.body(
              12,
              weight: FontWeight.w800,
              color: AppColors.ink.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
