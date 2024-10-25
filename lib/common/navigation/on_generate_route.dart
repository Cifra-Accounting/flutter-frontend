import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  return switch (settings.name) {
    _ => null,
  };
}
