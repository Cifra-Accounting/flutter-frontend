import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/models/db_constants.dart';

abstract class DbRecord extends CvModelBase {
  final CvField<int> id = CvField<int>(idColumn);
}
