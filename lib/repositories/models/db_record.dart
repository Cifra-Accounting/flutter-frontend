import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cv/cv.dart';

abstract class DbRecord extends CvModelBase {
  final CvField<int> id = CvField.withNull(idColumn);
}
