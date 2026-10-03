import 'package:flutter/material.dart';
import 'package:yarn/models/room.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/room_palette.dart';
import 'package:yarn/widgets/ui/skein_ball.dart';

/// Tappable room card: yarn ball, icon + name, "N chores · X of N this week",
/// progress bar and a chevron.
class RoomCard extends StatelessWidget {
  final Room room;
  final Color color;
  final int total;
  final int done;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.color,
    required this.total,
    required this.done,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFFFFFBF3),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                SkeinBall(color: color),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(roomIconFor(room.icon), size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              room.name,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.body(16, weight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$total ${total == 1 ? 'chore' : 'chores'}'
                        ' · $done of $total this week',
                        style: AppText.body(
                          13,
                          color: AppColors.ink.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          color: color,
                          backgroundColor: AppColors.line,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.ink.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
