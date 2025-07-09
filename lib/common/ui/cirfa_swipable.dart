import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class C1fraSwipable extends SingleChildRenderObjectWidget {
  const C1fraSwipable({
    super.key,
    required this.icon,
    required this.iconColor,
    this.iconSize,
    this.spacing = 0.0,
    this.decoration,
    this.color,
    this.onSwiped,
    this.threshold = 0.5,
    required super.child,
  }) : assert(
          color != null || decoration != null,
          "Either color or decoration should be set",
        );

  final IconData icon;
  final Color iconColor;
  final double? iconSize;
  final double spacing;
  final VoidCallback? onSwiped;
  final BoxDecoration? decoration;
  final Color? color;
  final double threshold;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _C1fraSwipableRenderObject(
        icon,
        iconColor,
        iconSize,
        spacing,
        decoration,
        color,
        threshold,
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
    if (renderObject.iconColor != iconColor) {
      renderObject.iconColor = iconColor;
    }
    if (renderObject.iconSize != iconSize) {
      renderObject.iconSize = iconSize;
    }
    if (renderObject.spacing != spacing) {
      renderObject.spacing = spacing;
    }
    if (renderObject.decoration != decoration) {
      renderObject.decoration = decoration;
    }
    if (renderObject.color != color) {
      renderObject.color = color;
    }
    renderObject
      ..threshold = threshold
      ..onSwiped = onSwiped;
  }
}

