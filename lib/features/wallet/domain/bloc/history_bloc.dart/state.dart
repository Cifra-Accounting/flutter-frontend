part of 'bloc.dart';

@immutable
class HistoryState extends Equatable {
  const HistoryState({
    required this.currentFilters,
    required this.desc,
    required this.history,
    int limit = 20,
    int offset = 0,
    int skip = 0,
    this.reachedEnd = false,
  })  : _currentLimit = limit,
        _currentOffset = offset,
        _skip = skip;

  final List<Transaction> history;
  final Set<GetFilter> currentFilters;
  final bool desc;
  final bool reachedEnd;

  final int _currentLimit;
  final int _currentOffset;
  final int _skip;

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
        _skip = 0,
        reachedEnd = false;

  HistoryState _copyWith({
    List<Transaction>? history,
    Set<GetFilter>? currentFilters,
    bool? desc,
    int? offset,
    int? limit,
    int? skip,
    bool? reachedEnd,
  }) =>
      HistoryState(
        history: history ?? this.history,
        currentFilters: currentFilters ?? this.currentFilters,
        desc: desc ?? this.desc,
        limit: limit ?? _currentLimit,
        offset: offset ?? _currentOffset,
        skip: skip ?? _skip,
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
        _skip,
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
          skip: state._skip,
          reachedEnd: state.reachedEnd,
        );

  final Object? e;
  final StackTrace? st;

  @override
  List<Object?> get props => [...super.props, e, st];
}
