import 'dart:async';
import 'dart:math';

import 'package:cifra_app/common/models/bloc_error.dart';
import 'package:cifra_app/common/models/money.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/currency_exchange/exchange_rate_repository.dart';
import 'package:cifra_app/repositories/currency_exchange/models/exchage_rate.dart';
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
    required this.exchangeRateRepository,
    required this.transactionRepository,
    required this.categoryRepository,
  }) : super(CreateTransactionState(
          baseCurrency: userRepository.get().limit!.currency,
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
  final ExchangeRateRepository exchangeRateRepository;
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  late final StreamSubscription<bool> _categoryUpdateSubscription;
  late final StreamSubscription<bool> _transactionUpdateSubscriptiion;

  void _onUpdateEvent(
    Update event,
    Emitter<CreateTransactionState> emit,
  ) async {
    if (!event.shouldConvertToBase) {
      emit(state.copyWith(
        title: event.title,
        description: event.description,
        category: event.category,
        currency: event.currency,
        amountInSmallestUnits: event.amountInSmallestUnits,
        type: event.type,
      ));
      return;
    }

    if (event.currency == null || event.amountInSmallestUnits == null) {
      emit(state.copyWith(
        title: event.title,
        description: event.description,
        category: event.category,
        currency: event.currency,
        amountInSmallestUnits: event.amountInSmallestUnits,
        amountInSmallestUnitsBase: null,
        type: event.type,
      ));
      return;
    }

    if (state.exchangeRates == null) {
      late final ExchangeRate rates;

      try {
        rates = await exchangeRateRepository.getRate(
          currency: state.baseCurrency,
        );
      } catch (e, st) {
        emit(state.copyWith(
          status: CreateTransactionStatus.error,
          e: e,
          st: st,
          title: event.title,
          description: event.description,
          category: event.category,
          currency: event.currency,
          amountInSmallestUnits: event.amountInSmallestUnits,
          type: event.type,
        ));
        return;
      } finally {
        final double? exchangeRate = rates.convertRates[event.currency];
        final double convertation = (exchangeRate ?? 1.0) *
            pow(10, event.currency!.fractionDigits) /
            pow(10, state.baseCurrency.fractionDigits);
        final int amountInSmallestUnitsBase =
            (event.amountInSmallestUnits! / convertation).toInt();
        emit(state.copyWith(
          title: event.title,
          description: event.description,
          category: event.category,
          currency: event.currency,
          amountInSmallestUnits: event.amountInSmallestUnits,
          amountInSmallestUnitsBase: amountInSmallestUnitsBase,
          type: event.type,
        ));
      }
    }

    final double? exchangeRate = state.exchangeRates![event.currency];
    final double convertation = (exchangeRate ?? 1.0) *
        pow(10, event.currency!.fractionDigits) /
        pow(10, state.baseCurrency.fractionDigits);
    final int amountInSmallestUnitsBase =
        (event.amountInSmallestUnits! / convertation).toInt();
    emit(state.copyWith(
      title: event.title,
      description: event.description,
      category: event.category,
      currency: event.currency,
      amountInSmallestUnits: event.amountInSmallestUnits,
      amountInSmallestUnitsBase: amountInSmallestUnitsBase,
      type: event.type,
    ));
  }

  void _onSubmitEvent(
    Submit event,
    Emitter<CreateTransactionState> emit,
  ) async {
    if (![
      state.title,
      state.type,
      state.category,
      state.amountInSmallestUnitsBase,
      state.amountInSmallestUnits,
      state.currency,
    ].any((Object? value) => value == null)) {
      emit(state.copyWith(status: CreateTransactionStatus.loading));

      final Money initialValue = Money(
        amountInSmallestUnits: state.amountInSmallestUnits!,
        currency: state.currency!,
      );
      final Money value = Money(
        amountInSmallestUnits: state.amountInSmallestUnitsBase!,
        currency: state.baseCurrency,
      );
      final String description =
          "${initialValue.formattedAmount}->${value.formattedAmount}\n${(state.description ?? "")}";
      final DateTime date = DateTime.now();
      final Transaction transaction = Transaction()
        ..title.value = state.title
        ..description.value = description
        ..category.value = state.category
        ..type.value = state.type
        ..date.value = date
        ..value.value = value;

      try {
        await transactionRepository.save(transaction);
      } catch (e, st) {
        emit(state.copyWith(
          status: CreateTransactionStatus.error,
          e: e,
          st: st,
        ));
      } finally {
        emit(state.copyWith(
          status: CreateTransactionStatus.loaded,
        ));
      }
    }

    if (![
      state.title,
      state.type,
      state.category,
      state.amountInSmallestUnits,
      state.currency,
    ].any((Object? value) => value == null)) {
      emit(state.copyWith(status: CreateTransactionStatus.loading));

      final Money value = Money(
        amountInSmallestUnits: state.amountInSmallestUnits!,
        currency: state.currency!,
      );
      final DateTime date = DateTime.now();
      final Transaction transaction = Transaction()
        ..title.value = state.title
        ..description.value = state.description
        ..category.value = state.category
        ..type.value = state.type
        ..date.value = date
        ..value.value = value;

      try {
        await transactionRepository.save(transaction);
      } catch (e, st) {
        emit(state.copyWith(
          status: CreateTransactionStatus.error,
          e: e,
          st: st,
        ));
      } finally {
        emit(state.copyWith(
          status: CreateTransactionStatus.loaded,
        ));
      }
    }

    final BlocError error = BlocError(
      "Couldn't save: not all the transaction properties specified",
    );
    final StackTrace stackTrace = StackTrace.current;
    emit(state.copyWith(
      status: CreateTransactionStatus.error,
      e: error,
      st: stackTrace,
    ));
  }

  void _onShouldUpdateCategoriesEvent(
    ShouldUpdateCategories event,
    Emitter<CreateTransactionState> emit,
  ) async =>
      emit(state.copyWith(
        categories: await categoryRepository.getAll(),
      ));

  void _onErrorEvent(
    ErrorEvent event,
    Emitter<CreateTransactionState> emit,
  ) =>
      emit(state.copyWith(
        status: CreateTransactionStatus.error,
        e: event.e,
        st: event.st,
      ));

  @override
  Future<void> close() => Future.wait([
        _categoryUpdateSubscription.cancel(),
        _transactionUpdateSubscriptiion.cancel(),
        super.close(),
      ]);
}
