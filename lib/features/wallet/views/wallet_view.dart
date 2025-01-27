import 'package:cifra_app/features/wallet/widgets/spendings_card.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

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
          spacing: blankSpacerSize,
          children: [
            SpendingsCard(onChanged: (period) {}),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(cardBorderRadius),
              ),
              height: 1500,
            )
          ],
        ),
      );
}
