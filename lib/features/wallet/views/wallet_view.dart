import 'package:flutter/material.dart';

import 'package:cifra_app/features/wallet/widgets/collapsing_header_scroll_view.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_card.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  final GlobalKey _spendingsCardKey = const GlobalObjectKey('spendingsCard');

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: topPadding,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(cardBorderRadius),
          ),
          child: CollapsingHeaderScrollView(
            headerWidget: SpendingsCard(
              key: _spendingsCardKey,
              onChanged: (_) {},
            ),
            headerKey: _spendingsCardKey,
            headerPadding: blankSpacerSize,
            threshhold: .7,
            children: <Widget>[
              SizedBox.square(
                dimension: 40,
                child: C1fraIcon(
                  icon: 33553759,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      );
}

class C1fraIcon extends LeafRenderObjectWidget {
  const C1fraIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  /// Binary representation of the [icon]
  ///
  /// Starting with top-left corner of the icon,
  /// each next bit after least significant bit represent
  /// whether the corresponding pixel is drawn or not
  final int icon;

  /// Color assigned to each drawn pixel
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _C1fraIconRenderObject(icon: icon, color: color);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _C1fraIconRenderObject).color = color;
    renderObject.icon = icon;
  }
}

class _C1fraIconRenderObject extends RenderBox {
  _C1fraIconRenderObject({
    required int icon,
    required Color color,
  })  : _icon = icon,
        _color = color;

  int _icon;
  Color _color;

  set icon(int newIcon) {
    _icon = newIcon;
    markNeedsPaint();
  }

  set color(Color newColor) {
    _color = newColor;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrain(Size.square(constraints.biggest.shortestSide));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Size pixelSize = Size.square((size * 3 / 16).shortestSide);
    final double spacing = pixelSize.longestSide / 12;

    final Paint filledPaint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        final bool filled = (1 << (i * 5 + j)) & _icon != 0;
        final Rect pixel = offset.translate(
              j * (pixelSize.width + spacing),
              i * (pixelSize.height + spacing),
            ) &
            pixelSize;
        if (filled) {
          context.canvas.drawRect(
            pixel,
            filledPaint,
          );
        }
      }
    }
  }
}
