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
          top: NumericConstants.topPadding,
          left: NumericConstants.horizontalPadding,
          right: NumericConstants.horizontalPadding,
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    _viewPortHeight = 15.0 * NumericConstants.pixelSize +
        14.0 * NumericConstants.pixelSpacerSize +
        5.0 * 2.0 +
        _textSize("You have already spent", textTheme.titleSmall!).height +
        _textSize("\$0", textTheme.titleLarge!).height;

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(
          NumericConstants.cardBorderRadius,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: NumericConstants.cardVerticalPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: NumericConstants.blankSpacerSize * 1.5,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NumericConstants.cardHorizontalPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: NumericConstants.blankSpacerSize * 1.5,
              children: [
                PeriodSelector(
                  controller: _tabController,
                  periods: _periods,
                ),
                Divider(
                  height: 0,
                  thickness: 2,
                  color: colorScheme.onPrimary,
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
                    (period) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: NumericConstants.horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: NumericConstants.blankSpacerSize * .5,
                        children: [
                          Text(
                            "You already have spent:",
                            style: theme.textTheme.titleSmall,
                          ),
                          const SpendingsIndicator(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text.rich(
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: "\$${(widget.spent ?? 178).toInt()}",
                                  style: theme.textTheme.titleLarge,
                                  children: [
                                    TextSpan(
                                      text:
                                          " / ${(widget.outOf ?? 300).toInt()} \$  ",
                                      style:
                                          theme.textTheme.titleSmall!.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: .75),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                (widget.spent != null && widget.outOf != null)
                                    ? "( ${(widget.spent! / widget.outOf!)}% )"
                                    : "( 60% )",
                                style: theme.textTheme.titleSmall!.copyWith(
                                  color: Colors.white.withValues(alpha: .75),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
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

  Ticker? _ticker;
  final ColorTween _colorTween =
      ColorTween(begin: Colors.white, end: Colors.black);
  late final AnimationController _idleAnimationController;

  double? _percentage;

  set percentage(double? newPercentage) {
    if (newPercentage == null &&
        (_idleAnimationController.status != AnimationStatus.forward ||
            _idleAnimationController.status != AnimationStatus.reverse)) {
      _idleAnimationController.repeat();
      _percentage = newPercentage;
    } else if (newPercentage != null &&
        (_idleAnimationController.status == AnimationStatus.forward ||
            _idleAnimationController.status == AnimationStatus.reverse)) {
      _idleAnimationController.animateTo(1.0).then((_) {
        _idleAnimationController.stop();
        _percentage = newPercentage;
        markNeedsPaint();
      });
    } else {
      _percentage = newPercentage;
      markNeedsPaint();
    }
    markNeedsSemanticsUpdate();
  }

  late int numOfColumns;
  late double vertivalColumnSpan;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    _idleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _idleAnimationController
        .drive(Tween(begin: .0, end: 1.0))
        .addListener(markNeedsPaint);

    if (_percentage == null) _idleAnimationController.repeat();
  }

  @override
  void detach() {
    _idleAnimationController.removeListener(markNeedsPaint);
    _idleAnimationController.dispose();

    super.detach();
  }

  @override
  void performLayout() {
    final double width = constraints.maxWidth;
    const double height =
        15 * NumericConstants.pixelSize + 14 * NumericConstants.pixelSpacerSize;

    numOfColumns = ((width - NumericConstants.pixelSize) /
                (NumericConstants.pixelSize +
                    NumericConstants.pixelSpacerSize) /
                2)
            .toInt() -
        1;

    vertivalColumnSpan = width / numOfColumns;

    size = constraints.constrain(Size(width, height));
  }

  void paintColumn(PaintingContext context, Offset offset, Paint paint) {
    for (int i = 0; i < 15; i++) {
      final Rect rect = (const Offset(
                      .0,
                      NumericConstants.pixelSize +
                          NumericConstants.pixelSpacerSize)
                  .scale(.0, i.toDouble()) +
              offset) &
          const Size.square(NumericConstants.pixelSize);

      context.canvas.drawRect(rect, paint);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Paint pixelPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final Paint setPixelPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (_percentage case double _) {
      for (int i = 0; i < numOfColumns; i++) {
        final Paint effectivePaint =
            i / numOfColumns > _percentage! ? pixelPaint : setPixelPaint;
        final Offset effectiveOffset =
            offset + Offset(vertivalColumnSpan, .0).scale(i.toDouble(), .0);

        paintColumn(
          context,
          effectiveOffset,
          effectivePaint,
        );
      }
    } else {
      for (int i = 0; i < numOfColumns; i++) {
        final Paint effectivePaint = Paint()
          ..style = PaintingStyle.fill
          ..color = _colorTween.lerp(
              10 * (i / numOfColumns - _idleAnimationController.value).abs())!;
        final Offset effectiveOffset =
            offset + Offset(vertivalColumnSpan, .0).scale(i.toDouble(), .0);

        paintColumn(
          context,
          effectiveOffset,
          effectivePaint,
        );
      }
    }
  }

  @override
  Ticker createTicker(TickerCallback onTick) {
    _ticker ??= Ticker(onTick);
    return _ticker!;
  }
}
