import 'package:cifra_app/common/navigation/navigation.dart';
import 'package:flutter/material.dart';

import 'package:cifra_app/common/theme/theme.dart';

class C1fra extends StatelessWidget {
  const C1fra({super.key});

  final MaterialTheme theme = const MaterialTheme();

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: router,
        theme: theme.light(),
        highContrastTheme: theme.lightHighContrast(),
        debugShowCheckedModeBanner: false,
      );
}
