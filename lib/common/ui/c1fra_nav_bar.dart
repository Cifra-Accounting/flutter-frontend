import 'package:flutter/material.dart';

import 'dart:math';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';

@immutable
class C1fraNavigationBar extends StatelessWidget {
  const C1fraNavigationBar({
    super.key,
    required this.index,
    required this.leading,
    required this.trailing,
    required this.onTap,
    required this.onPlusTap,
  }) : assert(index <= 1, "Index can't be higher than 1");

  final int index;
  final Icon leading;
  final Icon trailing;

  final void Function(int index) onTap;
  final VoidCallback onPlusTap;

  Widget _buttonFromIcon(
          {required Icon icon,
          required int index,
          required ColorScheme colorScheme}) =>
      Center(
        child: IconButton(
          onPressed: () => onTap(index),
          icon: icon,
          color: index == this.index
              ? colorScheme.onSurface
              : colorScheme.onSecondary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final double halfNavBarSize =
        (screenSize.width - NumericConstants.plusButtonOutlineSize) / 2;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        CustomPaint(
          painter: _C1fraNavBarPainter(
            color: colorScheme.secondary,
          ),
          child: SizedBox(
            height: NumericConstants.navBarHeight,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: halfNavBarSize,
                  child: _buttonFromIcon(
                    icon: leading,
                    index: 0,
                    colorScheme: colorScheme,
                  ),
                ),
                const Expanded(
                  child: SizedBox(
                    height: 0,
                  ),
                ),
                SizedBox(
                  width: halfNavBarSize,
                  child: _buttonFromIcon(
                    icon: trailing,
                    index: 1,
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: PlusButton(
            onTap: onPlusTap,
          ),
        ),
      ],
    );
  }
}

class _C1fraNavBarPainter extends CustomPainter {
  const _C1fraNavBarPainter({
    required this.color,
  });

  final Color color;

  static const double curveD = 30;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..lineTo(
          (size.width - NumericConstants.plusButtonOutlineSize - curveD) / 2, 0)
      ..arcTo(
        Rect.fromPoints(
          Offset(
              (size.width - NumericConstants.plusButtonOutlineSize) / 2 -
                  curveD,
              0),
          Offset((size.width - NumericConstants.plusButtonOutlineSize) / 2,
              curveD),
        ),
        -pi / 2,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromPoints(
          Offset(
            (size.width - NumericConstants.plusButtonOutlineSize) / 2,
            (curveD - NumericConstants.plusButtonOutlineSize) / 2,
          ),
          Offset(
            (size.width + NumericConstants.plusButtonOutlineSize) / 2,
            (curveD + NumericConstants.plusButtonOutlineSize) / 2,
          ),
        ),
        pi,
        -pi,
        false,
      )
      ..arcTo(
        Rect.fromPoints(
          Offset(
            (size.width + NumericConstants.plusButtonOutlineSize) / 2,
            0,
          ),
          Offset(
            (size.width + NumericConstants.plusButtonOutlineSize) / 2 + curveD,
            curveD,
          ),
        ),
        -pi,
        pi / 2,
        false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();

    final Paint paint = Paint()..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _C1fraNavBarPainter oldDelegate) =>
      oldDelegate.color != color;
}

class PlusButton extends StatelessWidget {
  const PlusButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        NumericConstants.plusButtonOutlineSize,
      ),
      child: Material(
        child: Ink(
          height: NumericConstants.plusButtonSize,
          width: NumericConstants.plusButtonSize,
          color: colorScheme.primary,
          child: IconButton(
            onPressed: onTap,
            icon: Icon(
              C1fraIcons.plus,
              color: colorScheme.surface,
              size: NumericConstants.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
