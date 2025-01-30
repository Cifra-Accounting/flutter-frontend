import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

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
    with RenderObjectWithChildMixin<RenderBox>, RenderSliverHelpers {
  final Tween<double> _tween = Tween(begin: .9, end: 1.0);

  final LayerHandle<TransformLayer> _transformLayer =
      LayerHandle<TransformLayer>();
  final LayerHandle<OpacityLayer> _opacityLayer = LayerHandle<OpacityLayer>();
  final LayerHandle<ClipRRectLayer> _clipRRectLayer =
      LayerHandle<ClipRRectLayer>();

  Matrix4? _transform;
  int? _alpha;
  double? _factor;

  @override
  void performLayout() {
    _transform = null;
    _alpha = null;
    _factor = null;

    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    final double childMainAxisExtent;
    final double childCrossAxisExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childMainAxisExtent = child!.size.width;
        childCrossAxisExtent = child!.size.height;
        break;
      case Axis.vertical:
        childMainAxisExtent = child!.size.height;
        childCrossAxisExtent = child!.size.width;
        break;
    }

    final double paintedChildExtent = calculatePaintOffset(
      constraints,
      from: .0,
      to: childMainAxisExtent,
    );

    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: .0,
      to: childMainAxisExtent,
    );

    if (paintedChildExtent < childMainAxisExtent &&
        constraints.scrollOffset > .0) {
      final double percentage = paintedChildExtent / childMainAxisExtent;

      _factor = _tween.transform(percentage);

      final Offset translation;
      switch (constraints.axisDirection) {
        case AxisDirection.down:
          translation = FractionalOffset.topCenter.alongSize(Size(
            childCrossAxisExtent,
            childMainAxisExtent,
          ));
          break;
        case AxisDirection.up:
          translation = FractionalOffset.bottomCenter.alongSize(Size(
            childCrossAxisExtent,
            childMainAxisExtent,
          ));
          break;
        case AxisDirection.left:
          translation = FractionalOffset.centerRight.alongSize(Size(
            childCrossAxisExtent,
            childMainAxisExtent,
          ));
          break;
        case AxisDirection.right:
          translation = FractionalOffset.centerLeft.alongSize(Size(
            childCrossAxisExtent,
            childMainAxisExtent,
          ));
          break;
      }

      _transform = Matrix4.identity()
        ..translate(translation.dx, translation.dy)
        ..scale(_factor)
        ..translate(-translation.dx, -translation.dy);
      _alpha = (255 * _factor!).toInt();
    }

    geometry = SliverGeometry(
      scrollExtent: childMainAxisExtent,
      crossAxisExtent: childCrossAxisExtent,
      paintExtent: paintedChildExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: childMainAxisExtent,
      hasVisualOverflow: false,
    );

    _updateParentData(child!, geometry!);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    child.parentData = SliverPhysicalParentData();
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;

    childParentData.paintOffset = Offset.zero;
  }

  void _updateParentData(RenderObject child, SliverGeometry geometry) {
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;

    childParentData.paintOffset =
        Offset(geometry.crossAxisExtent! * (1.0 - (_factor ?? 1.0)) * .5, .0);
  }

  @override
  double childCrossAxisPosition(covariant RenderObject child) =>
      (child.parentData as SliverPhysicalParentData).paintOffset.dx;

  @override
  double childMainAxisPosition(covariant RenderObject child) =>
      (child.parentData as SliverPhysicalParentData).paintOffset.dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      _paintTransform(context, offset);
    } else {
      _transformLayer.layer = null;
      _opacityLayer.layer = null;
      _clipRRectLayer.layer = null;
      _paintChild(context, offset - Offset(.0, geometry!.scrollExtent));
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (child != null && geometry!.visible) {
      return hitTestBoxChild(
        BoxHitTestResult.wrap(result),
        child!,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );
    } else {
      return false;
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
    final Rect rect = offset &
        Size(child!.size.width,
            geometry!.paintExtent * (2.0 - (_factor ?? 1.0)));

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
