import 'dart:math';

import 'package:cifra_app/repositories/models/db_constants.dart';

enum Currency {
  usd(symbol: r'$', fractionDigits: 2),
  eur(symbol: '€', fractionDigits: 2),
  jpy(symbol: '¥', fractionDigits: 0),
  aud(symbol: r'A$', fractionDigits: 2),
  cad(symbol: r'C$', fractionDigits: 2),
  gbp(symbol: '£', fractionDigits: 2),
  rub(symbol: '₽', fractionDigits: 2),
  chf(symbol: 'CHF', fractionDigits: 2),
  cny(symbol: '¥', fractionDigits: 2),
  inr(symbol: '₹', fractionDigits: 2),
  brl(symbol: r'R$', fractionDigits: 2),
  nzd(symbol: r'N$', fractionDigits: 2);

  const Currency({
    required this.symbol,
    required this.fractionDigits,
  });

  final String symbol;
  final int fractionDigits;

  // Format an integer amount (in smallest units) into a string.
  String format(int smallestUnits) {
    final double decimalValue = smallestUnits / _scale;
    return '$symbol${decimalValue.toStringAsFixed(fractionDigits)}';
  }

  // Convert, for example, 1.23 into 123 if fractionDigits == 2
  int parseAmount(double value) => (value * _scale).round();

  int get _scale => (pow(10, fractionDigits)).clamp(1, 1000000).toInt();
}

class Money {
  const Money({
    required this.currency,
    required int amountInSmallestUnits,
  }) : _amountInSmallestUnits = amountInSmallestUnits;

  final Currency currency;

  // Stored in smallest currency units (e.g. cents for USD)
  final int _amountInSmallestUnits;

  // Return as decimal (e.g. 12.34)
  double get amount => _amountInSmallestUnits / currency._scale;

  // Return the string representation (e.g. $12.34)
  String get formattedAmount => currency.format(_amountInSmallestUnits);

  // Example: store in DB as map
  Map<String, dynamic> toMap() => {
        currencyColumn: currency.name,
        amountColumn: _amountInSmallestUnits,
      };

  factory Money.fromMap(Map<String, dynamic> map) {
    final Currency parsedCurrency = Currency.values.firstWhere(
      (c) => c.name == map[currencyColumn],
      orElse: () => Currency.usd,
    );
    return Money(
      currency: parsedCurrency,
      amountInSmallestUnits: map[amountColumn] as int,
    );
  }

  Money copyWith({Currency? currency, int? amountInSmallestUnits}) => Money(
        currency: currency ?? this.currency,
        amountInSmallestUnits: amountInSmallestUnits ?? _amountInSmallestUnits,
      );

  @override
  String toString() => formattedAmount;

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.currency == currency &&
      other._amountInSmallestUnits == _amountInSmallestUnits;

  @override
  int get hashCode => currency.hashCode ^ _amountInSmallestUnits.hashCode;
}
