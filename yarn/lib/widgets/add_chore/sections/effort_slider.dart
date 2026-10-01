import 'package:flutter/material.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/widgets/add_chore/sections/shared.dart';

class EffortSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const EffortSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final n = value.round();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionLabel('Effort'),
            Text(
              '$n ${n == 1 ? 'skein' : 'skeins'}',
              style: AppText.body(13, weight: FontWeight.w800),
            ),
          ],
        ),
        Slider(
          min: 1,
          max: 5,
          divisions: 4,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
