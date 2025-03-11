import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/models/get_filter.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';

class DateTimeFilter extends GetFilter {
  const DateTimeFilter({required this.from, required this.to});

  DateTimeFilter.fromPeriod({required Periods period})
      : from = period.calculatePeriodBoundaries().$1,
        to = period.calculatePeriodBoundaries().$2;

  final DateTime from;
  final DateTime to;

  @override
  String get whereRaw => "$dateColumn BETWEEN ? AND ?";

  @override
  List get whereRawArgs => [from.toIso8601String(), to.toIso8601String()];
}
