import 'package:cifra_app/repositories/models/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Money parsing test", () {
    test("fromMap", () {
      const Currency usd = Currency.usd;
      final Map<String, Object?> map = {
        'currency': 'usd',
        'amount': 123,
      };

      final Money money = Money.fromMap(map);

      expect(money.currency, usd);
      expect(money.amount, 1.23);
      expect(money.formattedAmount, "\$1.23");
    });

    test("toMap", () {
      const Currency usd = Currency.usd;
      const Money money = Money(
        currency: usd,
        amountInSmallestUnits: 123,
      );

      final Map<String, dynamic> map = money.toMap();

      expect(map['currency'], 'usd');
      expect(map['amount'], 123);
      expect(map.entries.length, 2);
    });
  });
}
