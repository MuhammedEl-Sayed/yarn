import 'package:flutter/material.dart';
import 'package:yarn/theme/app_colors.dart';
import 'package:yarn/theme/app_text.dart';

/// A tappable header with a chevron that expands/collapses [children].
/// Used for room groups and the "Completed" list.
class CollapsibleSection extends StatefulWidget {
  final String title;
  final List<Widget> children;

  /// Optional widget before the title (e.g. a room color dot).
  final Widget? leading;

  /// Optional count shown after the title.
  final int? count;

  final bool initiallyExpanded;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry headerPadding;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.count,
    this.initiallyExpanded = true,
    this.titleStyle,
    this.headerPadding = const EdgeInsets.symmetric(vertical: 10),
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.ink.withValues(alpha: 0.55);
    final style =
        widget.titleStyle ??
        AppText.body(14, weight: FontWeight.w800, color: muted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: widget.headerPadding,
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 10),
                ],
                Text(widget.title, style: style),
                if (widget.count != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${widget.count}',
                    style: AppText.body(
                      13,
                      weight: FontWeight.w700,
                      color: muted,
                    ),
                  ),
                ],
                const Spacer(),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(Icons.expand_more, color: muted),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(children: widget.children)
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}
