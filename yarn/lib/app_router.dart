import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yarn/widgets/screens/placeholder_screen.dart';
import 'package:yarn/widgets/screens/rooms/rooms_screen.dart';
import 'package:yarn/widgets/screens/today_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/today',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => Scaffold(
        body: shell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (i) =>
              shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Today',
            ),
            NavigationDestination(icon: Icon(Icons.chair), label: 'Rooms'),
          ],
        ),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/today', builder: (_, _) => const TodayScreen()),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(path: '/room', builder: (_, _) => const RoomsScreen()),
          ],
        ),
      ],
    ),
  ],
);
