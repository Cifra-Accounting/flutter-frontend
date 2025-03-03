import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';

import 'package:cifra_app/common/models/money.dart';

extension EnumFromString on Currency {
  Currency? fromString(String string) {
    for (final Currency currency in Currency.values) {
      if (currency.name == string) return currency;
    }
    return null;
  }
}

// Changing this model do remember to change the repository accordingly
@immutable
class User extends Equatable {
  const User({this.currency, this.language, this.dailyLimit});

  final Currency? currency;
  final String? language;
  final int? dailyLimit;

  Map<String, dynamic> toMap() => <String, dynamic>{
        currencyColumn: currency?.name,
        languageColumn: language,
        dailyLimitColumn: dailyLimit,
      };

  User.fromMap(Map<String, dynamic> map)
      : currency =
            Currency.usd.fromString(map[currencyColumn]), //TODO : fix this
        language = map[languageColumn],
        dailyLimit = map[dailyLimitColumn];

  User copyWith({Currency? currency, String? language, int? dailyLimit}) =>
      User(
        currency: currency ?? this.currency,
        language: language ?? this.language,
        dailyLimit: dailyLimit ?? this.dailyLimit,
      );

  @override
  List<Object?> get props => [
        currency,
        language,
        dailyLimit,
      ];

  static Set<String> get columns => {
        currencyColumn,
        languageColumn,
        dailyLimitColumn,
      };
}
