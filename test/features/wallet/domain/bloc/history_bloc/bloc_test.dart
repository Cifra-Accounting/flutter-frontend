import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/common/models/get_filter.dart';

import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';

@GenerateNiceMocks([
  MockSpec<Transaction>(),
  MockSpec<TransactionRepository>(),
  MockSpec<GetFilter>(),
])
import 'bloc_test.mocks.dart';

void main() {
  TransactionRepository? transationRepository;
  HistoryBloc? bloc;
  final mockTransactions = List.filled(20, MockTransaction());
  final mockFilter = MockGetFilter();
  late Stream<bool> updateStream;

  group("Test the HistoryBloc", () {
    setUp(() {
      transationRepository = MockTransactionRepository();
      final StreamController<bool> streamController =
          StreamController<bool>.broadcast();
      updateStream = streamController.stream;
      when(transationRepository!.shouldUpdateTransactions)
          .thenAnswer((_) => updateStream);

      bloc = HistoryBloc(transactionRepository: transationRepository!);
    });

    tearDown(() {
      bloc?.close();
    });

    test("Initial state should be HistoryState.initial", () {
      expect(bloc?.state.history, isEmpty);
      expect(bloc?.state.currentFilters, isEmpty);
      expect(bloc?.state.desc, isTrue);
      expect(bloc?.state.reachedEnd, isFalse);
    });

    test("Test the resetHistory method of state", () {
      final initialState = bloc?.state;
      final resetState = initialState?.resetHistory();

      expect(resetState?.history, isEmpty);
      expect(resetState?.reachedEnd, isFalse);
    });

    blocTest<HistoryBloc, HistoryState>(
      'loads transactions when HitBottomHistoryEvent is added',
      build: () {
        when(transationRepository!.getList(
          offset: anyNamed("offset"),
          limit: anyNamed("limit"),
          desc: true,
          filter: anyNamed("filter"),
        )).thenAnswer((_) async => mockTransactions);
        return bloc!;
      },
      act: (bloc) => bloc.add(const HitBottomHistoryEvent()),
      expect: () => [
        isA<HistoryState>().having(
          (state) => state.history.length,
          'history length',
          mockTransactions.length,
        ),
      ],
      verify: (_) {
        verify(transationRepository!.getList(
          offset: 0,
          limit: anyNamed("limit"),
          desc: true,
          filter: anyNamed("filter"),
        )).called(1);
      },
    );

    blocTest<HistoryBloc, HistoryState>(
      'updates offset after loading transactions',
      build: () {
        when(transationRepository!.getList(
          offset: anyNamed("offset"),
          limit: anyNamed("limit"),
          desc: true,
          filter: anyNamed("filter"),
        )).thenAnswer((_) async => mockTransactions);
        bloc?.add(const HitBottomHistoryEvent());
        return bloc!;
      },
      skip: 1,
      act: (bloc) => bloc.add(const HitBottomHistoryEvent()),
      expect: () => [
        isA<HistoryState>()
            .having(
              (state) => state.history,
              'updated history',
              isNotEmpty,
            )
            .having(
              (state) => state.history.length,
              'updated history length',
              greaterThan(20),
            ),
      ],
      verify: (_) {
        verify(transationRepository!.getList(
          offset: anyNamed("offset"),
          limit: anyNamed("limit"),
          desc: true,
          filter: anyNamed("filter"),
        )).called(2);
      },
    );

    blocTest<HistoryBloc, HistoryState>(
      'sets reachedEnd to true when no new transactions are returned',
      build: () {
        when(transationRepository!.getList(
          offset: anyNamed("offset"),
          limit: anyNamed("limit"),
          desc: true,
          filter: anyNamed("filter"),
        )).thenAnswer((_) async => []);
        return bloc!;
      },
      act: (bloc) => bloc.add(const HitBottomHistoryEvent()),
      expect: () => [
        isA<HistoryState>().having(
          (state) => state.reachedEnd,
          'reached end',
          isTrue,
        ),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'adds filter and resets history when AddedFiltersHistoryEvent is added',
      build: () {
        when(mockFilter.where).thenReturn('test');
        return bloc!;
      },
      act: (bloc) => bloc.add(AddedFiltersHistoryEvent(filter: mockFilter)),
      expect: () => [
        isA<HistoryState>()
            .having((state) => state.currentFilters.length, 'filters count', 1)
            .having((state) => state.history, 'reset history', isEmpty),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'removes filter and resets history when RemovedFilterHistoryEvent is added',
      build: () {
        when(mockFilter.where).thenReturn('test');
        return bloc!;
      },
      act: (bloc) {
        bloc
          ..add(AddedFiltersHistoryEvent(filter: mockFilter))
          ..add(RemovedFilterHistoryEvent(filter: mockFilter));
      },
      skip: 1,
      expect: () => [
        isA<HistoryState>()
            .having((state) => state.currentFilters.length, 'filters count', 0)
            .having((state) => state.history, 'reset history', isEmpty)
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'changes order and resets history when ChangedOrderHistoryEvent is added',
      build: () => bloc!,
      act: (bloc) => bloc.add(const ChangedOrderHistoryEvent(desc: false)),
      expect: () => [
        isA<HistoryState>()
            .having((state) => state.desc, 'desc', isFalse)
            .having((state) => state.history, 'reset history', isEmpty),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'resets history when ShouldUpdateRepositoryHistoryEvent is added',
      build: () {
        when(transationRepository!.getList(
          offset: anyNamed("offset"),
          limit: anyNamed("limit"),
          desc: true,
          filter: anyNamed("filter"),
        )).thenAnswer((_) async => mockTransactions);
        return bloc!;
      },
      seed: () => HistoryState(
        currentFilters: {},
        history: mockTransactions,
        desc: false,
        offset: mockTransactions.length,
      ),
      act: (bloc) => bloc.add(const ShouldUpdateRepositoryHistoryEvent()),
      expect: () => [
        isA<HistoryState>().having(
          (state) => state.history,
          'reset history',
          isEmpty,
        ),
      ],
    );

    test('bloc reports error when trying to add same filter type twice',
        () async {
      final secondFilter = MockGetFilter();

      // Add first filter
      bloc!.add(AddedFiltersHistoryEvent(filter: mockFilter));
      await Future.delayed(const Duration(milliseconds: 100));

      // Add second filter of the same type
      bool errorThrown = false;
      bloc!.stream.listen((state) {
        expect(state, isA<ErrorHistoryState>());
        expect((state as ErrorHistoryState).e, isA<BlocError>());
        expect((state.e as BlocError).message, contains("two filters"));
        errorThrown = true;
      }, onError: (error) {});

      bloc!.add(AddedFiltersHistoryEvent(filter: secondFilter));
      await Future.delayed(const Duration(milliseconds: 100));
      expect(errorThrown, isTrue);
    });
  });
}
