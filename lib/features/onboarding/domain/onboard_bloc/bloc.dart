import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/features/onboarding/domain/onboard_bloc/event.dart';
import 'package:cifra_app/features/onboarding/domain/onboard_bloc/state.dart';

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
    emit(IntroState.saving(
      currency: state.currency,
      amountInSmallestUnits: state.amountInSmallestUnits,
      language: state.language,
      dateFormat: state.dateFormat,
    ));

    final User user = User(
      dailyLimit: Money(
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
