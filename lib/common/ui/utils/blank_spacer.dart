import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

class BlankSpacer extends StatelessWidget {
  const BlankSpacer({
    super.key,
    this.multiplier = 1.0,
    this.vertical = true,
  });

  final double multiplier;
  final bool vertical;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: vertical ? blankSpacerSize * multiplier : null,
        width: !vertical ? blankSpacerSize * multiplier : null,
      );
}
