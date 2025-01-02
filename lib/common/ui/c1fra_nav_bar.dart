import 'package:flutter/material.dart';

import 'dart:math';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';
import 'package:flutter/services.dart';

/// Custom C1fra NavigationBar compliant to the C1fra App UiKit
/// Background color - secondary
/// PlusButton color - primary
///
/// Setting [index] from 0 to 1 changes which of the two icons will be selected
///
/// You are required to provide two icons for the [leading] and [trailing]
///
/// [onTap] callback - recieves [int index] as its argument, representing which of the two
/// icons were triggered
///
/// [onPlusTap] callback - triggered onTap on the centered Plus Button
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

  Widget _buttonFromIcon(BuildContext context,
          {required Icon icon,
          required int index,
          required ColorScheme colorScheme}) =>
      Center(
        child: IconButton(
          onPressed: () {
            if (index == this.index) {
              PrimaryScrollController.of(context).animateTo(0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn);
            }
            onTap(index);
          },
          icon: icon,
          color: index == this.index
              ? colorScheme.onSurface
              : colorScheme.onSecondary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double additionalBottomPadding =
        MediaQuery.viewPaddingOf(context).bottom;

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final double halfNavBarSize =
        (screenSize.width - plusButtonOutlineSize) / 2;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: colorScheme.secondary.withValues(alpha: 0.8),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: navBarHeight * 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          CustomPaint(
            painter: _C1fraNavBarPainter(
              color: colorScheme.secondary,
            ),
            child: SizedBox(
              height: navBarHeight + additionalBottomPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: halfNavBarSize,
                    height: navBarHeight,
                    child: _buttonFromIcon(
                      context,
                      icon: leading,
                      index: 0,
                      colorScheme: colorScheme,
                    ),
                  ),
                  SizedBox(
                    width: halfNavBarSize,
                    height: navBarHeight,
                    child: _buttonFromIcon(
                      context,
                      icon: trailing,
                      index: 1,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20 + additionalBottomPadding,
            child: PlusButton(onTap: onPlusTap),
          ),
        ],
      ),
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
      ..lineTo((size.width - plusButtonOutlineSize - curveD) / 2, 0)
      ..arcTo(
        Rect.fromPoints(
          Offset((size.width - plusButtonOutlineSize) / 2 - curveD, 0),
          Offset((size.width - plusButtonOutlineSize) / 2, curveD),
        ),
        -pi / 2,
        pi / 2,
        false,
      )
      ..arcTo(
        Rect.fromPoints(
          Offset(
            (size.width - plusButtonOutlineSize) / 2,
            (curveD - plusButtonOutlineSize) / 2,
          ),
          Offset(
            (size.width + plusButtonOutlineSize) / 2,
            (curveD + plusButtonOutlineSize) / 2,
          ),
        ),
        pi,
        -pi,
        false,
      )
      ..arcTo(
        Rect.fromPoints(
          Offset(
            (size.width + plusButtonOutlineSize) / 2,
            0,
          ),
          Offset(
            (size.width + plusButtonOutlineSize) / 2 + curveD,
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
        plusButtonOutlineSize,
      ),
      child: Material(
        child: Ink(
          height: plusButtonSize,
          width: plusButtonSize,
          color: colorScheme.primary,
          child: IconButton(
            onPressed: onTap,
            icon: Icon(
              C1fraIcons.plus,
              color: colorScheme.surface,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
