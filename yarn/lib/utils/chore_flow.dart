import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/room_palette.dart';
import 'package:yarn/widgets/add_chore/add_chore_sheet.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';

/// Opens the chore sheet and saves the result.
/// [task] null = create, non-null = update that task.
Future<void> openChoreSheet(
  BuildContext context,
  Task? task, {
  String? initialRoomId,
}) async {
  final provider = context.read<SpoolProvider>();
  final messenger = ScaffoldMessenger.of(context);

  final draft = await showAddChoreSheet(
    context,
    task,
    initialRoomId: initialRoomId,
    rooms: [
      for (final (i, r) in provider.rooms.indexed)
        RoomOption(
          id: r.id,
          label: r.name,
          color: roomColorAt(r.colorIndex, i),
        ),
    ],
    people: const [],
  );
  if (draft == null) return;

  final base =
      task ??
      Task(
        id: '', // server assigns
        createdBy: dotenv.env['SPOOL_USER'] ?? 'me',
        name: draft.title,
        repUnit: draft.repeat.name,
      );
  final next = base.copyWith(
    name: draft.title,
    repUnit: draft.repeat.name,
    every: draft.every,
    repeatsOn: draft.repeatsOn,
    monthlyOn: draft.monthlyOn,
    assignedTo: [if (draft.assignedTo != null) draft.assignedTo!],
    roomId: draft.roomId,
  );

  try {
    if (task == null) {
      await provider.addTask(next);
    } else {
      await provider.updateTask(next);
    }
  } catch (e) {
    debugPrint('SAVE CHORE FAILED: $e');
    messenger.showSnackBar(
      SnackBar(
        content: Text(task == null ? "Couldn't add chore" : "Couldn't save chore"),
      ),
    );
  }
}
