import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yarn/widgets/screens/placeholder_screen.dart';
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
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Week',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Me',
            ),
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
            GoRoute(
              path: '/week',
              builder: (_, _) => const PlaceholderScreen('Week'),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, _) => const PlaceholderScreen('Home'),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/me',
              builder: (_, _) => const PlaceholderScreen('Me'),
            ),
          ],
        ),
      ],
    ),
  ],
);
