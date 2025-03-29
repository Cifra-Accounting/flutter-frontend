import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/domain/bloc/stats_bloc.dart/bloc.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
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
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state.history.isEmpty && !state.reachedEnd) {
                context.read<HistoryBloc>().add(HitBottomHistoryEvent());
              }
              return CollapsingHeaderScrollView(
                headerWidget: BlocBuilder<StatsBloc, StatsState>(
                  builder: (context, state) => SpendingsCard(
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
                  ),
                ),
                headerKey: _spendingsCardKey,
                headerPadding: blankSpacerSize,
                threshold: .5,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "HISTORY",
                      style: TextStyle(
                        fontFamily: "C1fra",
                        color: Colors.black,
                        fontSize: 52,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.black,
                      height: 0.0,
                      thickness: 2,
                    ),
                  ),
                  ...state.history.map(
                    (Transaction transaction) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: C1fraCard(
                        key: ValueKey(transaction.id.value),
                        transaction: transaction,
                        onSwiped: (key) {},
                      ),
                    ),
                  ),
                  if (state.history.isEmpty && state.reachedEnd)
                    Center(
                      child: Text(
                        'Seems like there is nothing to look at here',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );
}

class C1fraCard extends StatelessWidget {
  const C1fraCard({
    super.key,
    required this.transaction,
    required this.onSwiped,
  });

  final Transaction transaction;
  final void Function(Key key) onSwiped;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 90,
        child: Swipable(
          key: key,
          onSwiped: onSwiped,
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
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                C1fraIcon(
                  icon: transaction.category.value!.icon.value!,
                  color: Colors.black,
                ),
                Text(
                  transaction.description.value!,
                ),
              ],
            ),
          ),
        ),
      );
}
