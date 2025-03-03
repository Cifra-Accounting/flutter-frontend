import 'package:cifra_app/common/models/get_filter.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';

class TypeFilter extends GetFilter {
  const TypeFilter({required this.type});

  final TransactionType type;

  @override
  String get whereRaw => '$typeColumn = ?';

  @override
  List get whereRawArgs => [type.name];
}
