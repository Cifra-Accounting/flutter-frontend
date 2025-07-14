import 'dart:math';

import 'package:cifra_app/common/models/money.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/constants/numeric_constants.dart';

import 'package:cifra_app/features/wallet/widgets/period_selector.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class SpendingsCard extends StatefulWidget {
  const SpendingsCard({
    super.key,
    this.spent,
    this.outOf,
    required this.onChanged,
  });

  final Money? spent;
  final Money? outOf;

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

  double? get _percentage {
    if (widget.spent == null || widget.outOf == null) return null;
    if (widget.outOf!.amount == 0.0) return 1.0;
    return max(widget.spent!.amount / widget.outOf!.amount, 0.0);
  }

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
        _textSize(
          "S",
          GoogleFonts.montserratAlternates(
            textStyle: _textTheme.bodyMedium,
          ),
        ).height +
        _textSize(
          "\$",
          GoogleFonts.montserratAlternates(
            textStyle: _textTheme.headlineLarge,
          ),
        ).height +
        blankSpacerSize;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();

    super.dispose();
  }

  void _tabListener() => widget.onChanged(_periods[_tabController.index]);

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
          color: _colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: blankSpacerSize,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: blankSpacerSize,
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
                      (period) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: blankSpacerSize / 2,
                          children: [
                            Text(
                              "Spent this ${period.name}:",
                              style: GoogleFonts.montserratAlternates(
                                textStyle: _textTheme.bodyMedium?.copyWith(
                                  color: _colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SpendingsIndicator(
                              percentage: _percentage?.clamp(0.0, 1.0),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  overflow: TextOverflow.fade,
                                  TextSpan(
                                    text: widget.spent?.formattedAmount ??
                                        "\$0.0",
                                    style: GoogleFonts.montserratAlternates(
                                      textStyle:
                                          _textTheme.headlineLarge?.copyWith(
                                        color: _colorScheme.onPrimary,
                                      ),
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            " / ${widget.outOf?.formattedAmount ?? "\$0.0"}  ",
                                        style: GoogleFonts.montserratAlternates(
                                          textStyle:
                                              _textTheme.bodyMedium?.copyWith(
                                            color: _colorScheme.onPrimary
                                                .withValues(alpha: .75),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "( ${((_percentage ?? 0) * 100).toInt()}% )",
                                  style: GoogleFonts.montserratAlternates(
                                    textStyle: _textTheme.bodyMedium?.copyWith(
                                      color: _colorScheme.onPrimary
                                          .withValues(alpha: .75),
                                    ),
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
