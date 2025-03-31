import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';
import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/domain/bloc/stats_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/widgets/fading_sliver.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter/material.dart';

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
              return CustomScrollView(
                primary: true,
                slivers: <Widget>[
                  FadingSliver(
                    child: BlocBuilder<StatsBloc, StatsState>(
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
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: blankSpacerSize,
                    ),
                  ),
                  DecoratedSliver(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    sliver: SliverPadding(
                      padding: EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Container(
                              color: Colors.black,
                              width: double.infinity,
                              child: Text(
                                'HISTORY',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Divider(
                                thickness: 2.0,
                                height: 0.0,
                                color: Colors.black,
                              ),
                            ),
                            ...state.history.map(
                              (Transaction transaction) => C1fraCard(
                                key: ValueKey(transaction.id.valueOrThrow),
                                transaction: transaction,
                                onSwiped: (key) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );
}

class C1fraCard extends StatelessWidget {
  const C1fraCard({
    required super.key,
    required this.transaction,
    required this.onSwiped,
  });

  final Transaction transaction;
  final void Function(Key key) onSwiped;

  @override
  Widget build(BuildContext context) => Container(
        height: 56,
        margin: EdgeInsets.only(bottom: blankSpacerSize),
        child: Swipable(
          key: key,
          onSwiped: onSwiped,
          spacing: blankSpacerSize,
          swiped: Container(
            color: Colors.red,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5.0),
            child: Icon(Icons.stop_circle),
          ),
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      child: C1fraIcon(
                        icon: 33553759,
                        color: Colors.white,
                      ),
                    ),
                    VerticalDivider(
                      width: 0.0,
                      thickness: 2.0,
                      color: Colors.white,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          transaction.title.valueOrThrow,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          transaction.description.value ?? '',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5.0,
                    children: <Widget>[
                      Text(
                        "+${transaction.value.valueOrThrow}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${transaction.value.valueOrThrow.amount / (context.read<UserRepository>().get().dailyLimit?.amount ?? transaction.value.valueOrThrow.amount) * 100}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Icon(
                            C1fraIcons.percent,
                            color: Colors.white.withAlpha(179),
                            size: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
