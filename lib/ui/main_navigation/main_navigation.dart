import 'package:flutter/material.dart';
import 'package:movie_app/ui/pages/detail_info_page/detail_info_page.dart';
import 'package:movie_app/ui/pages/detail_info_page/detail_info_page_model.dart';
import 'package:movie_app/ui/pages/home_page/home_page.dart';
import 'package:movie_app/ui/pages/home_page/home_page_viewModel.dart';
import 'package:provider/provider.dart';

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.homePage: (context) => ChangeNotifierProvider(
          create: (context) => HomePageViewModel(),
          child: const HomePage(),
        )
  };
  final initialRoute = MainNavigationRouteNames.homePage;
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.detailInfoPage:
        {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => DetailInfoPageModel(id: id),
              child: DetailInfoPage(),
            ),
          );
        }
    }
    return null;
  }
}

abstract class MainNavigationRouteNames {
  static const homePage = '/';
  static const detailInfoPage = '/detail_info_page';
}
