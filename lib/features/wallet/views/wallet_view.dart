import 'package:cifra_app/features/wallet/widgets/period_selector.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/common/ui/ui.dart';
import 'package:cifra_app/features/wallet/widgets/spendings_card.dart';
import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/domain/bloc/stats_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/widgets/fading_sliver.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/user/repository.dart';

import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final GlobalKey _spendingsCardKey = const GlobalObjectKey('spendingsCard');

  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);

    _colorScheme = theme.colorScheme;
    _textTheme = theme.textTheme;

    super.didChangeDependencies();
  }

  Periods _currentPeriod = Periods.values.first;

  List<Widget> _mappedTransactions(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    if (transactions.isEmpty) {
      return [
        Text(
          "Seems like there is nothing here ;)",
          style: GoogleFonts.montserratAlternates(
            textStyle: _textTheme.bodyMedium?.copyWith(
              color: _colorScheme.onSurface,
            ),
          ),
        )
      ];
    }
    Transaction? previous;
    final List<Widget> result = <Widget>[];

    for (final Transaction transaction in transactions) {
      if (previous == null ||
          previous.date.value?.day != transaction.date.value?.day) {
        result.add(
          Padding(
            padding: const EdgeInsets.only(bottom: blankSpacerSize),
            child: Text(
              "${transaction.date.valueOrThrow.day}.${transaction.date.valueOrThrow.month}.${transaction.date.valueOrThrow.year}",
              style: GoogleFonts.montserratAlternates(
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _colorScheme.onSurface,
                    ),
              ),
            ),
          ),
        );
      }
      result.add(
        C1fraListTile(
          key: ValueKey(transaction.id.valueOrThrow),
          transaction: transaction,
          outOf: context.read<UserRepository>().get().dailyLimit?.amount,
          onSwiped: (key) {},
          onTap: (key) => onCardTap(context, key),
        ),
      );

      previous = transaction;
    }

    return result;
  }

  void onCardTap(BuildContext context, Key key) => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => DetailsModalSheet(
            transaction: context.read<HistoryBloc>().state.history.firstWhere(
                  (Transaction transacion) =>
                      transacion.id.valueOrThrow == (key as ValueKey).value,
                )),
        useRootNavigator: true,
      );

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
                        spent: state.spendings[_currentPeriod]?.$1,
                        outOf: state.spendings[_currentPeriod]?.$2,
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
                      color: _colorScheme.surface,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    sliver: SliverPadding(
                      padding: EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            PixelText(
                              "history",
                              settings: PixelTextSettings(
                                style: GoogleFonts.pixelifySans(
                                  textStyle:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                pixelSize: pixelSize / 2,
                                pixelSpacerSize: pixelSpacerSize / 2,
                                pixelColor: _colorScheme.onSurface,
                                backroungColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Divider(
                                thickness: 2.0,
                                height: 0.0,
                                color: _colorScheme.onSurface,
                              ),
                            ),
                            ..._mappedTransactions(context, state.history),
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

class C1fraListTile extends StatelessWidget {
  const C1fraListTile({
    required super.key,
    required this.transaction,
    this.outOf,
    required this.onSwiped,
    required this.onTap,
  });

  final Transaction transaction;
  final double? outOf;
  final void Function(Key key) onSwiped;
  final void Function(Key key) onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 63,
      margin: EdgeInsets.only(bottom: blankSpacerSize),
      child: Swipable(
        key: key,
        onSwiped: onSwiped,
        spacing: blankSpacerSize,
        borderRadius: BorderRadius.circular(10),
        swiped: Container(
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.stop_circle,
            color: colorScheme.onError,
          ),
        ),
        child: Material(
          color: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () => onTap(key!),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: <Widget>[
                      SizedBox.square(
                        dimension: 30,
                        child: C1fraIcon(
                          icon: 33553759,
                          color: colorScheme.inverseSurface,
                        ),
                      ),
                      Text(
                        transaction.title.valueOrThrow,
                        style: GoogleFonts.montserratAlternates(
                          textStyle: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${transaction.type.valueOrThrow == TransactionType.income ? "+" : "-"} ${transaction.value.valueOrThrow}",
                    style: GoogleFonts.montserratAlternates(
                      textStyle: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  // IntrinsicWidth(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     spacing: 7.0,
                  //     children: <Widget>[
                  //       Text(
                  //         "${transaction.type.valueOrThrow == TransactionType.income ? "+" : "-"} ${transaction.value.valueOrThrow}",
                  //         style: GoogleFonts.montserratAlternates(
                  //           textStyle: textTheme.bodyLarge?.copyWith(
                  //             color: colorScheme.onSurface,
                  //           ),
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: <Widget>[
                  //           SizedBox(
                  //             height: 10,
                  //             child: C1fraIcon(
                  //               icon: transaction.type.valueOrThrow ==
                  //                       TransactionType.income
                  //                   ? arrowUp
                  //                   : arrowDown,
                  //               color: colorScheme.onSurface.withAlpha(179),
                  //             ),
                  //           ),
                  //           Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Text(
                  //                 '${transaction.value.valueOrThrow.amount / (outOf ?? transaction.value.valueOrThrow.amount) * 100}',
                  //                 style: textTheme.labelSmall,
                  //               ),
                  //               Icon(
                  //                 C1fraIcons.percent,
                  //                 color: colorScheme.onSurface.withAlpha(179),
                  //                 size: 10,
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsModalSheet extends StatelessWidget {
  const DetailsModalSheet({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // final TextTheme _textTheme = theme._textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(cardBorderRadius),
        ),
      ),
      child: Placeholder(),
    );
  }
}
