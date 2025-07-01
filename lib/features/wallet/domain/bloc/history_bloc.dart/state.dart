part of 'bloc.dart';

@immutable
class HistoryState extends Equatable {
  const HistoryState({
    required this.currentFilters,
    required this.desc,
    required this.history,
    int limit = 20,
    int offset = 0,
    this.reachedEnd = false,
  })  : _currentLimit = limit,
        _currentOffset = offset;

  final List<Transaction> history;
  final Set<GetFilter> currentFilters;
  final bool desc;
  final bool reachedEnd;

  final int _currentLimit;
  final int _currentOffset;

  GetFilter? get currentFilter {
    if (currentFilters.isNotEmpty) {
      return currentFilters.reduce((GetFilter a, GetFilter b) => a & b);
    }
    return null;
  }

  const HistoryState.initial()
      : history = const <Transaction>[],
        currentFilters = const <GetFilter>{},
        desc = true,
        _currentLimit = 20,
        _currentOffset = 0,
        reachedEnd = false;

  HistoryState copyWith({
    List<Transaction>? history,
    Set<GetFilter>? currentFilters,
    bool? desc,
    int? offset,
    int? limit,
    bool? reachedEnd,
  }) =>
      HistoryState(
        history: history ?? this.history,
        currentFilters: currentFilters ?? this.currentFilters,
        desc: desc ?? this.desc,
        limit: limit ?? _currentLimit,
        offset: offset ?? _currentOffset,
        reachedEnd: reachedEnd ?? this.reachedEnd,
      );

  HistoryState resetHistory() => HistoryState(
        history: List.empty(),
        currentFilters: currentFilters,
        desc: desc,
      );

  @override
  List<Object?> get props => [
        desc,
        _currentLimit,
        _currentOffset,
        reachedEnd,
        ...currentFilters,
        ...history,
      ];
}

class ErrorHistoryState extends HistoryState {
  ErrorHistoryState.fromState(HistoryState state, {this.e, this.st})
      : super(
          currentFilters: state.currentFilters,
          history: state.history,
          desc: state.desc,
          limit: state._currentLimit,
          offset: state._currentOffset,
          reachedEnd: state.reachedEnd,
        );

  final Object? e;
  final StackTrace? st;

  @override
  List<Object?> get props => [...super.props, e, st];
}
