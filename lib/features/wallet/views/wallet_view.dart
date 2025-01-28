import 'package:cifra_app/common/ui/utils/blank_spacer.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_card.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/rendering.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

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
          child: CustomScrollView(
            primary: true,
            slivers: [
              FadingSliver(
                child: SpendingsCard(
                  onChanged: (period) {},
                ),
              ),
              const SliverToBoxAdapter(child: BlankSpacer()),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                  ),
                  height: 1500,
                ),
              ),
            ],
          ),
        ),
      );
}

@immutable
class FadingSliver extends SingleChildRenderObjectWidget {
  const FadingSliver({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _FadingRenderSliver();
}

class _FadingRenderSliver extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox> {
  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();
  final LayerHandle<OpacityLayer> _opacityLayer = LayerHandle<OpacityLayer>();
  final LayerHandle<ClipRRectLayer> _clipRRectLayer =
      LayerHandle<ClipRRectLayer>();

  Matrix4? _transform;
  int? _alpha;

  @override
  void performLayout() {
    _transform = null;
    _alpha = null;

    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final double paintedChildExtent = calculatePaintOffset(
      constraints,
      from: .0,
      to: childExtent,
    );

    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: .0,
      to: childExtent,
    );

    if (paintedChildExtent < childExtent && constraints.scrollOffset > .0) {
      final double percentage = paintedChildExtent / childExtent;

      final Offset translation = FractionalOffset.topCenter.alongSize(Size(
        child!.size.width,
        childExtent,
      ));

      _transform = Matrix4.identity()
        ..translate(translation.dx, translation.dy)
        ..scale(.7 + percentage * .3)
        ..translate(-translation.dx, -translation.dy);
      _alpha = (255 * (.9 + percentage * .1)).toInt();
    }

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hasVisualOverflow: false,
    );

    setupParentData(child!);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    child.parentData = SliverPhysicalParentData();
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;

    childParentData.paintOffset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      _paintTransform(context, offset);
    } else {
      _transformLayer.layer = null;
      _opacityLayer.layer = null;
      _clipRRectLayer.layer = null;
    }
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    if (_transform != null) {
      transform.multiply(_transform!);
    }
    final childParentData = child.parentData! as SliverPhysicalParentData;

    childParentData.applyPaintTransform(transform);
  }

  void _paintTransform(PaintingContext context, Offset offset) {
    _transformLayer.layer = context.pushTransform(
      needsCompositing,
      offset,
      _transform ?? Matrix4.identity(),
      _paintOpacity,
      oldLayer: _transformLayer.layer,
    );
  }

  void _paintOpacity(PaintingContext context, Offset offset) {
    _opacityLayer.layer = context.pushOpacity(
      offset,
      _alpha ?? 255,
      _paintClipRRect,
      oldLayer: _opacityLayer.layer,
    );
  }

  void _paintClipRRect(PaintingContext context, Offset offset) {
    final Rect rect = offset & Size(child!.size.width, geometry!.paintExtent);
    final RRect rRect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(cardBorderRadius),
    );

    _clipRRectLayer.layer = context.pushClipRRect(
      needsCompositing,
      offset,
      rect,
      rRect,
      _paintChild,
    );
  }

  void _paintChild(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);
  }
}
