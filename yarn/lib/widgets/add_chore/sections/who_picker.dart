import 'package:flutter/material.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/widgets/add_chore/sections/shared.dart';

class WhoPicker extends StatelessWidget {
  final List<PersonOption> people;

  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const WhoPicker({
    super.key,
    required this.people,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final p in people)
            _avatar(
              selected: selectedId == p.id,
              color: p.color,
              label: p.initial,
              labelColor: Colors.white,
              onTap: () => onChanged(p.id),
            ),
          _avatar(
            selected: selectedId == null,
            color: AppColors.unassigned,
            label: '?',
            labelColor: AppColors.muted,
            onTap: () => onChanged(null),
          ),
        ],
      ),
    );
  }

  Widget _avatar({
    required bool selected,
    required Color color,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: SelectionRing(
          selected: selected,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Text(
              label,
              style: AppText.body(
                15,
                weight: FontWeight.w800,
                color: labelColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
