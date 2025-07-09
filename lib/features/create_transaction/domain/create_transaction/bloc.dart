import 'dart:async';

import 'package:cifra_app/repositories/categories/repository.dart';
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

  void _onUpdateEvent(
    Update event,
    Emitter<CreateTransactionState> emit,
  ) {}

  void _onSubmitEvent(
    Submit event,
    Emitter<CreateTransactionState> emit,
  ) {}

  void _onShouldUpdateCategoriesEvent(
    ShouldUpdateCategories event,
    Emitter<CreateTransactionState> emit,
  ) {}

  void _onErrorEvent(
    ErrorEvent event,
    Emitter<CreateTransactionState> emit,
  ) {}

  @override
  Future<void> close() => Future.wait([
        _categoryUpdateSubscription.cancel(),
        super.close(),
      ]);
}
