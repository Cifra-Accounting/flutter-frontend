import 'package:flutter/material.dart';

import 'package:cifra_app/common/navigation/on_generate_route.dart';
import 'package:cifra_app/common/navigation/route_names.dart';
import 'package:cifra_app/common/theme/theme.dart';

class C1fra extends StatelessWidget {
  const C1fra({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: theme,
        onGenerateRoute: onGenerateRoute,
        initialRoute: RouteNames.home,
        debugShowCheckedModeBanner: false,
      );
}
