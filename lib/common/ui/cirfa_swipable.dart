import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class C1fraSwipable extends SingleChildRenderObjectWidget {
  const C1fraSwipable({
    super.key,
    required this.icon,
    this.spacing = 0.0,
    this.decoration,
    this.onSwiped,
    required super.child,
  });

  final IconData icon;
  final double spacing;
  final VoidCallback? onSwiped;
  final BoxDecoration? decoration;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _C1fraSwipableRenderObject(
        icon,
        spacing,
        decoration,
        onSwiped,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    renderObject as _C1fraSwipableRenderObject;

    if (renderObject.icon != icon) {
      renderObject.icon = icon;
    }
    if (renderObject.spacing != spacing) {
      renderObject.spacing = spacing;
    }
    if (renderObject.decoration != decoration) {
      renderObject.decoration = decoration;
    }
    if (renderObject.onSwiped != onSwiped) {
      renderObject.onSwiped = onSwiped;
    }
  }
}

class _C1fraSwipableRenderObject extends RenderProxyBox
    implements TickerProvider {
  _C1fraSwipableRenderObject(
    IconData icon,
    double spacing,
    BoxDecoration? decoration,
    this.onSwiped,
  )   : _icon = icon,
        _spacing = spacing,
        _decoration = decoration;

  final LayerHandle<ClipPathLayer> _clipPathLayer =
      LayerHandle<ClipPathLayer>();
  late final TextPainter _textPainter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(_icon.codePoint),
      style: TextStyle(
        fontFamily: _icon.fontFamily,
        package: _icon.fontPackage,
        color: Colors.white,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  HorizontalDragGestureRecognizer? _recognizer;

  Ticker? _ticker;
  AnimationController? _controller;
  Animation? _animation;

  VoidCallback? onSwiped;
  IconData _icon;

  set icon(IconData icon) {
    _icon = icon;
    markNeedsPaint();
  }

  IconData get icon => _icon;

  double _spacing;

  set spacing(double spacing) {
    _spacing = spacing;
    markNeedsPaint();
  }

  double get spacing => _spacing;

  BoxDecoration? _decoration;

  set decoration(BoxDecoration? decoration) {
    _decoration = decoration;
    markNeedsPaint();
  }

  BoxDecoration? get decoration => _decoration;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _controller = AnimationController(vsync: this, duration: Durations.short4);

    _animation = _controller?.drive(
      Tween(begin: 1.0, end: 0.0).chain(
        CurveTween(curve: Curves.easeIn),
      ),
    )?..addListener(_animationListener);

    _recognizer = HorizontalDragGestureRecognizer()
      ..onStart = _handleOnStart
      ..onUpdate = _handleOnUpdate
      ..onEnd = _handleOnEnd;
  }

  @override
  void detach() {
    _controller?.dispose();
    _recognizer?.dispose();

    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SwipableParentData) {
      child.parentData = SwipableParentData(Offset.zero, Rect.zero);
    }
  }

  @override
  void performLayout() {
    child?.layout(constraints, parentUsesSize: true);
    size = child?.size ?? Size.zero;
    _textPainter.layout(maxWidth: size.width);

    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData) {
      child?.parentData = SwipableParentData(
        Offset.zero,
        Offset(size.width, 0.0) & Size(0.0, size.height),
      );
    }

    super.performLayout();
  }

  @override
  bool hitTestSelf(Offset position) => size.contains(position);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData) {
      if ((parentData.offset & size).contains(position)) {
        result.addWithPaintOffset(
          offset: parentData.offset,
          position: position,
          hitTest: (result, position) =>
              child!.hitTest(result, position: position),
        );
        return true;
      }
    }
    return false;
  }

  @override
  void handleEvent(
    PointerEvent event,
    covariant HitTestEntry<HitTestTarget> entry,
  ) {
    if (entry.target == this && event is PointerDownEvent) {
      _recognizer?.addPointer(event);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _clipPathLayer.layer = context.pushClipPath(
      needsCompositing,
      offset,
      offset & size,
      Path()
        ..addRRect(
          decoration?.borderRadius
                  ?.resolve(TextDirection.ltr)
                  .toRRect(offset & size) ??
              RRect.fromRectAndRadius(
                offset & size,
                Radius.zero,
              ),
        ),
      _childPainter,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      oldLayer: _clipPathLayer.layer,
    );
  }

  void _childPainter(PaintingContext context, Offset offset) {
    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData) {
      final Offset childOffset = offset + parentData.offset;
      final Rect swipedRect = parentData.swipedRect.translate(
        offset.dx,
        offset.dy,
      );

      child?.paint(context, childOffset);

      context.canvas.drawPath(
        Path()
          ..addRRect(
            decoration?.borderRadius
                    ?.resolve(TextDirection.ltr)
                    .toRRect(swipedRect) ??
                RRect.fromRectAndRadius(
                  swipedRect,
                  Radius.zero,
                ),
          ),
        Paint()..color = decoration?.color ?? Colors.red,
      );

      _textPainter.paint(context.canvas, swipedRect.center);
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker ??= Ticker(onTick);
    return _ticker!;
  }

  void _animationListener() {
    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData) {
      final Offset offset = Offset(
        parentData.offset.dx * (_animation?.value ?? 1.0),
        0.0,
      );
      final Rect swipedRect = parentData.swipedRect.copyWith(
        left: (size.width + offset.dx + spacing).clamp(0.0, size.width),
      );
      child?.parentData = SwipableParentData(offset, swipedRect);
    }

    markNeedsPaint();
  }

  void _handleOnStart(DragStartDetails details) => _controller?.reset();

  void _handleOnUpdate(DragUpdateDetails details) {
    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData) {
      final Offset offset = Offset(
        (parentData.offset.dx + details.delta.dx)
            .clamp(-size.width - _spacing, 0.0),
        0.0,
      );
      final Rect swipedRect = parentData.swipedRect.copyWith(
        left: (size.width + offset.dx + spacing).clamp(0.0, size.width),
      );

      if (offset.dx.abs() > size.width * 0.3) HapticFeedback.selectionClick();

      child?.parentData = SwipableParentData(offset, swipedRect);
    }

    markNeedsPaint();
  }

  void _handleOnEnd(DragEndDetails details) {
    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData &&
        parentData.offset.dx.abs() >= size.width * 0.4) {
      onSwiped?.call();
      _controller?.reverse();
    } else {
      _controller?.forward();
    }
  }
}

extension CopyRect on Rect {
  Rect copyWith({double? left, double? right, double? top, double? bottom}) =>
      Rect.fromLTRB(
        left ?? this.left,
        top ?? this.top,
        right ?? this.right,
        bottom ?? this.bottom,
      );
}

class SwipableParentData extends ParentData {
  SwipableParentData(this.offset, this.swipedRect);

  final Offset offset;
  final Rect swipedRect;
}
