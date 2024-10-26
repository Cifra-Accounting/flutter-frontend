import 'dart:math';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';
import 'package:flutter/material.dart';

@immutable
class C1fraNavigationBar extends StatelessWidget {
  const C1fraNavigationBar({
    super.key,
    required this.index,
    required this.leading,
    required this.trailing,
    required this.onTap,
    required this.onPlusTap,
  }) : assert(index < 1, "Index can't be higher than 1");

  final int index;
  final Widget leading;
  final Widget trailing;

  final void Function(int index) onTap;
  final VoidCallback onPlusTap;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final double horizontalPadding = (screenSize.width - 80) / 2;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        CustomPaint(
          size: const Size.fromHeight(NumericConstants.navBarHeight),
          painter: _C1fraNavBarPainter(
            color: colorScheme.secondary,
          ),
        ),
        SizedBox(
          height: NumericConstants.navBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: horizontalPadding,
                child: leading,
              ),
              const Expanded(
                child: SizedBox(
                  height: 0,
                ),
              ),
              SizedBox(
                width: horizontalPadding,
                child: trailing,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Ink(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary,
            ),
            height: 60,
            width: 60,
            child: IconButton(
              onPressed: onPlusTap,
              icon: Icon(
                C1fraIcons.plus,
                color: colorScheme.surface,
                size: 25,
              ),
            ),
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

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..lineTo(size.width / 2 - 40, 0)
      ..arcTo(
        Rect.fromPoints(
          Offset(size.width / 2 - 70, 0),
          Offset(size.width / 2 - 40, 30),
        ),
        -pi / 2,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromPoints(
          Offset(size.width / 2 - 40, -25),
          Offset(size.width / 2 + 40, 55),
        ),
        -pi,
        -pi,
        false,
      )
      ..arcTo(
        Rect.fromPoints(
          Offset(size.width / 2 + 40, 0),
          Offset(size.width / 2 + 70, 30),
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
