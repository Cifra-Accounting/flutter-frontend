import 'package:cifra_app/common/constants/numeric_constants.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';
import 'package:cifra_app/common/navigation/navigation.dart';
import 'package:cifra_app/common/ui/c1fra_app_bar.dart';
import 'package:cifra_app/common/ui/c1fra_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> body = const <Widget>[
    WalletView(),
    StatsView(),
  ];

  late final ColorScheme colorScheme;

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    colorScheme = theme.colorScheme;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            IndexedStack(
              index: _currentIndex,
              children: body,
            ),
            C1fraNavigationBar(
              index: _currentIndex,
              leading: const Icon(C1fraIcons.wallet, size: 25),
              trailing: const Icon(C1fraIcons.stats, size: 25),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              onPlusTap: () {},
            ),
          ],
        ),
      );
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
