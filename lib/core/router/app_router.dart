import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/gemstone_detail/presentation/screens/gemstone_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import 'route_names.dart';

/// Central go_router configuration.
///
/// Each feature registers its routes here. The home screen serves as the
/// shell with bottom navigation.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/gemstone/:id',
      name: RouteNames.gemstoneDetail,
      pageBuilder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: GemstoneDetailScreen(gemstoneId: id),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
