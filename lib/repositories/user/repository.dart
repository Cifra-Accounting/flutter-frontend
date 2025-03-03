import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  late final SharedPreferencesWithCache _prefs;

  void init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(allowList: User.columns),
    );
  }

  void save(User user) async {
    await Future.wait([
      _prefs.setString(languageColumn, user.language ?? ''),
      _prefs.setString(currencyColumn, user.currency?.name ?? '')
    ]);
  }

  User get() {
    final Map<String, dynamic> map = <String, dynamic>{
      currencyColumn: _prefs.get(currencyColumn),
      languageColumn: _prefs.get(languageColumn),
    };

    return User.fromMap(map);
  }

  void reset() async => Future.wait([
        _prefs.remove(currencyColumn),
        _prefs.remove(languageColumn),
      ]);
}
