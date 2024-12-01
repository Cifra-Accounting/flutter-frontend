import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter/material.dart';

class BlankSpacer extends StatelessWidget {
  const BlankSpacer({
    super.key,
    this.multiplier = 1.0,
    this.vertical = false,
  });

  final double multiplier;
  final bool vertical;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: vertical ? NumericConstants.blankSpacerSize * multiplier : null,
        width: !vertical ? NumericConstants.blankSpacerSize * multiplier : null,
      );
}
