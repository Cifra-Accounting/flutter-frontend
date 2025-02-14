import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/expences/repository.dart';
import 'package:cifra_app/repositories/incomes/repository.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/get_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';
part 'state.dart';

class CategoryFilter extends GetFilter {
  const CategoryFilter({List<Category>? categories})
      : categories = categories ?? const [];

  final List<Category> categories;

  @override
  String get whereRaw =>
      "$categoryIdColumn IN (${categories.map((e) => '?').join(",")})";

  @override
  List<int> get whereRawArgs => categories.map((e) => e.id.value!).toList();
}

class DateTimeFilter extends GetFilter {
  const DateTimeFilter({required this.from, required this.to});

  final DateTime from;
  final DateTime to;

  @override
  String get whereRaw => "$dateColumn BETWEEN ? AND ?";

  @override
  List get whereRawArgs => [from.toIso8601String(), to.toIso8601String()];
}

sealed class HistoryEvent {
  const HistoryEvent();
}

class InitialHistoryEvent extends HistoryEvent {
  const InitialHistoryEvent();
}

class HitBottomHistoryEvent extends HistoryEvent {
  const HitBottomHistoryEvent();
}

class ChangeFiltersHistoryEvent<T extends GetFilter> extends HistoryEvent {
  const ChangeFiltersHistoryEvent();
}

class UpdatedRepositoryHistoryEvent extends HistoryEvent {
  const UpdatedRepositoryHistoryEvent();
}

class HistoryState {}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required this.incomeRepository,
    required this.expenceRepository,
  }) : super(HistoryState());

  final IncomeRepository incomeRepository;
  final ExpenceRepository expenceRepository;
}
