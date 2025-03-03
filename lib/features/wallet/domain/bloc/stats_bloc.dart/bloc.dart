import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

sealed class StatsEvent {
  const StatsEvent();
}

class InitialStatsEvent extends StatsEvent {}

class ChangedPeriodStatsEvent extends StatsEvent {}

@immutable
class StatsState extends Equatable {
  const StatsState({required this.spent, required this.outOf});

  final Money spent;
  final Money outOf;

  const StatsState.initial()
      : spent = const Money(currency: Currency.usd, amountInSmallestUnits: 0),
        outOf = const Money(currency: Currency.usd, amountInSmallestUnits: 0);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({required this.transactionRepository})
      : super(const StatsState.initial());

  final TransactionRepository transactionRepository;
}
