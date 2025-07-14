import 'package:cifra_app/features/create_transaction/domain/create_transaction/bloc.dart';
import 'package:cifra_app/features/create_transaction/views/create_transaction_view.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/currency_exchange/exchange_rate_repository.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:cifra_app/common/ui/ui.dart';
import 'package:cifra_app/common/icon_pack/c1fra__icons.dart';
import 'package:cifra_app/common/navigation/routing_constants.dart';
import 'package:cifra_app/common/constants/numeric_constants.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: C1fraAppBar(
        leading: SvgPicture.asset(
          "assets/c1fra_logo.svg",
          height: iconSize,
          fit: BoxFit.fitHeight,
        ),
        trailing: IconButton(
          icon: Icon(
            C1fraIcons.settingsMenuIcon,
            size: iconSize,
            color: colorScheme.onPrimary,
          ),
          onPressed: () => context.go(settingsPath),
        ),
      ),
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: C1fraNavigationBar(
        index: navigationShell.currentIndex,
        leading: const Icon(C1fraIcons.wallet, size: 25),
        trailing: const Icon(C1fraIcons.stats, size: 25),
        onTap: (index) => navigationShell.goBranch(index),
        onPlusTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isDismissible: true,
          showDragHandle: true,
          useRootNavigator: true,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (context) => BlocProvider(
            create: (context) => CreateTransactionBloc(
              userRepository: context.read<UserRepository>(),
              exchangeRateRepository: context.read<ExchangeRateRepository>(),
              transactionRepository: context.read<TransactionRepository>(),
              categoryRepository: context.read<CategoryRepository>(),
            ),
            child: CreateTransactionView(),
          ),
        ),
      ),
    );
  }
}
