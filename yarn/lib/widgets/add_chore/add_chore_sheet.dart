import 'package:flutter/material.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/widgets/add_chore/sections/repeat_picker.dart';
import 'package:yarn/widgets/add_chore/sections/room_picker.dart';
import 'package:yarn/widgets/add_chore/sections/shared.dart';
import 'package:yarn/widgets/add_chore/sections/title_field.dart';
import 'package:yarn/widgets/add_chore/sections/who_picker.dart';

/// [task] null = new chore, non-null = edit. [initialRoomId] preselects a room
/// for new chores (used from the room detail screen).
Future<ChoreDraft?> showAddChoreSheet(
  BuildContext context,
  Task? task, {
  required List<RoomOption> rooms,
  required List<PersonOption> people,
  String? initialRoomId,
}) {
  return showModalBottomSheet<ChoreDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: const Color(0x8033261F),
    builder: (_) => AddChoreSheet(
      rooms: rooms,
      people: people,
      task: task,
      initialRoomId: initialRoomId,
    ),
  );
}

class AddChoreSheet extends StatefulWidget {
  final List<RoomOption> rooms;
  final List<PersonOption> people;
  final Task? task;
  final String? initialRoomId;

  const AddChoreSheet({
    super.key,
    required this.rooms,
    required this.people,
    this.task,
    this.initialRoomId,
  });

  @override
  State<AddChoreSheet> createState() => _AddChoreSheetState();
}

class _AddChoreSheetState extends State<AddChoreSheet> {
  final _title = TextEditingController();
  String? _roomId;
  Repeat _repeat = Repeat.once;
  int _every = 1;
  final Set<int> _days = {};
  int? _monthlyOn;
  String? _who;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    if (t == null) {
      _roomId = widget.initialRoomId;
      return;
    }
    _title.text = t.name;
    _roomId = t.roomId;
    _who = t.assignedTo.isEmpty ? null : t.assignedTo.first;
    _repeat = Repeat.values.asNameMap()[t.repUnit] ?? Repeat.once;
    _every = t.every ?? 1;
    _monthlyOn = t.monthlyOn;
    for (final code in t.repeatsOn) {
      final i = WeekdayPicker.codes.indexOf(code.toUpperCase());
      if (i != -1) _days.add(i);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _setRepeat(Repeat r) => setState(() {
    _repeat = r;
    final now = DateTime.now();
    // Like Google Calendar: default to today's weekday / day of month.
    if (r == Repeat.week && _days.isEmpty) _days.add(now.weekday - 1);
    if (r == Repeat.month) _monthlyOn ??= now.day > 28 ? 31 : now.day;
  });

  void _toggleDay(int i) => setState(() {
    if (_days.contains(i)) {
      if (_days.length > 1) _days.remove(i); // keep at least one day
    } else {
      _days.add(i);
    }
  });

  void _submit() {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    final sorted = _days.toList()..sort();
    Navigator.of(context).pop(
      ChoreDraft(
        id: widget.task?.id,
        title: title,
        roomId: _roomId,
        repeat: _repeat,
        every: _repeat == Repeat.once ? 1 : _every,
        repeatsOn: _repeat == Repeat.week
            ? [for (final i in sorted) WeekdayPicker.codes[i]]
            : const [],
        monthlyOn: _repeat == Repeat.month ? _monthlyOn : null,
        assignedTo: _who,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isEditing ? 'Edit chore' : 'Cast on a new chore',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            TitleField(controller: _title),
            if (widget.rooms.isNotEmpty) ...[
              const SizedBox(height: 22),
              const SectionLabel('Room yarn'),
              const SizedBox(height: 10),
              RoomPicker(
                rooms: widget.rooms,
                selectedId: _roomId,
                onChanged: (id) => setState(() => _roomId = id),
              ),
            ],
            const SizedBox(height: 22),
            const SectionLabel('Repeats'),
            const SizedBox(height: 10),
            RepeatSegments(value: _repeat, onChanged: _setRepeat),
            if (_repeat != Repeat.once) ...[
              const SizedBox(height: 14),
              IntervalStepper(
                repeat: _repeat,
                value: _every,
                onChanged: (v) => setState(() => _every = v),
              ),
            ],
            if (_repeat == Repeat.week) ...[
              const SizedBox(height: 14),
              WeekdayPicker(selected: _days, onToggle: _toggleDay),
            ],
            if (_repeat == Repeat.month) ...[
              const SizedBox(height: 14),
              MonthDayPicker(
                value: _monthlyOn,
                onChanged: (d) => setState(() => _monthlyOn = d),
              ),
            ],
            const SizedBox(height: 22),
            const SectionLabel('Who'),
            const SizedBox(height: 10),
            WhoPicker(
              people: widget.people,
              selectedId: _who,
              onChanged: (id) => setState(() => _who = id),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _submit,
                child: Text(_isEditing ? 'Save changes' : 'Add chore'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
