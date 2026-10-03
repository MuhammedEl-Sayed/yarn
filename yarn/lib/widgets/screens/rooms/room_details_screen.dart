import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/room_palette.dart';
import 'package:yarn/utils/chore_flow.dart';
import 'package:yarn/widgets/ui/task_row.dart';
import 'package:yarn/widgets/ui/skein_ball.dart';

class RoomDetailsScreen extends StatefulWidget {
  final String roomId;
  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  bool _isEditMode = false;

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggle(Task t) async {
    try {
      await context.read<SpoolProvider>().toggleTask(t);
    } catch (e) {
      debugPrint('TOGGLE FAILED: $e');
      if (mounted) _showError("Couldn't update chore");
    }
  }

  Future<void> _deleteTask(Task t) async {
    try {
      await context.read<SpoolProvider>().deleteTask(t.id);
    } catch (e) {
      debugPrint('DELETE TASK FAILED: $e');
      if (mounted) _showError("Couldn't delete chore");
    }
  }

  Future<void> _deleteRoom(Room room) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${room.name}?'),
        content: const Text("This can't be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final provider = context.read<SpoolProvider>();
    final nav = Navigator.of(context);
    try {
      await provider.deleteRoom(room.id);
      nav.pop();
    } catch (e) {
      debugPrint('DELETE ROOM FAILED: $e');
      if (mounted) _showError("Couldn't delete room");
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = context.select(
      (SpoolProvider p) => p.roomById(widget.roomId),
    );
    final index = context.select(
      (SpoolProvider p) => p.rooms.indexWhere((r) => r.id == widget.roomId),
    );
    final tasks = context.select((SpoolProvider p) => p.tasks);

    if (room == null) {
      return const Scaffold(body: SafeArea(child: Center(child: Text('Room not found'))));
    }

    final color = roomColorAt(room.colorIndex, index < 0 ? 0 : index);
    final roomTasks = tasks.where((t) => t.roomId == room.id).toList();
    final done = roomTasks.where((t) => t.isDoneToday).length;
    final muted = AppColors.ink.withValues(alpha: 0.55);

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => openChoreSheet(context, null, initialRoomId: room.id),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_isEditMode ? Icons.check : Icons.edit),
                  onPressed: () => setState(() => _isEditMode = !_isEditMode),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'delete') _deleteRoom(room);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'delete', child: Text('Delete room')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SkeinBall(color: color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(roomIconFor(room.icon), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              room.name,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.display(32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${roomTasks.length} '
                        '${roomTasks.length == 1 ? 'chore' : 'chores'}'
                        ' · $done done today',
                        style: AppText.body(13, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (roomTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Text(
                    'No chores in this room yet.',
                    style: AppText.body(14, color: muted),
                  ),
                ),
              )
            else
              for (final t in roomTasks)
                TaskRow(
                  key: ValueKey(t.id),
                  task: t,
                  onToggle: () => _toggle(t),
                  isEditMode: _isEditMode,
                  onEditTap: () => openChoreSheet(context, t),
                  onDeleteTap: () => _deleteTask(t),
                ),
          ],
        ),
      ),
    );
  }
}
