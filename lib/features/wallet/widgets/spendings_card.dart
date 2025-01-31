import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/constants/numeric_constants.dart';

import 'package:cifra_app/features/wallet/widgets/period_selector.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_indicator.dart';

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
        _textSize("\$${(widget.spent ?? 0.0)}", _textTheme.titleLarge!).height +
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
    final RenderBox indicatorRenderObject = (const SpendingsIndicator(
      percentage: .0,
    ).createRenderObject(context) as RenderBox)
      ..layout(const BoxConstraints().loosen());
    return indicatorRenderObject.size;
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _colorScheme.primary,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: cardVerticalPadding),
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
                                            text: "\$${widget.spent ?? .0}",
                                            style: _textTheme.titleLarge,
                                          ),
                                          TextSpan(
                                            text:
                                                " / ${(widget.outOf ?? .0)} \$  ",
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
                                          ? "( ${(widget.spent! / widget.outOf!).toInt()}% )"
                                          : "( 0% )",
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
