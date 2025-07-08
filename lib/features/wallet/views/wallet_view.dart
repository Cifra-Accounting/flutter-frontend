import 'package:cifra_app/common/ui/cirfa_swipable.dart';
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
  Periods _currentPeriod = Periods.values.first;

  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  HistoryBloc get _bloc => context.read<HistoryBloc>();
  HistoryState get _state => _bloc.state;

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);

    _colorScheme = theme.colorScheme;
    _textTheme = theme.textTheme;

    super.didChangeDependencies();
  }

  List<Widget> _mappedTransactions(List<Transaction> transactions) {
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

    final List<Widget> result = transactions
        .map<Widget>(
          (transaction) => C1fraListTile(
            key: ValueKey(transaction.id.valueOrThrow),
            transaction: transaction,
            outOf: context.read<UserRepository>().get().limit?.amount,
            onSwiped: _onCardSwipe,
            onTap: _onCardTap,
          ),
        )
        .toList();

    for (final (index, transaction) in transactions.indexed) {
      final Transaction? previous =
          index != 0 ? transactions.elementAtOrNull(index - 1) : null;

      if (previous?.date.value?.day != transaction.date.value?.day) {
        result.insert(
          index,
          Padding(
            padding: const EdgeInsets.only(bottom: blankSpacerSize),
            child: Text(
              "${transaction.date.valueOrThrow.day}.${transaction.date.valueOrThrow.month}.${transaction.date.valueOrThrow.year}",
              style: GoogleFonts.montserratAlternates(
                textStyle: _textTheme.bodyMedium?.copyWith(
                  color: _colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      }
    }

    return result;
  }

  void _onCardTap(Key key) => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => DetailsModalSheet(
          transaction: _state.history.firstWhere(
            (Transaction transacion) =>
                transacion.id.valueOrThrow == (key as ValueKey).value,
          ),
        ),
        useRootNavigator: true,
      );

  void _onCardSwipe(Key key) => _bloc.add(
        RemoveEntryHistoryEvent(
          entry: _state.history.firstWhere(
            (Transaction transacion) =>
                transacion.id.valueOrThrow == (key as ValueKey).value,
          ),
        ),
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
          child: CustomScrollView(
            slivers: <Widget>[
              FadingSliver(
                child: BlocBuilder<StatsBloc, StatsState>(
                  builder: (context, state) => SpendingsCard(
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
                child: SizedBox(height: blankSpacerSize),
              ),
              DecoratedSliver(
                decoration: BoxDecoration(
                  color: _colorScheme.surface,
                  borderRadius: BorderRadius.circular(cardBorderRadius),
                ),
                sliver: SliverPadding(
                  padding: EdgeInsets.all(20),
                  sliver: BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state.history.isEmpty && !state.reachedEnd) {
                        _bloc.add(HitBottomHistoryEvent());
                      }

                      return SliverList(
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
                            ..._mappedTransactions(state.history),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: kBottomNavigationBarHeight + blankSpacerSize,
                ),
              )
            ],
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
      child: C1fraSwipable(
        onSwiped: () {},
        icon: Icons.delete_forever,
        spacing: blankSpacerSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius / 2),
          color: colorScheme.primary,
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
                      "${transaction.type.valueOrThrow == TransactionType.income ? "+" : "-"} ${transaction.value.valueOrThrow.formattedAmount}",
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
