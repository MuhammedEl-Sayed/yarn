import 'package:flutter/material.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/widgets/add_chore/sections/shared.dart';

class RoomPicker extends StatelessWidget {
  final List<RoomOption> rooms;
  final String? selectedId;
  final ValueChanged<String> onChanged;

  const RoomPicker({
    super.key,
    required this.rooms,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final r in rooms)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(r.id),
                child: Column(
                  children: [
                    SelectionRing(
                      selected: selectedId == r.id,
                      child: YarnBall(color: r.color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      r.label,
                      style: AppText.body(
                        11,
                        color: AppColors.muted,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
