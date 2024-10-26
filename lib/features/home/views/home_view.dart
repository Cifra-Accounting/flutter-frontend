import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';
import 'package:cifra_app/common/navigation/navigation.dart';
import 'package:cifra_app/common/ui/c1fra_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: C1fraAppBar(
        leading: SvgPicture.asset(
          "assets/c1fra_logo.svg",
          height: NumericConstants.appBarElementSize,
          fit: BoxFit.fitHeight,
        ),
        trailing: IconButton(
          icon: Icon(
            C1fraIcons.settingsMenuIcon,
            size: NumericConstants.appBarElementSize,
            color: colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: NumericConstants.horizontalPadding,
        ),
        child: Container(
          height: 277,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
        ),
      ),
    );
  }
}
