part of 'bloc.dart';

sealed class HistoryEvent {
  const HistoryEvent();
}

class HitBottomHistoryEvent extends HistoryEvent {
  const HitBottomHistoryEvent();
}

class AddedFiltersHistoryEvent extends HistoryEvent {
  const AddedFiltersHistoryEvent({required this.filter});

  final GetFilter filter;
}

class RemovedFilterHistoryEvent extends HistoryEvent {
  const RemovedFilterHistoryEvent({required this.filter});

  final GetFilter filter;
}

class ChangedOrderHistoryEvent extends HistoryEvent {
  const ChangedOrderHistoryEvent({required this.desc});

  final bool desc;
}

class ShouldUpdateRepositoryHistoryEvent extends HistoryEvent {
  const ShouldUpdateRepositoryHistoryEvent();
}

class ErrorEvent extends HistoryEvent {
  const ErrorEvent({this.e, this.st});

  final Object? e;
  final StackTrace? st;
}
