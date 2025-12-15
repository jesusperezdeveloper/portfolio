import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_jps/features/home/presentation/pages/home_page.dart';
import 'package:portfolio_jps/features/terminal/presentation/pages/terminal_page.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String terminal = '/terminal';
  static const String projectDetail = '/projects/:id';
}

abstract class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.terminal,
        name: 'terminal',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TerminalPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(
                  CurveTween(curve: Curves.easeOutCubic).animate(animation),
                ),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.projectDetail,
        name: 'projectDetail',
        pageBuilder: (context, state) {
          final projectId = state.pathParameters['id'] ?? '';
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProjectDetailPage(projectId: projectId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurveTween(curve: Curves.easeOutCubic).animate(animation),
                  ),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: const NotFoundPage(),
    ),
  );
}

// Placeholder pages - will be replaced with actual implementations
class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Project: $projectId'),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
