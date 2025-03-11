import 'package:shared_preferences/shared_preferences.dart';

extension DynamicSharedPreferencesWithCahche on SharedPreferencesWithCache {
  Future<void> set(String key, dynamic value) => switch (value) {
        String _ => setString(key, value),
        int _ => setInt(key, value),
        bool _ => setBool(key, value),
        double _ => setDouble(key, value),
        List<String> _ => setStringList(key, value),
        _ => throw TypeError(),
      };
}
