import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/db_record.dart';

class Category extends DbRecord {
  final CvField<String> name = CvField<String>(categoryNameColumn);
  final CvField<int> icon = CvField<int>(categoryNameColumn);

  @override
  CvFields get fields => [id, name, icon];
}
