import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/features/onboarding/domain/constants/fields.dart';
import 'package:cifra_app/features/onboarding/domain/models/error.dart';
import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/features/onboarding/domain/intro_bloc/event.dart';
import 'package:cifra_app/features/onboarding/domain/intro_bloc/state.dart';

extension ToUnion on IntroState {
  IntroState toInitial() => IntroState.initial(
        currency: currency,
        amountInSmallestUnits: amountInSmallestUnits,
        language: language,
        dateFormat: dateFormat,
      );
}

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  IntroBloc({required this.userRepository}) : super(IntroState.initial()) {
    on<IntroEvent>((event, emit) => switch (event) {
          Update _ => _onUpdateEvent(event, emit),
          Submited _ => _onSubmitedEvent(event, emit)
        });
  }

  final UserRepository userRepository;

  void _onUpdateEvent(Update event, Emitter<IntroState> emit) => emit(state
      .copyWith(
        amountInSmallestUnits: event.amountInSmallestUnits,
        currency: event.currency,
        language: event.language,
        dateFormat: event.dateFormat,
      )
      .toInitial());

  void _onSubmitedEvent(Submited event, Emitter<IntroState> emit) async {
    final Map<String, dynamic> fields = {
      currencyField: state.currency,
      amountField: state.amountInSmallestUnits,
      languageField: state.language,
      dateFormatField: state.dateFormat,
    };

    final List<String> nullFields = fields.entries
        .where((entry) => entry.value == null)
        .map((entry) => entry.key)
        .toList();

    if (nullFields.isNotEmpty) {
      emit(IntroState.error(
        e: MissingFieldsError(missingFields: nullFields),
        currency: state.currency,
        amountInSmallestUnits: state.amountInSmallestUnits,
        language: state.language,
        dateFormat: state.dateFormat,
      ));
      return;
    }

    emit(IntroState.saving(
      currency: state.currency,
      amountInSmallestUnits: state.amountInSmallestUnits,
      language: state.language,
      dateFormat: state.dateFormat,
    ));

    final User user = User(
      limit: Money(
        currency: state.currency!,
        amountInSmallestUnits: state.amountInSmallestUnits!,
      ),
      language: state.language,
      dateFormat: state.dateFormat,
    );

    try {
      await userRepository.save(user);

      emit(IntroState.saved(
        currency: state.currency,
        amountInSmallestUnits: state.amountInSmallestUnits,
        language: state.language,
        dateFormat: state.dateFormat,
      ));
    } catch (e, st) {
      emit(IntroState.error(
        e: e,
        st: st,
        currency: state.currency,
        amountInSmallestUnits: state.amountInSmallestUnits,
        language: state.language,
        dateFormat: state.dateFormat,
      ));
    }
  }
}
