import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

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

  /// The callback triggered when the DragEndEvent occured
  /// after the [threshold]
  final void Function(Key key) onSwiped;

  /// The theshold at which [onSwiped] gets triggered
  final double threshold;

  /// Border radius of the
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
