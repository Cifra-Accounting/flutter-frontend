import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
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
            threshold: .7,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Swipable(
                  key: ValueKey(1),
                  onSwiped: (Key key) {},
                  spacing: 5.0,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  swiped: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.stop_circle),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                  ),
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

class Swipable extends MultiChildRenderObjectWidget {
  Swipable({
    required super.key,
    this.threshold = 0.5,
    this.borderRadius,
    double? spacing,
    required this.onSwiped,
    required Widget swiped,
    required Widget child,
  }) : super(children: [
          child,
          if (spacing != null) SizedBox(width: spacing),
          swiped,
        ]);

  final void Function(Key key) onSwiped;
  final double threshold;
  final BorderRadius? borderRadius;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _SwipableRenderObject(onSwiped, key!, threshold, borderRadius);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _SwipableRenderObject)
      ..onSwiped = onSwiped
      ..key = key!
      ..threshold = threshold
      ..borderRadius = borderRadius;
  }
}

class _SwipableRenderObject extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, SwipableParentData>
    implements TickerProvider {
  _SwipableRenderObject(
    this.onSwiped,
    this.key,
    this.threshold,
    BorderRadius? borderRadius,
  ) : _borderRadius = borderRadius;

  void Function(Key key) onSwiped;
  Key key;
  double threshold;

  BorderRadius? _borderRadius;

  set borderRadius(BorderRadius? newBorderRadius) {
    _borderRadius = newBorderRadius;

    markNeedsPaint();
  }

  double _offset = 0.0;

  Ticker? _ticker;

  late final AnimationController _controller;
  late final Animation _animation;

  late final HorizontalDragGestureRecognizer _recognizer;

  final LayerHandle<ClipRRectLayer> _clipRRectLayer =
      LayerHandle<ClipRRectLayer>();

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _controller = AnimationController(
      vsync: this,
      duration: Durations.medium1,
    );

    _animation = _controller.drive(
      Tween(begin: 1.0, end: 0.0).chain(
        CurveTween(curve: Curves.easeIn),
      ),
    )..addListener(_animationListener);

    _recognizer = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd;
  }

  void _animationListener() {
    _offset *= _animation.value;

    layoutChildren();
    markNeedsPaint();
  }

  void _handleDragStart(DragStartDetails detailts) {
    _controller.reset();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _offset = (_offset + details.primaryDelta!).clamp(-size.width, 0.0);

    if (_offset.abs() == size.width * threshold) HapticFeedback.mediumImpact();

    layoutChildren();
    markNeedsPaint();
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_offset.abs() > size.width * threshold) onSwiped.call(key);

    _controller.forward();
  }

  @override
  void detach() {
    _animation.removeListener(_animationListener);
    _controller.dispose();
    _recognizer.dispose();

    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SwipableParentData) {
      child.parentData = SwipableParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.constrain(constraints.biggest);

    layoutChildren();
  }

  void layoutChildren() {
    RenderBox? child = firstChild;
    double width = size.width + _offset.abs();

    while (child != null) {
      final SwipableParentData? parentData =
          child.parentData as SwipableParentData?;

      final BoxConstraints childConstraints;

      if (parentData?.previousSibling != null) {
        childConstraints = BoxConstraints.loose(Size(width, size.height));
      } else {
        childConstraints = BoxConstraints.tight(size);
      }

      child.layout(childConstraints, parentUsesSize: true);

      width -= child.size.width;

      child = parentData?.nextSibling;
    }
  }

  @override
  bool hitTestSelf(Offset position) => size.contains(position);

  @override
  void handleEvent(
    PointerEvent event,
    covariant HitTestEntry<HitTestTarget> entry,
  ) {
    if (entry.target == this && event is PointerDownEvent) {
      _recognizer.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect bounds = offset & size;
    final RRect rrect = _borderRadius?.toRRect(bounds) ??
        RRect.fromRectAndRadius(bounds, Radius.zero);

    _clipRRectLayer.layer = context.pushClipRRect(
      needsCompositing,
      offset,
      bounds,
      rrect,
      _paintChild,
      oldLayer: _clipRRectLayer.layer,
    );
  }

  void _paintChild(PaintingContext context, Offset offset) {
    Offset childOffset = offset.translate(_offset, 0.0);

    RenderBox? child = firstChild;

    while (child != null) {
      final SwipableParentData? parentData =
          child.parentData as SwipableParentData?;

      if (parentData?.previousSibling != null) {
        childOffset = childOffset.translate(
          parentData!.previousSibling!.size.width,
          0.0,
        );
      }

      context.paintChild(child, childOffset);

      child = parentData?.nextSibling;
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker ??= Ticker(onTick);
    return _ticker!;
  }
}

class SwipableParentData extends ContainerBoxParentData<RenderBox> {}
