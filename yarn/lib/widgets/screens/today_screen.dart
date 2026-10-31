import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/room_palette.dart';
import 'package:yarn/utils/chore_flow.dart';
import 'package:yarn/widgets/ui/collapsible_section.dart';
import 'package:yarn/widgets/ui/task_row.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  static const _all = 'All';

  String _person = _all; // 'All' or a user id
  bool isEditMode = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _poll = Timer.periodic(const Duration(seconds: 45), (_) => _refresh());
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  @override
  void dispose() {
    _poll?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _refresh() {
    if (mounted) context.read<SpoolProvider>().init();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((SpoolProvider p) => p.tasks);
    final rooms = context.select((SpoolProvider p) => p.rooms);
    final users = context.select((SpoolProvider p) => p.users);
    final error = context.select((SpoolProvider p) => p.error);
    final loading = context.select((SpoolProvider p) => p.loading);

    // Dropdown options as value -> label. Maps dedupe by value, so duplicate
    // ids can't produce two items with the same value. Chores store assignee
    // ids, so filter by id too.
    final personOptions = <String, String>{
      _all: _all,
      for (final u in users)
        if (u.id != null) u.id!: u.name,
    };
    // If the selected person no longer exists (user removed, data refreshed),
    // fall back to 'All' instead of crashing the dropdown.
    final personFilter = personOptions.containsKey(_person) ? _person : _all;

    final filtered = tasks.where(
      (t) => personFilter == _all || t.assignedTo.contains(personFilter),
    );
    // Today's list: what's due (or overdue), plus what got done today.
    final today = filtered
        .where((t) => t.isActive && (t.isDue || t.isDoneToday))
        .toList();
    // Edit mode shows everything so you can fix or delete any chore.
    final visible = isEditMode ? filtered.toList() : today;

    final pending = visible.where((t) => !t.isDone).toList()
      ..sort(
        (a, b) => (a.dueDate ?? DateTime(9999)).compareTo(
          b.dueDate ?? DateTime(9999),
        ),
      );
    final completed = visible.where((t) => t.isDone).toList();
    final done = today.where((t) => t.isDone).length;
    final roomNames = {for (final Room r in rooms) r.id: r.name};

    // Group pending chores by room; anything without a known room goes to "Other".
    final roomIds = {for (final r in rooms) r.id};
    final byRoom = <String, List<Task>>{};
    final noRoom = <Task>[];
    for (final t in pending) {
      if (t.roomId != null && roomIds.contains(t.roomId)) {
        byRoom.putIfAbsent(t.roomId!, () => []).add(t);
      } else {
        noRoom.add(t);
      }
    }

    // Rows under a room header don't repeat the room's name.
    Widget buildRow(Task t, {bool showRoom = false}) => TaskRow(
      key: ValueKey(t.id),
      task: t,
      users: users,
      roomName: showRoom ? roomNames[t.roomId] : null,
      onToggle: () => toggleChore(context, t),
      isEditMode: isEditMode,
      onDeleteTap: () => confirmDeleteChore(context, t),
      onEditTap: () => openChoreSheet(context, t),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => openChoreSheet(context, null),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: context.read<SpoolProvider>().init,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _TopBar(
                      isEditMode: isEditMode,
                      onPressed: () => setState(() => isEditMode = !isEditMode),
                    ),
                    const SizedBox(height: 16),
                    _ProgressCard(done: done, total: today.length),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Person filter
                        _FilterDropdown(
                          value: personFilter,
                          options: personOptions,
                          onChanged: (v) => setState(() => _person = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),
              if (visible.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      loading ? 'Loading…' : error ?? 'Nothing due today.',
                      style: AppText.body(
                        14,
                        color: AppColors.ink.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                )
              else ...[
                // One dropdown per room
                for (var i = 0; i < rooms.length; i++)
                  if (byRoom[rooms[i].id]?.isNotEmpty ?? false)
                    SliverToBoxAdapter(
                      key: ValueKey('room-${rooms[i].id}'),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                        child: CollapsibleSection(
                          title: rooms[i].name,
                          count: byRoom[rooms[i].id]!.length,
                          titleStyle: AppText.body(15, weight: FontWeight.w800),
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: roomColorAt(rooms[i].colorIndex, i),
                              shape: BoxShape.circle,
                            ),
                          ),
                          children: [
                            for (final t in byRoom[rooms[i].id]!) buildRow(t),
                          ],
                        ),
                      ),
                    ),

                // Chores with no room
                if (noRoom.isNotEmpty)
                  SliverToBoxAdapter(
                    key: const ValueKey('room-none'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                      child: CollapsibleSection(
                        title: 'Other',
                        count: noRoom.length,
                        titleStyle: AppText.body(15, weight: FontWeight.w800),
                        children: [for (final t in noRoom) buildRow(t)],
                      ),
                    ),
                  ),

                // Completed (below all rooms)
                if (completed.isNotEmpty)
                  SliverToBoxAdapter(
                    key: const ValueKey('completed'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                      child: CollapsibleSection(
                        title: 'Completed',
                        count: completed.length,
                        children: [
                          for (final t in completed) buildRow(t, showRoom: true),
                        ],
                      ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ), // keeps FAB clearance
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Dropdown over a value -> label map. Because options is a Map, every value
/// is unique, and [value] must be one of its keys (callers guarantee this).
class _FilterDropdown extends StatelessWidget {
  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: options.containsKey(value) ? value : null,
      items: [
        for (final e in options.entries)
          DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onPressed;

  const _TopBar({required this.isEditMode, required this.onPressed});

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_days[now.weekday - 1]}, ${_months[now.month - 1]} ${now.day}',
                style: AppText.body(
                  14,
                  weight: FontWeight.w700,
                  color: AppColors.ink.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text("Today's chores", style: AppText.display(32)),
            ],
          ),
        ),
        IconButton(
          icon: Icon(isEditMode ? Icons.check : Icons.edit),
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int done;
  final int total;
  const _ProgressCard({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final left = total - done;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: total == 0 ? 0 : done / total,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              color: AppColors.accent,
              backgroundColor: AppColors.line,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$done of $total wound', style: AppText.display(22)),
              const SizedBox(height: 2),
              Text(
                total == 0
                    ? 'Nothing on the spool'
                    : left == 0
                    ? 'All done for today'
                    : '$left left today',
                style: AppText.body(
                  13,
                  color: AppColors.ink.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
