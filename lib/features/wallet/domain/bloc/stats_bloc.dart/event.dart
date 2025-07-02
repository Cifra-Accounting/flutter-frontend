part of 'bloc.dart';

sealed class StatsEvent {
  const StatsEvent();
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
