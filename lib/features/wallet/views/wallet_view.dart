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
import 'package:marquee/marquee.dart';

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
        builder: (_) => DetailsModalSheet(
          transaction: context.read<HistoryBloc>().state.history.firstWhere(
                (Transaction transacion) =>
                    transacion.id.valueOrThrow == (key as ValueKey).value,
              ),
        ),
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
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  cardBorderRadius / 2,
                                ),
                                color: _colorScheme.shadow,
                              ),
                              child: PixelText(
                                "history",
                                settings: PixelTextSettings(
                                  style: GoogleFonts.pixelifySans(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  pixelSize: pixelSize / 2,
                                  pixelSpacerSize: pixelSpacerSize / 2,
                                  pixelColor: _colorScheme.onPrimary,
                                  backroungColor: Colors.transparent,
                                ),
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
        borderRadius: BorderRadius.circular(cardBorderRadius / 2),
        swiped: Container(
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(cardBorderRadius / 2),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            Icons.stop_circle,
            color: colorScheme.onError,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardBorderRadius / 2),
          child: Material(
            color: colorScheme.surfaceContainerHigh,
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
                            icon: transaction
                                .category.valueOrThrow.icon.valueOrThrow,
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
                  ],
                ),
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
    final TextTheme textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(cardBorderRadius),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: blankSpacerSize,
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
            ),
            padding: EdgeInsets.all(10),
            child: Row(
              spacing: 5.0,
              children: <Widget>[
                SizedBox.square(
                  dimension: 30,
                  child: C1fraIcon(
                    icon: transaction.category.valueOrThrow.icon.valueOrThrow,
                    color: colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: Marquee(
                    text:
                        "${transaction.title.valueOrThrow} ( ${transaction.category.valueOrThrow.name.valueOrThrow} )",
                    style: GoogleFonts.montserratAlternates(
                      textStyle: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    startAfter: Durations.extralong4,
                    pauseAfterRound: Durations.extralong4,
                    fadingEdgeStartFraction: 0.1,
                    fadingEdgeEndFraction: 0.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cardBorderRadius / 2),
              color: colorScheme.surfaceContainerHigh,
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              spacing: 5.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${transaction.date.valueOrThrow.day}.${transaction.date.valueOrThrow.month}.${transaction.date.valueOrThrow.year} ${transaction.date.valueOrThrow.toString().split(" ")[1]}",
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  transaction.description.value ?? "",
                  style: GoogleFonts.montserratAlternates(
                    textStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
