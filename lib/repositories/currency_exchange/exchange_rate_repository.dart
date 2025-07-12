import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/currency_exchange/models/exchage_rate.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'exchange_rate_repository.g.dart';

@RestApi()
abstract class ExchangeRateRepository {
  factory ExchangeRateRepository(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ExchangeRateRepository;

  /// To call please convert the desired date to YYYY-MM-DD format
  @GET("currency-api@{date}/v1/{currency}.json")
  Future<ExchangeRate> getRate({
    @Path("date") String date = "latest",
    @Path("currency") required Currency currency,
  });
}
