import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/models/task.dart';
import 'package:yarn/providers/spool_provider.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/room_palette.dart';
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

  /// Monday 00:00 of the current week (local time).
  DateTime get _weekStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - (now.weekday - 1));
  }

  /// Approximation: Task only stores `lastCompleted`, so a chore counts as
  /// done this week if it was last completed on/after Monday.
  bool _doneThisWeek(Task t) {
    final c = t.lastCompleted?.toLocal();
    return c != null && !c.isBefore(_weekStart);
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
      for (final c in draft.starters) {
        await provider.addTask(
          Task(
            id: '', // server assigns
            createdBy: user,
            name: c.title,
            repUnit: c.repeat.name,
            every: c.every,
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
                        done: roomTasks.where(_doneThisWeek).length,
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
