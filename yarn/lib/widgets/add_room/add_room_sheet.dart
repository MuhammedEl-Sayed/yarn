import 'package:flutter/material.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/room_palette.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/widgets/add_chore/sections/shared.dart' show SectionLabel;
import 'package:yarn/widgets/ui/skein_ball.dart';

class StarterChore {
  final String title;
  final Repeat repeat;
  final int every;
  const StarterChore(this.title, this.repeat, [this.every = 1]);

  String get label {
    if (repeat == Repeat.once) return 'As needed';
    const names = {
      Repeat.day: 'Daily',
      Repeat.week: 'Weekly',
      Repeat.month: 'Monthly',
      Repeat.year: 'Yearly',
    };
    if (every == 1) return names[repeat]!;
    const short = {
      Repeat.day: 'days',
      Repeat.week: 'wks',
      Repeat.month: 'mos',
      Repeat.year: 'yrs',
    };
    return 'Every $every ${short[repeat]}';
  }
}

/// Suggested chores, matched by a keyword in the room name.
const _templates = <String, List<StarterChore>>{
  'bath': [
    StarterChore('Scrub the tub', Repeat.week),
    StarterChore('Wipe the mirror', Repeat.week),
    StarterChore('Restock toilet paper', Repeat.once),
    StarterChore('Wash bath mats', Repeat.week, 2),
  ],
  'kitchen': [
    StarterChore('Wipe the counters', Repeat.day),
    StarterChore('Take out the trash', Repeat.day),
    StarterChore('Mop the floor', Repeat.week),
    StarterChore('Clean the fridge', Repeat.month),
  ],
  'laundry': [
    StarterChore('Wash towels', Repeat.week),
    StarterChore('Wash bedding', Repeat.week, 2),
    StarterChore('Clean the lint trap', Repeat.week),
  ],
  'living': [
    StarterChore('Vacuum', Repeat.week),
    StarterChore('Dust the shelves', Repeat.week),
    StarterChore('Tidy the cushions', Repeat.day),
  ],
  'bed': [
    StarterChore('Make the bed', Repeat.day),
    StarterChore('Change the sheets', Repeat.week, 2),
    StarterChore('Vacuum', Repeat.week),
  ],
};

class RoomDraft {
  final String name;
  final int colorIndex;
  final String icon;
  final List<StarterChore> starters;

  const RoomDraft({
    required this.name,
    required this.colorIndex,
    required this.icon,
    required this.starters,
  });
}

Future<RoomDraft?> showAddRoomSheet(
  BuildContext context, {
  required int nextColorIndex,
}) {
  return showModalBottomSheet<RoomDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: const Color(0x8033261F),
    builder: (_) => AddRoomSheet(nextColorIndex: nextColorIndex),
  );
}

class AddRoomSheet extends StatefulWidget {
  final int nextColorIndex;
  const AddRoomSheet({super.key, required this.nextColorIndex});

  @override
  State<AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends State<AddRoomSheet> {
  final _name = TextEditingController();
  late int _color = widget.nextColorIndex % roomColors.length;
  String _icon = roomIcons.keys.first;
  List<StarterChore> _shown = const [];
  Set<StarterChore> _selected = {};

  @override
  void initState() {
    super.initState();
    _name.addListener(_onName);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _onName() {
    final lower = _name.text.toLowerCase();
    List<StarterChore> list = const [];
    for (final e in _templates.entries) {
      if (lower.contains(e.key)) {
        list = e.value;
        break;
      }
    }
    setState(() {
      if (!identical(list, _shown)) {
        _shown = list;
        _selected = {...list}; // new suggestions start checked
      }
    });
  }

  void _toggleStarter(StarterChore s) => setState(() {
    _selected.contains(s) ? _selected.remove(s) : _selected.add(s);
  });

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(
      RoomDraft(
        name: name,
        colorIndex: _color,
        icon: _icon,
        starters: [
          for (final s in _shown)
            if (_selected.contains(s)) s,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _name.text.trim();
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
              'Add a room',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // live preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDE2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  SkeinBall(color: roomColors[_color]),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'New room' : name,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.display(22),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_selected.length} starter '
                          '${_selected.length == 1 ? 'chore' : 'chores'}',
                          style: AppText.body(
                            13,
                            color: AppColors.ink.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              style: AppText.body(16, weight: FontWeight.w800),
              decoration: const InputDecoration(labelText: 'Room name'),
            ),
            const SizedBox(height: 22),
            const SectionLabel('Yarn color'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final (i, c) in roomColors.indexed)
                  GestureDetector(
                    onTap: () => setState(() => _color = i),
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == i
                              ? AppColors.ink
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionLabel('Icon'),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final e in roomIcons.entries) ...[
                    GestureDetector(
                      onTap: () => setState(() => _icon = e.key),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _icon == e.key
                              ? AppColors.ink
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _icon == e.key
                                ? AppColors.ink
                                : AppColors.line,
                          ),
                        ),
                        child: Icon(
                          e.value,
                          color: _icon == e.key ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
            if (_shown.isNotEmpty) ...[
              const SizedBox(height: 22),
              const SectionLabel('Start with these chores'),
              const SizedBox(height: 6),
              for (final s in _shown)
                InkWell(
                  onTap: () => _toggleStarter(s),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _selected.contains(s)
                                ? AppColors.ink
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: _selected.contains(s)
                                  ? AppColors.ink
                                  : AppColors.line,
                              width: 2,
                            ),
                          ),
                          child: _selected.contains(s)
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            s.title,
                            style: AppText.body(15, weight: FontWeight.w800),
                          ),
                        ),
                        Text(
                          s.label,
                          style: AppText.body(
                            13,
                            weight: FontWeight.w700,
                            color: AppColors.ink.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: name.isEmpty ? null : _submit,
                child: const Text('Add room'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
