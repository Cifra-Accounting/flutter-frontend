import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

@immutable
class SpendingsIndicator extends LeafRenderObjectWidget {
  const SpendingsIndicator({super.key, this.percentage})
      : assert(percentage != null ? percentage >= 0 && percentage <= 1 : true,
            "Provided percentage doesn't fall into bound of 0 and 1 => percentage: $percentage");

  final double? percentage;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      SpendingsIndicatorRenderObject(percentage);

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    final SpendingsIndicatorRenderObject indicatorRenderObject =
        renderObject as SpendingsIndicatorRenderObject;
    indicatorRenderObject.percentage = percentage;
  }
}

class SpendingsIndicatorRenderObject extends RenderBox
    implements TickerProvider {
  SpendingsIndicatorRenderObject(this._percentage);

  double? _percentage;

  Ticker? _ticker;

  late final AnimationController _idleAnimationController;

  late int _numOfColumns;
  late double _horizontalColumnSpan;

  final Paint _setPixelPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;
  final Paint _pixelPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill;

  static final ColorTween _colorTween =
      ColorTween(begin: Colors.white, end: Colors.black);

  set percentage(double? newPercentage) {
    if (newPercentage == _percentage) return;

    if (newPercentage == null) {
      _percentage = newPercentage;
      _idleAnimationController.repeat();
    } else {
      _onIdleAnimationEnd().then<void>((_) {
        _percentage = newPercentage;
        _idleAnimationController.forward(
          from: _idleAnimationController.lowerBound,
        );
      });
    }

    markNeedsSemanticsUpdate();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _idleAnimationController = AnimationController(
      vsync: this,
      duration: Durations.extralong4,
    );
    _idleAnimationController
        .drive(Tween(begin: .0, end: 1.0))
        .addListener(markNeedsPaint);

    if (_percentage == null) {
      _idleAnimationController.repeat();
    } else {
      _idleAnimationController.forward(
        from: _idleAnimationController.lowerBound,
      );
    }
  }

  @override
  void detach() {
    _idleAnimationController.removeListener(markNeedsPaint);
    _idleAnimationController.dispose();

    super.detach();
  }

  @override
  Rect get semanticBounds => (Offset.zero & size);

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    config.hint = "Current ratio of the money spent to the money available";
    config.value = _percentage == null
        ? "Value is loading"
        : "Persentage showing is $_percentage";

    super.describeSemanticsConfiguration(config);
  }

  @override
  void performLayout() {
    final double width = constraints.maxWidth.isInfinite
        ? double.maxFinite
        : constraints.maxWidth;
    const double height = 15.0 * pixelSize + 14.0 * pixelSpacerSize;

    _numOfColumns =
        ((width - pixelSize) / (pixelSize + pixelSpacerSize) / 2.0).toInt() - 1;

    _horizontalColumnSpan = width / _numOfColumns;

    size = constraints.constrain(Size(width, height));
  }

  Future<void> _onIdleAnimationEnd() async {
    if (_idleAnimationController.isAnimating) {
      await _idleAnimationController
          .animateTo(_idleAnimationController.upperBound);
      _idleAnimationController.stop();
    }
  }

  Paint _getColumnPaint(int i) {
    final double columnPercentage = i / _numOfColumns;

    if (_percentage != null) {
      return columnPercentage <= _percentage! &&
              columnPercentage <= _idleAnimationController.value
          ? _setPixelPaint
          : _pixelPaint;
    } else {
      return Paint()
        ..style = PaintingStyle.fill
        ..color = _colorTween.lerp(
            (10.0 * (columnPercentage - _idleAnimationController.value).abs())
                .clamp(.0, 1.0))!;
    }
  }

  void _paintColumn(PaintingContext context, Offset offset, Paint paint) {
    for (int i = 0; i < 15; i++) {
      final Rect rect = (const Offset(.0, pixelSize + pixelSpacerSize)
                  .scale(.0, i.toDouble()) +
              offset) &
          const Size.square(pixelSize);

      context.canvas.drawRect(rect, paint);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int i = 0; i < _numOfColumns; i++) {
      final Offset effectiveOffset =
          offset + Offset(_horizontalColumnSpan, .0).scale(i.toDouble(), .0);
      final Paint effectivePaint = _getColumnPaint(i);

      _paintColumn(
        context,
        effectiveOffset,
        effectivePaint,
      );
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker ??= Ticker(onTick);
    return _ticker!;
  }
}
