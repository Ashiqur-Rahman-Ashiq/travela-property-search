import 'package:flutter/material.dart';
import 'package:flutter_clean_boilerplate/data/local/app_database.dart';
import 'package:flutter_clean_boilerplate/features/travela_search/controllers/travela_search_controller.dart';
import 'package:flutter_clean_boilerplate/helper/route_healper.dart';
import 'package:flutter_clean_boilerplate/theme/controllers/theme_controller.dart';
import 'package:flutter_clean_boilerplate/theme/dark_theme.dart';
import 'package:flutter_clean_boilerplate/theme/light_theme.dart';
import 'package:flutter_clean_boilerplate/utill/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final database = AppDatabase();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<TravelaSearchController>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeController>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, _) {
        return MaterialApp.router(
          routerConfig: RouterHelper.goRoutes,
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: themeController.darkTheme ? dark : light(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: SafeArea(top: false, child: child!),
            );
          },
        );
      },
    );
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}
