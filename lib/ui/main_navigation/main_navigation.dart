import 'package:flutter/material.dart';
import 'package:movie_app/ui/pages/home_page/home_page.dart';
import 'package:movie_app/ui/pages/home_page/home_page_model.dart';
import 'package:provider/provider.dart';

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.homePage: (context) => ChangeNotifierProvider(
          create: (context) => HomePageModel(),
          child: const HomePage(),
        )
  };
  final initialRoute = MainNavigationRouteNames.homePage;
}

abstract class MainNavigationRouteNames {
  static const homePage = 'home_page';
}
