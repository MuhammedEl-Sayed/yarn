import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/widgets/add_chore/add_chore_sheet.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/widgets/ui/task_row.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  static const _all = 'All';
  String _filter = _all; // 'All' or a room id

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpoolProvider>().init();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openAddChore() async {
    final provider = context.read<SpoolProvider>();
    final draft = await showAddChoreSheet(
      context,
      rooms: [
        for (final r in provider.rooms) RoomOption(id: r.id, label: r.name),
      ],
      people: const [],
    );
    if (draft == null || !mounted) return;

    try {
      await provider.addTask(
        Task(
          id: '', // server assigns
          title: draft.title,
          roomId: draft.roomId,
          repeat: draft.repeat.name,
          repeatsOn: draft.repeatsOn,
          assignedTo: draft.assignedTo,
          effort: draft.effort,
        ),
      );
    } catch (_) {
      if (mounted) _showError("Couldn't add chore");
    }
  }

  Future<void> _toggle(Task t) async {
    try {
      await context.read<SpoolProvider>().toggleTask(t);
    } catch (_) {
      if (mounted) _showError("Couldn't update chore");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((SpoolProvider p) => p.tasks);
    final rooms = context.select((SpoolProvider p) => p.rooms);
    final error = context.select((SpoolProvider p) => p.error);
    final loading = context.select((SpoolProvider p) => p.loading);

    final visible = _filter == _all
        ? tasks
        : tasks.where((t) => t.roomId == _filter).toList();
    final done = tasks.where((t) => t.isDone).length;
    final roomNames = {for (final Room r in rooms) r.id: r.name};

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddChore,
        icon: const Icon(Icons.add),
        label: const Text('Cast on'),
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
                    const _TopBar(),
                    const SizedBox(height: 16),
                    _ProgressCard(done: done, total: tasks.length),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(
                            label: _all,
                            selected: _filter == _all,
                            onTap: () => setState(() => _filter = _all),
                          ),
                          for (final r in rooms) ...[
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: r.name,
                              selected: _filter == r.id,
                              onTap: () => setState(() => _filter = r.id),
                            ),
                          ],
                        ],
                      ),
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
                      loading
                          ? 'Loading…'
                          : error ?? 'No chores yet. Tap "Cast on" to add one.',
                      style: AppText.body(
                        14,
                        color: AppColors.ink.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList.builder(
                    itemCount: visible.length,
                    itemBuilder: (_, i) {
                      final t = visible[i];
                      return TaskRow(
                        key: ValueKey(t.id),
                        task: t,
                        roomName: roomNames[t.roomId],
                        onToggle: () => _toggle(t),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

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
    return Column(
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
        color: const Color(0xFFFFFBF3),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : const Color(0xFFFFFBF3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.ink : AppColors.line),
        ),
        child: Text(
          label,
          style: AppText.body(
            14,
            weight: FontWeight.w800,
            color: selected ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
