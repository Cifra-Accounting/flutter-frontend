import 'dart:async';

import 'package:cifra_app/common/get_filters/type_filter.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/get_filters/datetime_filter.dart';
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';

part 'event.dart';
part 'state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required this.transactionRepository,
    required this.userRepository,
  }) : super(const StatsState.initial()) {
    on<ShouldUpdateRepositoryStatsEvent>(_onShouldUpdateRepositoryStatsEvent);
    on<PeriodPromptedStatsEvent>(_onPeriodPromptedStatsEvent);

    updateSub = transactionRepository.shouldUpdateTransactions.listen(
      (event) => add(const ShouldUpdateRepositoryStatsEvent()),
      onError: (error, stackTrace) => addError(
        BlocError((error as RepositoryException).message),
      ),
    );
  }

  final TransactionRepository transactionRepository;
  final UserRepository userRepository;
  late final StreamSubscription updateSub;

  void _onShouldUpdateRepositoryStatsEvent(
    ShouldUpdateRepositoryStatsEvent event,
    Emitter<StatsState> emit,
  ) {
    emit(state.resetSpendinds());
  }

  FutureOr<void> _onPeriodPromptedStatsEvent(
    PeriodPromptedStatsEvent event,
    Emitter<StatsState> emit,
  ) async {
    if (state.spendings.containsKey(event.period)) return;

    final User user = userRepository.get();
    final Currency currency = user.limit!.currency;

    final (from, to) = event.period.calculatePeriodBoundaries();
    final int daysInPeriod = to.difference(from).inDays + 1;

    final (monthFrom, monthTo) = Periods.month.calculatePeriodBoundaries();
    final int daysInMonth = monthTo.difference(monthFrom).inDays + 1;

    final incomeFilter = DateTimeFilter.fromPeriod(period: Periods.month) &
        const TypeFilter(type: TransactionType.income);
    final expenseFilter = DateTimeFilter.fromPeriod(period: event.period) &
        const TypeFilter(type: TransactionType.expence);

    final List<Transaction> incomeTransactions =
        await transactionRepository.getList(filter: incomeFilter);
    final List<Transaction> expenseTransactions =
        await transactionRepository.getList(filter: expenseFilter);

    Money sumTransactions(List<Transaction> txns) => txns.fold<Money>(
          Money(currency: currency, amountInSmallestUnits: 0),
          (acc, tx) => acc + tx.value.valueOrThrow,
        );

    final Money got = sumTransactions(incomeTransactions);
    final Money spent = sumTransactions(expenseTransactions);

    final Money limit = user.limit!;
    final Money base = got < limit ? got : limit;

    final Money outOf = base * (daysInPeriod / daysInMonth);

    emit(state.copyWith(
      spendings: {...state.spendings, event.period: (spent, outOf)},
    ));
  }

  @override
  Future<void> close() => Future.wait([updateSub.cancel(), super.close()]);
}
