import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';

import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';

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
        dailyLimit = Money.fromMap(map);

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
