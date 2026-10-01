import 'package:flutter/material.dart';
import 'package:yarn/theme/app_text.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Text(title, style: AppText.display(28))),
    );
  }
}
