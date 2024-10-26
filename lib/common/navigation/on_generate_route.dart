import 'package:cifra_app/common/navigation/navigation.dart';
import 'package:cifra_app/features/home/views/home_view.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  return switch (settings.name) {
    RouteNames.home => MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    _ => null,
  };
}
