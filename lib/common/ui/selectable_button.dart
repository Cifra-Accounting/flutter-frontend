import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    this.onTap,
    this.decoration,
    required this.tooltip,
    required this.content,
  });

  final VoidCallback? onTap;
  final BoxDecoration? decoration;
  final String tooltip;
  final Widget content;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final FocusNode _focusNode;

  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  late ColorScheme colorScheme;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    colorScheme = Theme.of(context).colorScheme;
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _handleFocusChange() => setState(() {
        if (_focusNode.hasFocus) {
          _tooltipKey.currentState?.ensureTooltipVisible();
        } else {
          Tooltip.dismissAllToolTips();
        }
      });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Tooltip(
      key: _tooltipKey,
      preferBelow: true,
      message: widget.tooltip,
      triggerMode: TooltipTriggerMode.manual,
      child: SizedBox(
        height: 63,
        width: double.infinity,
        child: Material(
          color: widget.decoration?.color ??
              themeData.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            side: _focusNode.hasFocus
                ? BorderSide(color: colorScheme.outline, width: 2.0)
                : BorderSide.none,
            borderRadius: widget.decoration?.borderRadius ??
                BorderRadius.circular(
                  cardBorderRadius / 2.0,
                ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            focusNode: _focusNode,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}
