import 'package:flutter/foundation.dart';

abstract class GetFilter {
  const GetFilter();

  /// The raw SQL WHERE clause
  /// override to define what filter will do
  String get whereRaw =>
      throw (UnimplementedError("Extending classes should implement this"));

  /// The raw arguments for the WHERE clause
  List<dynamic> get whereRawArgs =>
      throw (UnimplementedError("Extending classes should implement this"));

  @nonVirtual
  String get where => "WHERE $whereRaw";
  @nonVirtual
  List<dynamic> get whereArgs => whereRawArgs;

  @nonVirtual
  GetFilter operator &(GetFilter other) => AndFilter(this, other);
}

class AndFilter extends GetFilter {
  AndFilter(this._first, this._second);

  final GetFilter _first;
  final GetFilter _second;

  @override
  String get whereRaw => "${_first.whereRaw} AND ${_second.whereRaw}";

  @override
  List<dynamic> get whereRawArgs =>
      [..._first.whereRawArgs, ..._second.whereRawArgs];
}
