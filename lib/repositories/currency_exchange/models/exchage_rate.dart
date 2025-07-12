import 'package:cifra_app/common/models/money.dart';

class ExchangeRate {
  const ExchangeRate(
    this.fromCurrency,
    this.convertRates,
  );

  final Currency fromCurrency;
  final Map<Currency, double> convertRates;

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final Set<Currency> currencies = Currency.values.toSet();

    final fromCurrency = currencies.firstWhere(
      (Currency value) => json.containsKey(value.name),
    );

    final Map<Currency, double> rates = {};

    for (final MapEntry<String, dynamic> rate
        in json[fromCurrency.name].entries) {
      if (!currencies.asNameMap().containsKey(rate.key)) continue;
      if (rate.value is! num) continue;

      rates[currencies.byName(rate.key)] = rate.value.toDouble();
    }

    return ExchangeRate(fromCurrency, rates);
  }
}
