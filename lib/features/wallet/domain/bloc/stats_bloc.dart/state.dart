part of 'bloc.dart';

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
