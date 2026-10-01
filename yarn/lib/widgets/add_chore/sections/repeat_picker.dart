import 'package:flutter/material.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/app_colors.dart';

class RepeatSegments extends StatelessWidget {
  final Repeat value;
  final ValueChanged<Repeat> onChanged;

  const RepeatSegments({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _labels = {
    Repeat.once: 'Once',
    Repeat.daily: 'Daily',
    Repeat.weekly: 'Weekly',
    Repeat.custom: 'Custom',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          for (final entry in _labels.entries) ...[
            Expanded(
              child: InkWell(
                onTap: () => onChanged(entry.key),
                child: Container(
                  alignment: Alignment.center,
                  color: value == entry.key
                      ? AppColors.selectedFill
                      : Colors.transparent,
                  child: Text(
                    entry.value,
                    style: AppText.body(14, weight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            if (entry.key != Repeat.custom)
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.line,
              ),
          ],
        ],
      ),
    );
  }
}

class WeekdayPicker extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<int> onToggle;

  const WeekdayPicker({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  static const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < letters.length; i++)
          GestureDetector(
            onTap: () => onToggle(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected.contains(i)
                    ? AppColors.accent
                    : Colors.transparent,
                border: Border.all(
                  color: selected.contains(i)
                      ? AppColors.accent
                      : AppColors.line,
                ),
              ),
              child: Text(
                letters[i],
                style: AppText.body(
                  14,
                  weight: FontWeight.w800,
                  color: selected.contains(i) ? Colors.white : AppColors.ink,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
