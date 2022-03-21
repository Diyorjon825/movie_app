import 'package:flutter/material.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/ui/main_navigation/main_navigation.dart';
import 'package:movie_app/ui/pages/home_page/hone_page_model.dart';

class HomePageViewModel extends ChangeNotifier {
  final homePageModel = HomePageModel();
  String? searchText;
  bool isSearchOn = false;

  List<Movie> get popularMovies => homePageModel.popularFIlmModel.movies;
  List<Movie> get upcomingMovies => homePageModel.upcommingFIlmModel.movies;

  void setUpLocale(BuildContext context) async {
    await homePageModel.setUpLocale(context);
    notifyListeners();
  }

  void onPopularMovieRender(int index, BuildContext context) async {
    if (index == homePageModel.upcommingFIlmModel.movies.length - 1) {
      await homePageModel.upcommingFIlmModel.loadMovies(context);
      notifyListeners();
    }
  }

  void onUpcomingMovieRender(int index, BuildContext context) async {
    if (index == homePageModel.upcommingFIlmModel.movies.length - 1) {
      await homePageModel.popularFIlmModel.loadMovies(context);
      notifyListeners();
    }
  }

  void onSearchButtonTap(BuildContext context) {
    Navigator.pushNamed(context, MainNavigationRouteNames.searchPage);
  }
}
