import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/ui/utils/animated_svg_picture.dart';
import 'package:cifra_app/features/wallet/views/wallet_view.dart';

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

  double get _effectiveIconSize => selected
      ? NumericConstants.periodSelectorHeight
      : NumericConstants.periodSelectorHeight * 0.75;

  @override
  Widget build(BuildContext context) => Tab(
        height: NumericConstants.periodSelectorHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSvgPicture(
            'assets/${period.name}.svg',
            color: _effectiveIconColor,
            height: _effectiveIconSize,
            duration: const Duration(milliseconds: 100),
          ),
        ),
      );
}
