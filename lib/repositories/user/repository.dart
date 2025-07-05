import 'package:cifra_app/repositories/user/models/user.dart';
import 'package:cifra_app/repositories/user/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  late final SharedPreferencesWithCache _prefs;

  Future init({SharedPreferencesWithCache? prefs}) async {
    _prefs = prefs ??
        await SharedPreferencesWithCache.create(
          sharedPreferencesOptions: SharedPreferencesOptions(),
          cacheOptions:
              SharedPreferencesWithCacheOptions(allowList: User.columns),
        );
  }

  Future save(User user) => Future.wait(user.toMap().entries.map<Future>(
        (MapEntry<String, dynamic> entry) => _prefs.set(entry.key, entry.value),
      ));

  User get() =>
      User.fromMap(Map.fromEntries(User.columns.map<MapEntry<String, dynamic>>(
        (String columnName) => MapEntry(columnName, _prefs.get(columnName)),
      )));

  Future reset() => Future.wait(User.columns.map<Future>(
        (String columnName) => _prefs.remove(columnName),
      ));
}
