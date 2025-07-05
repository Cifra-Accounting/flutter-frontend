import 'package:cifra_app/common/constants/enums.dart';
import 'package:cifra_app/common/navigation/routing_constants.dart';
import 'package:cifra_app/features/home/views/home_view.dart';
import 'package:cifra_app/features/onboarding/domain/intro_bloc/bloc.dart';
import 'package:cifra_app/features/onboarding/views/onboarding_view.dart';
import 'package:cifra_app/features/stats/views/stats_view.dart';
import 'package:cifra_app/features/wallet/domain/bloc/history_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/domain/bloc/stats_bloc.dart/bloc.dart';
import 'package:cifra_app/features/wallet/views/wallet_view.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';
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
        kDebugMode
            ? state.error?.message ?? 'Что-то пошло не так'
            : 'Что-то пошло не так',
      ),
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  ),
  redirect: (context, state) =>
      context.read<UserRepository>().get().isIntroduced ? null : onBoardingPath,
  initialLocation: walletPath,
  routes: <RouteBase>[
    GoRoute(
      path: onBoardingPath,
      builder: (context, state) => BlocProvider<IntroBloc>(
        create: (context) => IntroBloc(
          userRepository: context.read<UserRepository>(),
        ),
        child: OnboardingView(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeView(navigationShell: navigationShell),
      redirect: (context, state) =>
          context.read<UserRepository>().get().isIntroduced ? null : null,
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: walletPath,
              builder: (context, state) => MultiBlocProvider(
                providers: <BlocProvider>[
                  BlocProvider<HistoryBloc>(
                    create: (context) => HistoryBloc(
                      transactionRepository:
                          context.read<TransactionRepository>(),
                    ),
                  ),
                  BlocProvider<StatsBloc>(
                    create: (context) => StatsBloc(
                      transactionRepository:
                          context.read<TransactionRepository>(),
                      userRepository: context.read<UserRepository>(),
                    )..add(PeriodPromptedStatsEvent(period: Periods.day)),
                  ),
                ],
                child: WalletView(),
              ),
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
