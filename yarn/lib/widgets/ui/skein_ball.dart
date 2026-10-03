import 'package:flutter/material.dart';
import 'package:yarn/theme/app_colors.dart';

class SkeinBall extends StatelessWidget {
  final Color color;
  const SkeinBall({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 62,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          // paper label wrapped around the skein
          Container(
            width: 14,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF3),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.line),
            ),
          ),
        ],
      ),
    );
  }
}
