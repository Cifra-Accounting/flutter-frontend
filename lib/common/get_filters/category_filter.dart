import 'package:cifra_app/common/models/get_filter.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/utils/db_constants.dart';

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
