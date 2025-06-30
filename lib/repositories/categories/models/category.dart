import 'package:cifra_app/repositories/utils/db_constants.dart';
import 'package:cifra_app/repositories/models/db_record.dart';
import 'package:cv/cv.dart';

class Category extends DbRecord {
  final CvField<String> name = CvField.withNull(categoryNameColumn);
  final CvField<int> icon = CvField.withNull(categoryIconColumn);

  @override
  CvFields get fields => [id, name, icon];
}
