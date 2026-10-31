import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/room_palette.dart';
import 'package:yarn/utils/task_utils.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/widgets/add_room/add_room_sheet.dart';
import 'package:yarn/widgets/screens/rooms/room_details_screen.dart';
import 'package:yarn/widgets/ui/room_card.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpoolProvider>().init();
    });
  }

  void _openRoom(String roomId) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RoomDetailsScreen(roomId: roomId)),
    );
  }

  Future<void> _openAddRoom() async {
    final provider = context.read<SpoolProvider>();
    final draft = await showAddRoomSheet(
      context,
      people: provider.users,
      nextColorIndex: provider.rooms.length,
    );
    if (draft == null || !mounted) return;

    final user = dotenv.env['SPOOL_USER'] ?? 'me';
    try {
      final room = await provider.addRoom(
        Room(
          id: '', // server assigns
          name: draft.name,
          createdBy: user,
          colorIndex: draft.colorIndex,
          icon: draft.icon,
        ),
      );
      // Pin starters to today's weekday / day of month, the same defaults
      // the chore sheet uses.
      final now = DateTime.now();
      for (final c in draft.starters) {
        await provider.addTask(
          Task(
            id: '', // server assigns
            createdBy: user,
            name: c.title,
            repUnit: c.repeat.name,
            every: c.every,
            repeatsOn: c.repeat == Repeat.week
                ? [TaskUtils.dayCode(now.weekday)]
                : const [],
            monthlyOn: c.repeat == Repeat.month
                ? (now.day > 28 ? 31 : now.day)
                : null,
            roomId: room.id,
          ),
        );
      }
    } catch (e) {
      debugPrint('ADD ROOM FAILED: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Couldn't add room")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((SpoolProvider p) => p.tasks);
    final rooms = context.select((SpoolProvider p) => p.rooms);
    final error = context.select((SpoolProvider p) => p.error);
    final loading = context.select((SpoolProvider p) => p.loading);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: context.read<SpoolProvider>().init,
          child: CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 16),
                sliver: SliverToBoxAdapter(child: _TopBar()),
              ),
              if (rooms.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        loading ? 'Loading…' : error ?? 'No rooms yet.',
                        style: AppText.body(
                          14,
                          color: AppColors.ink.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.builder(
                    itemCount: rooms.length,
                    itemBuilder: (_, i) {
                      final r = rooms[i];
                      final roomTasks = tasks
                          .where((t) => t.roomId == r.id)
                          .toList();
                      return RoomCard(
                        key: ValueKey(r.id),
                        room: r,
                        color: roomColorAt(r.colorIndex, i),
                        total: roomTasks.length,
                        done: roomTasks.where((t) => t.isDone).length,
                        due: roomTasks.where((t) => t.isDue).length,
                        onTap: () => _openRoom(r.id),
                      );
                    },
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverToBoxAdapter(
                  child: _AddRoomButton(onTap: _openAddRoom),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Expanded(child: Text('Rooms', style: AppText.display(32)))],
    );
  }
}

class _AddRoomButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddRoomButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          // Solid border; use the `dotted_border` package for true dashes.
          border: Border.all(color: AppColors.line, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: AppColors.ink.withValues(alpha: 0.55)),
            const SizedBox(width: 8),
            Text(
              'Add a room',
              style: AppText.body(
                15,
                weight: FontWeight.w800,
                color: AppColors.ink.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
