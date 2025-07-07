import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:cifra_app/common/models/get_filter.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';

part 'event.dart';
part 'state.dart';
part 'error.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({required this.transactionRepository})
      : super(const HistoryState.initial()) {
    on<ShouldUpdateRepositoryHistoryEvent>(
        _onShouldUpdateRepositoryHistoryEvent);
    on<AddedFiltersHistoryEvent>(_onAddedFilterHistoryEvent);
    on<RemovedFilterHistoryEvent>(_onRemovedFilterHistoryEvent);
    on<ChangedOrderHistoryEvent>(_onChangedOrderHistoryEvent);
    on<HitBottomHistoryEvent>(_onHitBottomHistoryEvent);
    on<RemoveEntryHistoryEvent>(_onRemoveEntryHistoryEvent);
    on<ErrorEvent>(_onErrorEvent);

    /// Create subscription to the [transactionRepository]
    /// in order to react accordingly to the repository updates
    transactionsUpdate = transactionRepository.shouldUpdateTransactions.listen(
      (event) => add(const ShouldUpdateRepositoryHistoryEvent()),
      onError: (e, st) => add(ErrorEvent(
        e: BlocError((e as RepositoryException).message),
        st: st,
      )),
    );
  }

  final TransactionRepository transactionRepository;
  late final StreamSubscription transactionsUpdate;

  void _onErrorEvent(ErrorEvent event, Emitter<HistoryState> emit) =>
      emit(ErrorHistoryState.fromState(
        state,
        e: event.e,
        st: event.st,
      ));

  /// Simply clears [state]'s history in case
  /// [transactionRepository] updates affected the state
  /// we have at the moment
  void _onShouldUpdateRepositoryHistoryEvent(
    ShouldUpdateRepositoryHistoryEvent event,
    Emitter<HistoryState> emit,
  ) =>
      state._skip <= 0 ? emit(state.resetHistory()) : null;

  /// Adds required by the [event] filter to the [state]
  /// and clears history in case new filter affects the current history
  ///
  ///  Might [addError] in case filter of the same type already exists
  ///  in the [state]'s [currentFilters] set
  void _onAddedFilterHistoryEvent(
    AddedFiltersHistoryEvent event,
    Emitter<HistoryState> emit,
  ) {
    if (!checkFilter(event.filter)) {
      add(ErrorEvent(
        e: BlocError("You can't add two filters of the same type"),
        st: StackTrace.current,
      ));
      return;
    }

    final Set<GetFilter> currentFilters = {
      ...state.currentFilters,
      event.filter,
    };

    emit(state._copyWith(currentFilters: currentFilters).resetHistory());
  }

  /// Removes required by the [event] filter from the [state]
  /// and clears history in case new filters affect the current history
  void _onRemovedFilterHistoryEvent(
    RemovedFilterHistoryEvent event,
    Emitter<HistoryState> emit,
  ) {
    if (state.currentFilters.isEmpty) return;

    final Set<GetFilter> currentFilters = {...state.currentFilters}
      ..removeWhere((GetFilter filter) => filter.where == event.filter.where);

    emit(state._copyWith(currentFilters: currentFilters).resetHistory());
  }

  /// Changes [desc] flag in the [state] and
  /// resets [history]
  void _onChangedOrderHistoryEvent(
    ChangedOrderHistoryEvent event,
    Emitter<HistoryState> emit,
  ) =>
      emit(state._copyWith(desc: event.desc).resetHistory());

  /// Prompts the [transactionRepository] to return the new set
  /// of transactions (number of returned transactions is determined
  /// by the [_currentLimit] in the [state] property), calculates currentOffset
  /// and updates the [state]
  ///
  /// [reachedEnd] flag will be set to true if fetched list is empty indicating
  /// either an error on the repository side or the end of the data in the repository
  ///
  void _onHitBottomHistoryEvent(
    HitBottomHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    final List<Transaction> history = [
      ...await transactionRepository.getList(
        offset: state._currentOffset,
        limit: state._currentLimit,
        desc: state.desc,
        filter: state.currentFilter,
      ),
      ...state.history,
    ];

    final int currentOffset = state._currentOffset + state._currentLimit;

    emit(state._copyWith(
      history: history,
      offset: currentOffset,
      reachedEnd: history.length == state.history.length,
    ));
  }

  void _onRemoveEntryHistoryEvent(
    RemoveEntryHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(
      state._copyWith(
        skip: 1,
        offset: state._currentOffset - 1,
        history: [...state.history]..removeWhere(
            (transaction) =>
                transaction.id.valueOrThrow == event.entry.id.valueOrThrow,
          ),
      ),
    );

    await transactionRepository.delete(event.entry);
  }

  /// Checks whether [state] already has filter of the same type
  /// pushing two filters of the type to the repository might be
  /// not optimal
  ///
  /// returns [false] if [filter] is not eligible
  ///
  /// otherwise returns [true]
  bool checkFilter(GetFilter filter) {
    for (final GetFilter currentFilter in state.currentFilters) {
      if (currentFilter.runtimeType == filter.runtimeType) return false;
    }
    return true;
  }

  @override
  Future<void> close() => Future.wait([
        transactionsUpdate.cancel(),
        super.close(),
      ]);
}
