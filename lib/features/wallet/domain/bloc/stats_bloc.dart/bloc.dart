import 'dart:async';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/get_filters/datetime_filter.dart';
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/domain/bloc/stats_bloc.dart/utils/extensions.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

sealed class StatsEvent {
  const StatsEvent();
}

class InitialStatsEvent extends StatsEvent {
  const InitialStatsEvent();
}

class ShouldUpdateRepositoryStatsEvent extends StatsEvent {
  const ShouldUpdateRepositoryStatsEvent();
}

class PeriodPromptedStatsEvent extends StatsEvent {
  const PeriodPromptedStatsEvent({
    required this.period,
  });

  final Periods period;
}

@immutable
class StatsState extends Equatable {
  const StatsState({required this.spendings});

  /// Maps each prompted period with a pair (Money, Money),
  /// first one is for amount spent, the second one is for
  /// the whole amount given to the particular period
  final Map<Periods, (Money?, Money?)> spendings;

  const StatsState.initial() : spendings = const <Periods, (Money?, Money?)>{};

  StatsState copyWith({Map<Periods, (Money?, Money?)>? spendings}) =>
      StatsState(spendings: spendings ?? this.spendings);

  StatsState resetSpendinds() =>
      StatsState(spendings: <Periods, (Money?, Money?)>{});

  @override
  List<Object?> get props => [...spendings.entries];
}

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required this.transactionRepository,
    required this.userRepository,
  }) : super(const StatsState.initial()) {
    on<InitialStatsEvent>(_onInitialStatsEvent);
    on<ShouldUpdateRepositoryStatsEvent>(_onShouldUpdateRepositoryStatsEvent);
    on<PeriodPromptedStatsEvent>(_onPeriodPromptedStatsEvent);
  }

  final TransactionRepository transactionRepository;
  final UserRepository userRepository;
  late final StreamSubscription updateSub;

  void _onInitialStatsEvent(
    InitialStatsEvent event,
    Emitter<StatsState> emit,
  ) {
    updateSub = transactionRepository.shouldUpdateTransactions.listen(
      (event) => add(const ShouldUpdateRepositoryStatsEvent()),
      onError: (error, stackTrace) => addError(
        BlocError((error as RepositoryException).message),
      ),
    );
  }

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
    if (!state.spendings.containsKey(event.period)) {
      final DateTimeFilter filter =
          DateTimeFilter.fromPeriod(period: event.period);

      final Money? spent = (await transactionRepository.getList(filter: filter))
          .reduceTransactions();

      final Money? outOf = userRepository.get().dailyLimit;

      state.spendings[event.period] = (spent, outOf);
      emit(state);
    }

    emit(state);
  }

  @override
  Future<void> close() {
    updateSub.cancel();

    return super.close();
  }
}
