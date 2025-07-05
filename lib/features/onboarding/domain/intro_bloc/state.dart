// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/models/money.dart';

part 'state.freezed.dart';

@freezed
sealed class IntroState with _$IntroState {
  factory IntroState.initial({
    Currency? currency,
    int? amountInSmallestUnits,
    Languages? language,
    DateFormat? dateFormat,
  }) = Initial;
  factory IntroState.saving({
    Currency? currency,
    int? amountInSmallestUnits,
    Languages? language,
    DateFormat? dateFormat,
  }) = Saving;
  factory IntroState.saved({
    Currency? currency,
    int? amountInSmallestUnits,
    Languages? language,
    DateFormat? dateFormat,
  }) = Saved;
  factory IntroState.error({
    Object? e,
    StackTrace? st,
    Currency? currency,
    int? amountInSmallestUnits,
    Languages? language,
    DateFormat? dateFormat,
  }) = Error;
}
