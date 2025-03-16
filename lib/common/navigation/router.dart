import 'package:cifra_app/common/navigation/routing_constants.dart';
import 'package:cifra_app/features/home/views/home_view.dart';
import 'package:cifra_app/features/stats/views/stats_view.dart';
import 'package:cifra_app/features/wallet/views/wallet_view.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  onException: (context, state, router) =>
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        kDebugMode ? 'Что-то пошло не так' : router.state.error!.message,
      ),
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  ),
  initialLocation: walletPath,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeView(navigationShell: navigationShell),
      redirect: (context, state) =>
          !context.read<UserRepository>().get().isIntroduced ? null : null,
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: walletPath,
              builder: (context, state) => WalletView(),
            )
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: statsPath,
              builder: (context, state) => StatsView(),
            )
          ],
        ),
      ],
    ),
  ],
);
