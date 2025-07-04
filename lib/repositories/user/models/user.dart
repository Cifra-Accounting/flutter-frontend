import 'package:cifra_app/common/constants/enums.dart';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';

import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/utils/db_constants.dart';

/// Tries to call the provided [function], if it throws,
/// calls the [onCatch] callback
///
/// T - the return type of the provided function
/// V - argument type of the provided function
///
T? tryCall<T, V>({
  required T Function(V) function,
  required V argument,
  required T? Function() onCatch,
}) {
  try {
    return function(argument);
  } catch (e) {
    return onCatch();
  }
}

@immutable
class User extends Equatable {
  const User({
    this.language,
    this.dateFormat,
    this.dailyLimit,
  });

  final Money? dailyLimit;
  final Languages? language;
  final DateFormat? dateFormat;

  bool get isIntroduced =>
      dailyLimit != null && language != null && dateFormat != null;

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (dateFormat != null) dateFormatColumn: dateFormat?.name,
        if (language != null) languageColumn: language?.name,
        ...?dailyLimit?.toMap(),
      };

  User.fromMap(Map<String, dynamic> map)
      : dateFormat = DateFormat.values
            .where((format) => format.name == map[dateFormatColumn])
            .firstOrNull,
        language = Languages.values
            .where((language) => language.name == map[languageColumn])
            .firstOrNull,
        dailyLimit = tryCall<Money, Map<String, dynamic>>(
          function: Money.fromMap,
          argument: map,
          onCatch: () => null,
        );

  User copyWith({
    Languages? language,
    Money? dailyLimit,
    DateFormat? dateFormat,
  }) =>
      User(
        language: language ?? this.language,
        dateFormat: dateFormat ?? this.dateFormat,
        dailyLimit: dailyLimit ?? this.dailyLimit,
      );

  @override
  List<Object?> get props => [
        language,
        dailyLimit,
        dateFormat,
      ];

  static Set<String> get columns => {
        currencyColumn,
        amountColumn,
        languageColumn,
        dateFormatColumn,
      };
}