class _C1fraSwipableRenderObject extends RenderProxyBox
    implements TickerProvider {
  _C1fraSwipableRenderObject(
    IconData icon,
    Color iconColor,
    double? iconSize,
    double spacing,
    BoxDecoration? decoration,
    Color? color,
    this.threshold,
    this.onSwiped,
  )   : _icon = icon,
        _iconColor = iconColor,
        _spacing = spacing,
        _color = color,
        _decoration = decoration;

  final LayerHandle<ClipPathLayer> _clipPathLayer =
      LayerHandle<ClipPathLayer>();
  final TextPainter _textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  TextStyle? _lastTextStyle;

  HorizontalDragGestureRecognizer? _recognizer;

  Ticker? _ticker;
  AnimationController? _controller;
  Animation? _animation;

  VoidCallback? onSwiped;
  double threshold;

  IconData _icon;

  set icon(IconData icon) {
    _icon = icon;
    markNeedsPaint();
  }

  IconData get icon => _icon;

  Color _iconColor;

  set iconColor(Color iconColor) {
    _iconColor = iconColor;
    markNeedsPaint();
  }

  Color get iconColor => _iconColor;

  double? _iconSize;

  set iconSize(double? iconSize) {
    _iconSize = iconSize;
    markNeedsPaint();
  }

  double? get iconSize => _iconSize;

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

  Color? _color;

  set color(Color? color) {
    _color = color;
    markNeedsPaint();
  }

  Color? get color => _color;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _controller = AnimationController(
      vsync: this,
      duration: Durations.short4,
    );

    _recognizer = HorizontalDragGestureRecognizer()
      ..onStart = _handleOnStart
      ..onUpdate = _handleOnUpdate
      ..onEnd = _handleOnEnd;
  }

  @override
  void detach() {
    _controller?.dispose();
    _recognizer?.dispose();
    _textPainter.dispose();

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
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    final ParentData? parentData = child.parentData;
    if (parentData is SwipableParentData) {
      final Offset offset = parentData.offset;
      final Matrix4 transalte = Matrix4.translationValues(
        offset.dx,
        offset.dy,
        0.0,
      );

      transform.multiply(transalte);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final BorderRadius? resolvedRadius = decoration?.borderRadius?.resolve(
      TextDirection.ltr,
    );
    final RRect rrect = RRect.fromRectAndCorners(
      offset & size,
      topLeft: resolvedRadius?.topLeft ?? Radius.zero,
      bottomLeft: resolvedRadius?.bottomLeft ?? Radius.zero,
      topRight: Radius.zero,
      bottomRight: Radius.zero,
    );

    _clipPathLayer.layer = context.pushClipPath(
      needsCompositing,
      offset,
      offset & size,
      Path()..addRRect(rrect),
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

      final BorderRadius? resolvedRadius = decoration?.borderRadius?.resolve(
        TextDirection.ltr,
      );
      final RRect rrect = RRect.fromRectAndCorners(
        swipedRect,
        topLeft: resolvedRadius?.topLeft ?? Radius.zero,
        topRight: resolvedRadius?.topRight ?? Radius.zero,
        bottomRight: resolvedRadius?.bottomRight ?? Radius.zero,
        bottomLeft: resolvedRadius?.bottomLeft ?? Radius.zero,
      );

      child?.paint(context, childOffset);

      context.canvas.drawPath(
        Path()..addRRect(rrect),
        Paint()..color = decoration?.color ?? _color!,
      );

      final double alpha = (swipedRect.width / (size.width * threshold)).clamp(
        0.0,
        1.0,
      );

      if (_lastTextStyle?.color?.a != alpha || _lastTextStyle == null) {
        _lastTextStyle = TextStyle(
          fontSize: _iconSize,
          fontFamily: _icon.fontFamily,
          package: _icon.fontPackage,
          color: _iconColor.withValues(alpha: alpha),
        );

        _textPainter.text = TextSpan(
          text: String.fromCharCode(_icon.codePoint),
          style: _lastTextStyle,
        );
        _textPainter.layout(maxWidth: size.width);
      }

      final Size textSize = _textPainter.size;
      final double dx =
          swipedRect.left + (swipedRect.width - textSize.width) / 2;
      final double dy =
          swipedRect.top + (swipedRect.height - textSize.height) / 2;

      _textPainter.paint(context.canvas, Offset(dx, dy));
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
        -(size.width + _spacing) * (_animation?.value ?? 1.0),
        0.0,
      );
      final Rect swipedRect = parentData.swipedRect.copyWith(
        left: (offset.dx + size.width + _spacing).clamp(0.0, size.width),
      );
      child?.parentData = SwipableParentData(offset, swipedRect);
    }

    markNeedsPaint();
  }

  void _handleOnStart(DragStartDetails details) {
    _animation?.removeListener(_animationListener);
    _animation = null;
    _controller?.reset();
  }

  void _handleOnUpdate(DragUpdateDetails details) {
    final ParentData? parentData = child?.parentData;
    if (parentData is SwipableParentData) {
      final Offset offset = Offset(
        (parentData.offset.dx + details.delta.dx).clamp(
          -size.width - _spacing,
          0.0,
        ),
        0.0,
      );
      final Rect swipedRect = parentData.swipedRect.copyWith(
        left: (size.width + offset.dx + _spacing).clamp(0.0, size.width),
      );

      if (offset.dx.abs() + _spacing / 2 > size.width * threshold) {
        HapticFeedback.selectionClick();
      }

      child?.parentData = SwipableParentData(offset, swipedRect);
    }

    markNeedsPaint();
  }

  void _handleOnEnd(DragEndDetails details) {
    final ParentData? parentData = child?.parentData;
    if (parentData is! SwipableParentData) return;

    if (parentData.offset.dx.abs() + _spacing / 2 >= size.width * threshold) {
      final current = parentData.offset.dx.abs() / (size.width + _spacing);
      final target = 1.0;

      _animation = _controller?.drive(Tween(begin: current, end: target))
        ?..addListener(_animationListener);

      _controller?.fling().then((_) => onSwiped?.call());
    } else {
      final current = parentData.offset.dx.abs() / (size.width + _spacing);
      final target = 0.0;

      _animation = _controller?.drive(Tween(begin: current, end: target))
        ?..addListener(_animationListener);

      _controller?.fling();
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
