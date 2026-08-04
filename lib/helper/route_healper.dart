import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/screens/travela_search_screen.dart';
import 'package:flutter_clean_boilerplate/features/splash/screens/splash_screen.dart';
import 'package:flutter_clean_boilerplate/main.dart';
import 'package:go_router/go_router.dart';

enum RouteAction { push, pushReplacement, pushNamedAndRemoveUntil }

class RouterHelper {
  static const String splashScreen = '/splash';
  static const String homeScreen = '/home';

  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
  static String getHomeRoute({RouteAction? action}) => _navigateRoute(homeScreen, route: action);

  static String _navigateRoute(String path, {RouteAction? route = RouteAction.push, Object? extra}) {
    if (route == RouteAction.pushNamedAndRemoveUntil) {
      Get.context?.go(path, extra: extra);
    } else if (route == RouteAction.pushReplacement) {
      GoRouter.of(Get.context!).pushReplacement(path, extra: extra);
    } else {
      Get.context?.push(path, extra: extra);
    }
    return path;
  }

  static final GoRouter goRoutes = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splashScreen,
    routes: [
      GoRoute(path: splashScreen, name: splashScreen, pageBuilder: (context, state) => _pageBuilder(const SplashScreen(), state)),
      GoRoute(path: homeScreen, name: homeScreen, pageBuilder: (context, state) => _pageBuilder(const TravelaSearchScreen(), state)),
    ],
  );

  static Page<dynamic> _pageBuilder(Widget child, GoRouterState state) {
    return MaterialPage(key: state.pageKey, child: child);
  }
}
