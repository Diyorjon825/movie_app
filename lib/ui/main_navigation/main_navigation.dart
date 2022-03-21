import 'package:flutter/material.dart';
import 'package:movie_app/domain/factory/page_factory.dart';

class MainNavigation {
  static final pageFactory = PageFactory();
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.homePage: (context) => pageFactory.buildHomePage(),
    MainNavigationRouteNames.searchPage: (context) =>
        pageFactory.buildSearchPage(),
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.detailInfoPage:
        {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => pageFactory.buildDetailPage(id),
          );
        }
    }
    return null;
  }
}

abstract class MainNavigationRouteNames {
  static const homePage = '/';
  static const detailInfoPage = '/detail_info_page';
  static const searchPage = '/search_page';
}
