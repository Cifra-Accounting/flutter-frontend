import 'dart:math';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/material.dart';

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
          const Expanded(
            child: SizedBox(
              height: 0,
            ),
          ),
          trailing!,
        ];

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: _C1fraAppBarPainter(
                color: Theme.of(context).colorScheme.secondary,
              ),
              size: Size.fromHeight(preferredSize.height),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NumericConstants.horizontalPadding,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _effectiveChildren,
              ),
            ),
          ],
        ),
      );
}

class _C1fraAppBarPainter extends CustomPainter {
  const _C1fraAppBarPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Size localSize = Size(size.width, size.height * 2);

    final Path path = Path()
      ..lineTo(localSize.width, 0)
      ..lineTo(localSize.width, localSize.height)
      ..arcTo(
        Rect.fromPoints(
          Offset(localSize.width - localSize.height, localSize.height / 2),
          Offset(localSize.width, localSize.height + localSize.height / 2),
        ),
        0,
        -pi / 2,
        false,
      )
      ..lineTo(localSize.width - localSize.height / 2, localSize.height / 2)
      ..arcTo(
        Rect.fromPoints(
          Offset(0, localSize.height / 2),
          Offset(localSize.height, localSize.height + localSize.height / 2),
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
