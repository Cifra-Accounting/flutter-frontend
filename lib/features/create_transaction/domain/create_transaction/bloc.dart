import 'dart:async';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  CreateTransactionBloc({
    required this.userRepository,
    required this.transactionRepository,
    required this.categoryRepository,
  }) : super(CreateTransactionState(
          baseCurrency: userRepository.get().limit?.currency,
        )) {
    _categoryUpdateSubscription =
        categoryRepository.shouldUpdateCategories.listen(
      (_) => add(CreateTransactionEvent.shouldUpdateCategories()),
      onError: (e, st) => add(CreateTransactionEvent.error(e: e, st: st)),
    );
    _transactionUpdateSubscriptiion =
        transactionRepository.shouldUpdateTransactions.listen(
      null,
      onError: (e, st) => add(CreateTransactionEvent.error(e: e, st: st)),
    );

    add(CreateTransactionEvent.shouldUpdateCategories());

    on<Update>(_onUpdateEvent);
    on<Submit>(_onSubmitEvent);
    on<ShouldUpdateCategories>(_onShouldUpdateCategoriesEvent);
    on<ErrorEvent>(_onErrorEvent);
  }

  final UserRepository userRepository;
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  late final StreamSubscription<bool> _categoryUpdateSubscription;
  late final StreamSubscription<bool> _transactionUpdateSubscriptiion;

  void _onUpdateEvent(
    Update event,
    Emitter<CreateTransactionState> emit,
  ) {}

  void _onSubmitEvent(
    Submit event,
    Emitter<CreateTransactionState> emit,
  ) async {
    if (![
      state.amount,
      state.category,
      state.type,
      state.title,
      state.description,
    ].any((Object? value) => value == null)) {
      emit(state.copyWith(blocState: CreateTransactionBlocState.loading));

      final Transaction transaction = Transaction()
        ..title.value = state.title
        ..description.value = state.description
        ..date.value = DateTime.now()
        ..value.value = state.amount
        ..category.value = state.category
        ..type.value = state.type;

      await transactionRepository.save(transaction);
    }
  }

  void _onShouldUpdateCategoriesEvent(
    ShouldUpdateCategories event,
    Emitter<CreateTransactionState> emit,
  ) async =>
      emit(
        state.copyWith(categories: await categoryRepository.getAll()),
      );

  void _onErrorEvent(
    ErrorEvent event,
    Emitter<CreateTransactionState> emit,
  ) =>
      emit(
        state.toError(event.e, event.st),
      );

  @override
  Future<void> close() => Future.wait([
        _categoryUpdateSubscription.cancel(),
        _transactionUpdateSubscriptiion.cancel(),
        super.close(),
      ]);
}
