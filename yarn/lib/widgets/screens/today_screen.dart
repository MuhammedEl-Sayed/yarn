import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/utils/chore_flow.dart';
import 'package:yarn/widgets/ui/task_row.dart';

/// UTC date-only value, so day math is immune to daylight saving changes.

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with WidgetsBindingObserver {
  static const _all = 'All';

  String _filter = _all; // 'All' or a room id
  String _person = _all; // 'All' or a user name
  bool _showCompleted = true;
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

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _logError(String what, Object e) {
    if (e is DioException) {
      debugPrint(
        '$what FAILED ${e.response?.statusCode}: ${e.response?.data ?? e.message}',
      );
    } else {
      debugPrint('$what FAILED: $e');
    }
  }

  Future<void> _toggle(Task t) async {
    try {
      await context.read<SpoolProvider>().toggleTask(t);
    } catch (e) {
      _logError('TOGGLE', e);
      if (mounted) _showError("Couldn't update chore");
    }
  }

  Future<void> _deleteTask(Task t) async {
    try {
      await context.read<SpoolProvider>().deleteTask(t.id);
    } catch (e) {
      _logError('DELETETASK', e);
      if (mounted) _showError("Couldn't delete task");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((SpoolProvider p) => p.tasks);
    final rooms = context.select((SpoolProvider p) => p.rooms);
    final users = context.select((SpoolProvider p) => p.users);
    final error = context.select((SpoolProvider p) => p.error);
    final loading = context.select((SpoolProvider p) => p.loading);

    final visible = tasks.where((t) {
      final roomOk = _filter == _all || t.roomId == _filter;
      final personOk = _person == _all || t.assignedTo.contains(_person);
      if (isEditMode) {
        // Edit mode shows everything so you can fix or delete any chore.
        return roomOk && personOk;
      }
      return t.isActive &&
          roomOk &&
          personOk &&
          (t.isDueToday || t.isCompletedThisCycle);
    }).toList();

    final pending = visible.where((t) => !t.isDoneToday).toList();
    final completed = visible.where((t) => t.isDoneToday).toList();
    final done = completed.length;
    final roomNames = {for (final Room r in rooms) r.id: r.name};
    Widget buildRow(Task t) => TaskRow(
      key: ValueKey(t.id),
      task: t,
      users: users,
      roomName: roomNames[t.roomId],
      onToggle: () => _toggle(t),
      isEditMode: isEditMode,
      onDeleteTap: () => _deleteTask(t),
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
                      onPressed: () => setState(() => isEditMode = !isEditMode),
                    ),
                    const SizedBox(height: 16),
                    _ProgressCard(done: done, total: visible.length),
                    const SizedBox(height: 16),
                    // Room filter
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: _filter,
                          items: [
                            const DropdownMenuItem(
                              value: _all,
                              child: Text(_all),
                            ),
                            for (final r in rooms)
                              DropdownMenuItem(
                                value: r.name,
                                child: Text(r.name),
                              ),
                          ],
                          onChanged: (v) => setState(() => _person = v ?? _all),
                        ),
                        const SizedBox(width: 16),
                        // Person filter
                        DropdownButton<String>(
                          value: _person,
                          items: [
                            const DropdownMenuItem(
                              value: _all,
                              child: Text(_all),
                            ),
                            for (final u in users)
                              DropdownMenuItem(
                                value: u.name,
                                child: Text(u.name),
                              ),
                          ],
                          onChanged: (v) => setState(() => _person = v ?? _all),
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
                // Pending
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  sliver: SliverList.builder(
                    itemCount: pending.length,
                    itemBuilder: (_, i) => buildRow(pending[i]),
                  ),
                ),

                // Completed header
                if (completed.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            setState(() => _showCompleted = !_showCompleted),
                        child: Row(
                          children: [
                            Text(
                              'Completed',
                              style: AppText.body(
                                14,
                                weight: FontWeight.w800,
                                color: AppColors.ink.withValues(alpha: 0.55),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              _showCompleted
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: AppColors.ink.withValues(alpha: 0.55),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Completed rows
                if (completed.isNotEmpty && _showCompleted)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList.builder(
                      itemCount: completed.length,
                      itemBuilder: (_, i) => buildRow(completed[i]),
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

class _TopBar extends StatelessWidget {
  final VoidCallback onPressed;

  const _TopBar({required this.onPressed});

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
        IconButton(icon: const Icon(Icons.edit), onPressed: onPressed),
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
