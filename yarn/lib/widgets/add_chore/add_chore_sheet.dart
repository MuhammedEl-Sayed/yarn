import 'package:flutter/material.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/widgets/add_chore/sections/repeat_picker.dart';
import 'package:yarn/widgets/add_chore/sections/room_picker.dart';
import 'package:yarn/widgets/add_chore/sections/shared.dart';
import 'package:yarn/widgets/add_chore/sections/title_field.dart';
import 'package:yarn/widgets/add_chore/sections/who_picker.dart';

Future<ChoreDraft?> showAddChoreSheet(
  BuildContext context, {
  required List<RoomOption> rooms,
  required List<PersonOption> people,
}) {
  return showModalBottomSheet<ChoreDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: const Color(0x8033261F),
    builder: (_) => AddChoreSheet(rooms: rooms, people: people),
  );
}

class AddChoreSheet extends StatefulWidget {
  final List<RoomOption> rooms;
  final List<PersonOption> people;

  const AddChoreSheet({super.key, required this.rooms, required this.people});

  @override
  State<AddChoreSheet> createState() => _AddChoreSheetState();
}

class _AddChoreSheetState extends State<AddChoreSheet> {
  final _title = TextEditingController();
  String? _roomId;
  Repeat _repeat = Repeat.once;
  final Set<int> _days = {};
  String? _who;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _toggleDay(int i) =>
      setState(() => _days.contains(i) ? _days.remove(i) : _days.add(i));

  void _submit() {
    final title = _title.text.trim();
    if (title.isEmpty) return;

    final sorted = _days.toList()..sort();
    Navigator.of(context).pop(
      ChoreDraft(
        title: title,
        roomId: _roomId,
        repeat: _repeat,
        repeatsOn: _repeat == Repeat.weekly
            ? [for (final i in sorted) WeekdayPicker.letters[i]]
            : const [],
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
              'Cast on a new chore',
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
            RepeatSegments(
              value: _repeat,
              onChanged: (r) => setState(() => _repeat = r),
            ),
            if (_repeat == Repeat.weekly) ...[
              const SizedBox(height: 12),
              WeekdayPicker(selected: _days, onToggle: _toggleDay),
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
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Add chore'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
