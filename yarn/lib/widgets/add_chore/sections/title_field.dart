import 'package:flutter/material.dart';
import 'package:yarn/theme/app_text.dart';
import 'package:yarn/theme/app_colors.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  const TitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.ink, width: 2),
    );

    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      style: AppText.body(18),
      decoration: InputDecoration(
        labelText: 'What needs doing?',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: AppText.body(12, weight: FontWeight.w800),
        floatingLabelStyle: AppText.body(12, weight: FontWeight.w800),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
