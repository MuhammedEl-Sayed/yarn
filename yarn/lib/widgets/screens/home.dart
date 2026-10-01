import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/widgets/add_chore/add_chore_sheet.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/widgets/ui/task_row.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tab = 0;
  int _filter = 0;
  static const _filters = ['All', 'Mine', 'Kitchen', 'Laundry', 'Bathroom'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpoolProvider>().init();
    });
  }

  List<RoomOption> _roomOptions() => const [];
  List<PersonOption> _personOptions() => const [];

  Future<void> _openAddChore() async {
    final draft = await showAddChoreSheet(
      context,
      rooms: _roomOptions(),
      people: _personOptions(),
    );
    if (draft == null || !mounted) return;
    // TODO: save via provider/repository
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<SpoolProvider>().tasks;
    // TODO: replace `isDone` with your Task model's actual field name
    final done = tasks.where((t) => true).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddChore,
        icon: const Icon(Icons.add),
        label: const Text('Cast on'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Week',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            const _TopBar(),
            const SizedBox(height: 16),
            _ProgressCard(done: done, total: tasks.length),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _FilterChip(
                  label: _filters[i],
                  selected: i == _filter,
                  onTap: () => setState(() => _filter = i),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // TODO: split into MORNING / EVENING once Task has a time field
            for (final t in tasks) TaskRow(task: t),
          ],
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
                'About 35 min left today', // TODO: sum remaining task minutes
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
