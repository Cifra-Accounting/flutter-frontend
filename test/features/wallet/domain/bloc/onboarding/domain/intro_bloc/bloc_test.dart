import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/features/onboarding/domain/onboard_bloc/event.dart';
import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cifra_app/features/onboarding/domain/onboard_bloc/bloc.dart';
import 'package:cifra_app/features/onboarding/domain/onboard_bloc/state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'bloc_test.mocks.dart';

void main() {
  group("Test the IntroBloc", () {
    final User testUser = User(
      dailyLimit: Money(currency: Currency.rub, amountInSmallestUnits: 0),
      dateFormat: DateFormat.ddmmyy,
      language: Languages.russian,
    );
    MockUserRepository? userRepository;

    setUp(() {
      userRepository = MockUserRepository();
    });

    blocTest<IntroBloc, IntroState>(
      "Updates the state correctly",
      build: () => IntroBloc(userRepository: userRepository!),
      act: (bloc) => bloc.add(IntroEvent.update(
        currency: Currency.rub,
        language: Languages.russian,
      )),
      expect: () => [
        isA<Initial>().having(
          (state) => [state.currency, state.language],
          "New state has to be updated acordingly",
          equals([Currency.rub, Languages.russian]),
        ),
      ],
    );

    blocTest<IntroBloc, IntroState>(
      "Saves state correctly",
      setUp: () => when(userRepository?.save(any)).thenAnswer(
        (_) => Future.value(),
      ),
      build: () => IntroBloc(userRepository: userRepository!),
      seed: () => IntroState.initial(
        currency: testUser.dailyLimit?.currency,
        amountInSmallestUnits: testUser.dailyLimit?.amount.toInt(),
        language: testUser.language,
        dateFormat: testUser.dateFormat,
      ),
      act: (bloc) => bloc.add(IntroEvent.submited()),
      expect: () => [
        isA<Saving>().having(
          (state) => [state.currency, state.language, state.dateFormat],
          "New state saves previous data",
          equals(
            [
              testUser.dailyLimit?.currency,
              testUser.language,
              testUser.dateFormat
            ],
          ),
        ),
        isA<Saved>().having(
          (state) => [state.currency, state.language, state.dateFormat],
          "New state saves previous data",
          equals(
            [
              testUser.dailyLimit?.currency,
              testUser.language,
              testUser.dateFormat
            ],
          ),
        ),
      ],
      verify: (bloc) => verify(userRepository?.save(testUser)).called(1),
    );

    blocTest<IntroBloc, IntroState>(
      "Correctly reacts to errors",
      setUp: () => when(userRepository?.save(any)).thenThrow("test"),
      build: () => IntroBloc(userRepository: userRepository!),
      seed: () => IntroState.initial(
        currency: testUser.dailyLimit?.currency,
        amountInSmallestUnits: testUser.dailyLimit?.amount.toInt(),
        language: testUser.language,
        dateFormat: testUser.dateFormat,
      ),
      act: (bloc) => bloc.add(IntroEvent.submited()),
      expect: () => [
        isA<Saving>().having(
          (state) => [state.currency, state.language, state.dateFormat],
          "New state saves previous data",
          equals(
            [
              testUser.dailyLimit?.currency,
              testUser.language,
              testUser.dateFormat
            ],
          ),
        ),
        isA<Error>().having(
          (state) => [
            state.e,
            state.currency,
            state.language,
            state.dateFormat,
          ],
          "New state saves previous data",
          equals(
            [
              "test",
              testUser.dailyLimit?.currency,
              testUser.language,
              testUser.dateFormat
            ],
          ),
        ),
      ],
      verify: (bloc) => verify(userRepository?.save(testUser)).called(1),
    );
  });
}
