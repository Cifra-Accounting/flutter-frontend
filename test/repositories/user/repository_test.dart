import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:cifra_app/repositories/user/utils/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<SharedPreferencesWithCache>()])
import 'repository_test.mocks.dart';

void main() {
  group("Test the User Repository", () {
    UserRepository? repository;
    MockSharedPreferencesWithCache? prefs;

    final User testUser1 = const User(
      dailyLimit: Money(currency: Currency.usd, amountInSmallestUnits: 1000),
      language: Languages.english,
      dateFormat: DateFormat.ddmmyy,
    );

    setUp(() async {
      prefs = MockSharedPreferencesWithCache();
      repository = UserRepository();
      await repository?.init(prefs: prefs);
    });

    test("Repository saves the User model and returns it correctly", () async {
      await repository?.save(testUser1);

      repository?.get();

      for (final String column in User.columns) {
        verify(prefs?.set(column, testUser1.toMap()[column])).called(1);
        verify(prefs?.get(column)).called(1);
      }
    });

    test("Repository correctly resets data inside it", () async {
      await repository?.save(testUser1);

      await repository?.reset();

      for (final String column in User.columns) {
        verify(prefs?.set(column, testUser1.toMap()[column])).called(1);
        verify(prefs?.remove(column)).called(1);
      }
    });

    tearDown(() => repository?.reset());
  });
}
