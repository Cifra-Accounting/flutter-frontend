import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';

import 'package:cifra_app/common/constants/numeric_constants.dart';

@immutable
class C1fraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const C1fraAppBar({
    super.key,
    required this.leading,
    this.trailing,
  });

  final Widget leading;
  final Widget? trailing;

  @override
  Size get preferredSize =>
      const Size.fromHeight(NumericConstants.appBarHeight);

  List<Widget> get _effectiveChildren => trailing == null
      ? <Widget>[
          leading,
        ]
      : <Widget>[
          leading,
          trailing!,
        ];

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _C1fraAppBarPainter(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: NumericConstants.horizontalPadding,
              ),
              height: preferredSize.height,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _effectiveChildren,
              ),
            ),
          ),
        ),
      );
}

class _C1fraAppBarPainter extends CustomPainter {
  const _C1fraAppBarPainter({
    required this.color,
  });

  final Color color;

  static const double curveD = 120;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..arcTo(
        Rect.fromPoints(
          Offset(size.width - curveD, size.height),
          Offset(size.width, size.height + curveD),
        ),
        0,
        -pi / 2,
        false,
      )
      ..lineTo(curveD, size.height)
      ..arcTo(
        Rect.fromPoints(
          Offset(0, size.height),
          Offset(curveD, size.height + curveD),
        ),
        -pi / 2,
        -pi / 2,
        false,
      )
      ..lineTo(0, 0)
      ..close();

    final Paint paint = Paint()..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _C1fraAppBarPainter oldDelegate) =>
      oldDelegate.color != color;
}
