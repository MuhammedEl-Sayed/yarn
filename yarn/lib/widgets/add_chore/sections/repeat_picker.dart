import 'package:flutter/material.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/widgets/add_chore/chore_models.dart';

/// Once / Daily / Weekly / Monthly / Yearly.
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
    Repeat.day: 'Daily',
    Repeat.week: 'Weekly',
    Repeat.month: 'Monthly',
    Repeat.year: 'Yearly',
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
                    style: AppText.body(13, weight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            if (entry.key != Repeat.year)
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

/// "Every [-] 2 [+] weeks"
class IntervalStepper extends StatelessWidget {
  final Repeat repeat;
  final int value;
  final ValueChanged<int> onChanged;

  const IntervalStepper({
    super.key,
    required this.repeat,
    required this.value,
    required this.onChanged,
  });

  static const _units = {
    Repeat.day: 'day',
    Repeat.week: 'week',
    Repeat.month: 'month',
    Repeat.year: 'year',
  };

  @override
  Widget build(BuildContext context) {
    final unit = _units[repeat] ?? '';
    final label = AppText.body(15, weight: FontWeight.w800);
    return Row(
      children: [
        Text('Every', style: label),
        const SizedBox(width: 12),
        _StepButton(
          icon: Icons.remove,
          onTap: value > 1 ? () => onChanged(value - 1) : null,
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              '$value',
              style: AppText.body(16, weight: FontWeight.w800),
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onTap: value < 99 ? () => onChanged(value + 1) : null,
        ),
        const SizedBox(width: 12),
        Text(value == 1 ? unit : '${unit}s', style: label),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.ink.withValues(alpha: onTap == null ? 0.3 : 1),
        ),
      ),
    );
  }
}

/// Weekday circles. Index 0 = Monday, matching `TaskUtils.dayToInt - 1`.
class WeekdayPicker extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<int> onToggle;

  const WeekdayPicker({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  /// What is stored. Unique, so Tue/Thu and Sat/Sun can't be confused.
  static const codes = ['M', 'T', 'W', 'TH', 'F', 'S', 'SU'];

  /// What is shown.
  static const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < labels.length; i++)
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
                labels[i],
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

/// "Monthly on day 15" / "Monthly on the last day" dropdown.
/// 31 means "last day" (the date math clamps it to the month's length).
class MonthDayPicker extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;

  const MonthDayPicker({super.key, required this.value, required this.onChanged});

  static final _options = [for (var d = 1; d <= 28; d++) d, 31];

  @override
  Widget build(BuildContext context) {
    final raw = value ?? DateTime.now().day;
    final shown = raw > 28 ? 31 : raw;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: shown,
          style: AppText.body(14, weight: FontWeight.w800),
          items: [
            for (final d in _options)
              DropdownMenuItem(
                value: d,
                child: Text(
                  d == 31 ? 'Monthly on the last day' : 'Monthly on day $d',
                ),
              ),
          ],
          onChanged: (d) {
            if (d != null) onChanged(d);
          },
        ),
      ),
    );
  }
}
