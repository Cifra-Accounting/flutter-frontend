// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/models/money.dart';

part 'event.freezed.dart';

@freezed
sealed class IntroEvent with _$IntroEvent {
  factory IntroEvent.update({
    Currency? currency,
    int? amountInSmallestUnits,
    Languages? language,
    DateFormat? dateFormat,
  }) = Update;
  factory IntroEvent.submited() = Submited;
}
