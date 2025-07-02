import 'dart:math';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PixelBackground(
      settings: PixelBackgroundSettings(
        circleCount: 3,
        pixelSize: pixelSize * 2,
        pixelSpacerSize: pixelSpacerSize * 4,
        onPixelColor: Colors.white,
        offPixelColor: Colors.transparent,
      ),
    );
  }
}

class PixelBackgroundSettings extends Equatable {
  const PixelBackgroundSettings({
    required this.circleCount,
    required this.pixelSize,
    required this.pixelSpacerSize,
    required this.onPixelColor,
    required this.offPixelColor,
  });

  final int circleCount;
  final double pixelSize;
  final double pixelSpacerSize;
  final Color onPixelColor;
  final Color offPixelColor;

  PixelBackgroundSettings copyWith({
    int? circleCount,
    double? pixelSize,
    double? pixelSpacerSize,
    Color? onPixelColor,
    Color? offPixelColor,
  }) =>
      PixelBackgroundSettings(
        circleCount: circleCount ?? this.circleCount,
        pixelSize: pixelSize ?? this.pixelSize,
        pixelSpacerSize: pixelSpacerSize ?? this.pixelSpacerSize,
        onPixelColor: onPixelColor ?? this.onPixelColor,
        offPixelColor: offPixelColor ?? this.offPixelColor,
      );

  @override
  List<Object?> get props => [
        circleCount,
        pixelSize,
        pixelSpacerSize,
        onPixelColor,
        offPixelColor,
      ];
}

@immutable
class PixelBackground extends LeafRenderObjectWidget {
  const PixelBackground({super.key, required this.settings});

  final PixelBackgroundSettings settings;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      PixelBackgroundRenderObject(settings);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant PixelBackgroundRenderObject renderObject,
  ) {
    if (renderObject.settings != settings) renderObject.settings = settings;
  }
}

class PixelBackgroundRenderObject extends RenderBox {
  PixelBackgroundRenderObject(
    PixelBackgroundSettings settings,
  ) : _settings = settings;

  Ticker? _ticker;

  List<Circle>? _circles;
  int? uPixelCount;
  int? vPixelCount;
  double? uPixelSpacerSize;
  double? vPixelSpacerSize;

  PixelBackgroundSettings _settings;

  set settings(PixelBackgroundSettings settings) {
    if (_settings.circleCount != settings.circleCount ||
        _settings.pixelSize != settings.pixelSize ||
        _settings.pixelSpacerSize != settings.pixelSpacerSize) {
      markNeedsLayout();
    }
    _settings = settings;

    markNeedsPaint();
  }

  PixelBackgroundSettings get settings => _settings;

  ColorTween get _pixelTween => ColorTween(
        begin: _settings.offPixelColor,
        end: _settings.onPixelColor,
      );

  List<Circle> _createCircles() {
    final Random random = Random();

    return List.generate(
      _settings.circleCount,
      (_) {
        final Offset center = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );

        final Offset direction = Offset.fromDirection(
          random.nextDouble() * 2 * pi,
          random.nextDouble() * min(size.width, size.height),
        ).translate(center.dx, center.dy);

        return Circle(center: center, direction: direction);
      },
    );
  }

  void _onTick(Duration elapsed) {
    for (var circle in _circles ?? []) {
      final Offset movement = circle.direction * 0.01;
      circle.center += movement;

      if (circle.center.dx < 0 || circle.center.dx > size.width) {
        circle.direction = Offset(-circle.direction.dx, circle.direction.dy);
      }
      if (circle.center.dy < 0 || circle.center.dy > size.height) {
        circle.direction = Offset(circle.direction.dx, -circle.direction.dy);
      }
    }

    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _ticker = Ticker(_onTick)..start();
  }

  @override
  void detach() {
    _ticker?.dispose();
    _ticker = null;

    super.detach();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    uPixelCount =
        size.width ~/ (settings.pixelSize + settings.pixelSpacerSize * 2);
    vPixelCount =
        size.height ~/ (settings.pixelSize + settings.pixelSpacerSize * 2);

    uPixelSpacerSize = size.width / uPixelCount! - settings.pixelSize;
    vPixelSpacerSize = size.height / vPixelCount! - settings.pixelSize;

    _circles = _createCircles();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (int i = 0; i < (uPixelCount ?? 0); i++) {
      for (int j = 0; j < (vPixelCount ?? 0); j++) {
        final Paint paint = Paint();
        final Offset position = Offset(
          i * (settings.pixelSize + (uPixelSpacerSize ?? 0)),
          j * (settings.pixelSize + (vPixelSpacerSize ?? 0)),
        );
        double factor = 0.0;
        for (Circle circle in _circles ?? []) {
          factor += circle.radius / max(circle.getDistance(position), 0.00001);
        }
        paint.color = _pixelTween.lerp(
          (factor / (_circles?.length ?? 1)).clamp(0.0, 1.0),
        )!;

        context.canvas.drawRect(
          position & Size.square(settings.pixelSize),
          paint,
        );
      }
    }
  }
}

class Circle {
  Circle({
    required this.center,
    required this.direction,
  });

  Offset center;
  Offset direction;

  late double radius = sqrt(
    pow((center.dx - direction.dx), 2) + pow((center.dy - direction.dy), 2),
  );

  double getDistance(Offset point) => sqrt(
        pow((center.dx - point.dx), 2) + pow((center.dy - point.dy), 2),
      );
}
