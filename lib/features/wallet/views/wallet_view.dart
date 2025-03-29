import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/features/wallet/domain/bloc/stats_bloc.dart/bloc.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/features/wallet/widgets/collapsing_header_scroll_view.dart';
import 'package:cifra_app/common/ui/ui.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_card.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final GlobalKey _spendingsCardKey = const GlobalObjectKey('spendingsCard');

  Periods _currentPeriod = Periods.day;

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
            headerWidget: BlocBuilder<StatsBloc, StatsState>(
              builder: (context, state) {
                return SpendingsCard(
                  key: _spendingsCardKey,
                  spent: state.spendings[_currentPeriod]?.$1?.amount,
                  outOf: state.spendings[_currentPeriod]?.$2?.amount,
                  onChanged: (period) {
                    context
                        .read<StatsBloc>()
                        .add(PeriodPromptedStatsEvent(period: period));
                    setState(() {
                      _currentPeriod = period;
                    });
                  },
                );
              },
            ),
            headerKey: _spendingsCardKey,
            headerPadding: blankSpacerSize,
            threshold: .7,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Swipable(
                  key: ValueKey(1),
                  onSwiped: (Key key) {},
                  spacing: 5.0,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                  swiped: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.stop_circle),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
