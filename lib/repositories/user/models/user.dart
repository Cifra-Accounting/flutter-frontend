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

@immutable
class User extends Equatable {
  const User({
    this.currency,
    this.language,
  });

  final Currency? currency;
  final String? language;

  Map<String, dynamic> toMap() => <String, dynamic>{
        currencyColumn: currency?.name,
        languageColumn: language,
      };

  User.fromMap(Map<String, dynamic> map)
      : currency = Currency.usd.fromString(
          map[currencyColumn],
        ), //TODO : fix this
        language = map[languageColumn];

  User copyWith({Currency? currency, String? language}) => User(
        currency: currency ?? this.currency,
        language: language ?? this.language,
      );

  @override
  List<Object?> get props => [currency, language];

  static Set<String> get columns => {currencyColumn, languageColumn};
}
