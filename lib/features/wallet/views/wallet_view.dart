import 'package:flutter/material.dart';

import 'package:cifra_app/features/wallet/widgets/collapsing_header_scroll_view.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_card.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  final GlobalKey _spendingsCardKey = const GlobalObjectKey('spendingsCard');

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: topPadding,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(cardBorderRadius),
          ),
          child: CollapsingHeaderScrollView(
            headerWidget: SpendingsCard(
              key: _spendingsCardKey,
              onChanged: (_) {},
            ),
            headerKey: _spendingsCardKey,
            headerPadding: blankSpacerSize,
            threshhold: .7,
            children: <Widget>[
              Container(
                height: 1500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(cardBorderRadius),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
