import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/features/wallet/widgets/period_selector.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: topPadding,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        primary: true,
        child: Column(
          children: [
            SpendingsCard(
              onChanged: (period) {},
            ),
          ],
        ),
      );
}

class SpendingsCard extends StatefulWidget {
  const SpendingsCard({
    super.key,
    this.spent,
    this.outOf,
    required this.onChanged,
  });

  final double? spent;
  final double? outOf;

  final void Function(Periods) onChanged;

  @override
  State<SpendingsCard> createState() => _SpendingsCardState();
}

class _SpendingsCardState extends State<SpendingsCard>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  late double _viewPortHeight;

  final List<Periods> _periods = const <Periods>[
    Periods.day,
    Periods.week,
    Periods.month,
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: _periods.length,
      animationDuration: const Duration(),
    );

    _tabController.addListener(_tabListener);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);

    _textTheme = theme.textTheme;
    _colorScheme = theme.colorScheme;

    _viewPortHeight = _indicatorSize().height +
        _textSize("You have already spent", _textTheme.titleSmall!).height +
        _textSize("\$${(widget.spent ?? 178).toInt()}", _textTheme.titleLarge!)
            .height +
        blankSpacerSize;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);

    _tabController.dispose();

    super.dispose();
  }

  void _tabListener() {
    widget.onChanged(_periods[_tabController.index]);
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  Size _indicatorSize() {
    final SpendingsIndicatorRenderObject indicatorRenderObject =
        SpendingsIndicatorRenderObject(.0)
          ..layout(const BoxConstraints().loosen());
    return indicatorRenderObject.size;
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _colorScheme.primary,
          borderRadius: BorderRadius.circular(
            cardBorderRadius,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: cardVerticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: blankSpacerSize * 1.5,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: cardHorizontalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: blankSpacerSize * 1.5,
                children: [
                  PeriodSelector(
                    controller: _tabController,
                    periods: _periods,
                  ),
                  Divider(
                    height: 0,
                    thickness: 2,
                    color: _colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _viewPortHeight,
              child: TabBarView(
                controller: _tabController,
                children: _periods
                    .map(
                      (period) => FutureBuilder<double>(
                        future: Future<double>.delayed(
                          const Duration(seconds: 5),
                          () =>
                              (Periods.values.indexOf(period).toDouble() +
                                  1.0) /
                              Periods.values.length,
                        ),
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: blankSpacerSize * .5,
                              children: [
                                Text(
                                  "You already have spent:",
                                  style: _textTheme.titleSmall,
                                ),
                                SpendingsIndicator(percentage: snapshot.data),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      overflow: TextOverflow.fade,
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "\$${(widget.spent ?? 178).toInt()}",
                                            style: _textTheme.titleLarge,
                                          ),
                                          TextSpan(
                                            text:
                                                " / ${(widget.outOf ?? 300).toInt()} \$  ",
                                            style:
                                                _textTheme.titleSmall!.copyWith(
                                              color: Colors.white
                                                  .withValues(alpha: .75),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      (widget.spent != null &&
                                              widget.outOf != null)
                                          ? "( ${(widget.spent! / widget.outOf!)}% )"
                                          : "( 60% )",
                                      style: _textTheme.titleSmall!.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: .75),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
}

enum Periods {
  day,
  week,
  month,
  year,
}

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
