import 'package:cifra_app/features/create_transaction/domain/create_transaction/event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';

import 'package:cifra_app/features/create_transaction/domain/create_transaction/bloc.dart';
import 'package:cifra_app/features/create_transaction/domain/create_transaction/state.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<TransactionRepository>(),
  MockSpec<CategoryRepository>()
])
import 'bloc.mocks.dart';

void main() {
  group(
    "Test CreateTransactionBloc",
    () {
      MockUserRepository? userRepository;
      MockTransactionRepository? transactionRepository;
      MockCategoryRepository? categoryRepository;

      final List<Category> mockCategories = List.filled(15, Category());

      setUp(() {
        userRepository = MockUserRepository();
        transactionRepository = MockTransactionRepository();
        categoryRepository = MockCategoryRepository();
      });

      blocTest<CreateTransactionBloc, CreateTransactionState>(
        "Bloc should emit state with categories after it gets it",
        setUp: () => when(categoryRepository?.getAll())
            .thenAnswer((_) => Future.value(mockCategories)),
        build: () => CreateTransactionBloc(
          userRepository: userRepository!,
          transactionRepository: transactionRepository!,
          categoryRepository: categoryRepository!,
        ),
        expect: () => isA<CreateTransactionState>()
            .having(
              (state) => state.categories,
              "Categories should be not empty",
              isNotEmpty,
            )
            .having(
              (state) => state.categories,
              "Categories should be the same as in the repostiory",
              equals(mockCategories),
            ),
        verify: (bloc) => verify(categoryRepository?.getAll()).called(1),
      );

      blocTest<CreateTransactionBloc, CreateTransactionState>(
        "Bloc should update its categories once triggered",
        setUp: () => when(categoryRepository?.getAll())
            .thenAnswer((_) => Future.value(mockCategories)),
        build: () => CreateTransactionBloc(
          userRepository: userRepository!,
          transactionRepository: transactionRepository!,
          categoryRepository: categoryRepository!,
        ),
        skip: 1,
        act: (bloc) =>
            bloc.add(CreateTransactionEvent.shouldUpdateCategories()),
        expect: () => isA<CreateTransactionState>()
            .having(
              (state) => state.categories,
              "Categories should be not empty",
              isNotEmpty,
            )
            .having(
              (state) => state.categories,
              "Categories should be the same as in the repostiory",
              equals(mockCategories),
            ),
        verify: (bloc) => verify(categoryRepository?.getAll()).called(2),
      );

      blocTest<CreateTransactionBloc, CreateTransactionState>(
        "Bloc should emit new state when update event was issued",
        build: () => CreateTransactionBloc(
          userRepository: userRepository!,
          transactionRepository: transactionRepository!,
          categoryRepository: categoryRepository!,
        ),
        expect: () => isA<CreateTransactionState>()
            .having(
              (state) => state.categories,
              "Categories should be not empty",
              isNotEmpty,
            )
            .having(
              (state) => state.categories,
              "Categories should be the same as in the repostiory",
              equals(mockCategories),
            ),
        verify: (bloc) => verify(categoryRepository?.getAll()).called(1),
      );

      tearDown(() {
        userRepository = null;
        transactionRepository = null;
        categoryRepository = null;
      });
    },
    skip: true,
  );
}
