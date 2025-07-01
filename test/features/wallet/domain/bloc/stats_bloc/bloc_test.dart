import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';

@GenerateNiceMocks([
  MockSpec<Transaction>(),
  MockSpec<TransactionRepository>(),
  MockSpec<UserRepository>()
])
// import 'bloc_test.mocks.dart';

void main() {}
