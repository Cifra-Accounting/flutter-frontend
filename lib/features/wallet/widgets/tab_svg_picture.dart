import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/constants/numeric_constants.dart';

import 'package:cifra_app/common/ui/utils/animated_svg_picture.dart';

class TabSvgPicture extends StatelessWidget {
  const TabSvgPicture({
    super.key,
    required this.period,
    required this.selected,
  });

  final Periods period;
  final bool selected;

  Color get _effectiveIconColor =>
      selected ? Colors.white : Colors.white.withValues(alpha: 0.75);

  double get _effectiveIconSize =>
      selected ? periodSelectorHeight : periodSelectorHeight * 0.75;

  @override
  Widget build(BuildContext context) => Tab(
        height: periodSelectorHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSvgPicture(
            'assets/${period.name}.svg',
            color: _effectiveIconColor,
            height: _effectiveIconSize,
            duration: Durations.short2,
          ),
        ),
      );
}
