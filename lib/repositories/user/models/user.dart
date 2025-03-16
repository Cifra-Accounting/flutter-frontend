import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';

import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';

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
    this.dailyLimit,
  });

  final Money? dailyLimit;
  final String? language;

  bool get isIntroduced => dailyLimit != null && language != null;

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (language != null) languageColumn: language,
        ...?dailyLimit?.toMap(),
      };

  User.fromMap(Map<String, dynamic> map)
      : language = map[languageColumn],
        dailyLimit = tryCall<Money, Map<String, dynamic>>(
          function: Money.fromMap,
          argument: map,
          onCatch: () => null,
        );

  User copyWith({String? language, Money? dailyLimit}) => User(
        language: language ?? this.language,
        dailyLimit: dailyLimit ?? this.dailyLimit,
      );

  @override
  List<Object?> get props => [
        language,
        dailyLimit,
      ];

  static Set<String> get columns => {
        currencyColumn,
        amountColumn,
        languageColumn,
      };
}
