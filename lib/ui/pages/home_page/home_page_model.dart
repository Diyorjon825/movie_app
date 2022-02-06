import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/entity/movie_list_response.dart';
import 'package:movie_app/ui/main_navigation/main_navigation.dart';

enum _TypeLoad { Search, Popular, Upcoming }

class HomePageModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _popularMovies = <Movie>[];
  final _upcomingMovies = <Movie>[];
  bool _isPopularLoadingProgress = false;
  bool _isUpcomingLoadingProgress = false;
  late DateFormat _dateFormat;
  late int _popularCurrentPage;
  late int _upconingCurrentPage;
  String _locale = '';
  late int _totalPopularPage;
  late int _totalUpcomingPage;
  String? _searchQuery;
  Timer? _searchDebobce;
  List<Movie> get popularMovies => List.unmodifiable(_popularMovies);
  List<Movie> get upcomingMovies => List.unmodifiable(_upcomingMovies);

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setUpLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMd(locale);
    await _resetMovieList();
  }

  Future<void> _resetMovieList() async {
    _popularMovies.clear();
    _upcomingMovies.clear();
    _popularCurrentPage = 0;
    _upconingCurrentPage = 0;
    _totalPopularPage = 1;
    _totalUpcomingPage = 1;
    await _loadNextListMovies(_TypeLoad.Popular);
    await _loadNextListMovies(_TypeLoad.Upcoming);
  }

  Future<MovieListResponse> _loadMovies(int nextPage, _TypeLoad type) async {
    final query = _searchQuery;
    if (query == null) {
      if (type == _TypeLoad.Popular) {
        return _apiClient.popularFilms(nextPage, _locale);
      }
      return _apiClient.upcomingFilms(nextPage, _locale);
    }
    return _apiClient.searchMovie(nextPage, _locale, query);
  }

  Future<void> _loadNextListMovies(_TypeLoad type) async {
    if (type == _TypeLoad.Popular) {
      if (_popularCurrentPage >= _totalPopularPage ||
          _isPopularLoadingProgress) {
        return;
      }
      _isPopularLoadingProgress = true;
      try {
        final nextPage = _popularCurrentPage + 1;
        final moviesResponse = await _loadMovies(nextPage, type);
        _popularCurrentPage = moviesResponse.page;
        _totalPopularPage = moviesResponse.totalPages;
        _popularMovies.addAll(moviesResponse.movies);
        _isPopularLoadingProgress = false;
        notifyListeners();
      } catch (e) {}
      return;
    }
    if (_popularCurrentPage >= _totalPopularPage || _isPopularLoadingProgress) {
      return;
    }
    _isUpcomingLoadingProgress = true;
    try {
      final nextPage = _upconingCurrentPage + 1;
      final moviesResponse = await _loadMovies(nextPage, type);
      _upconingCurrentPage = moviesResponse.page;
      _totalUpcomingPage = moviesResponse.totalPages;
      _upcomingMovies.addAll(moviesResponse.movies);
      _isUpcomingLoadingProgress = false;
      notifyListeners();
    } catch (e) {}
  }

  void onMovieTap(BuildContext context, int id) {
    Navigator.pushNamed(
      context,
      MainNavigationRouteNames.detailInfoPage,
      arguments: id,
    );
  }

  String imageUrl(int index) {
    final path = popularMovies[index].posterPath;
    final url = path ?? '/wwemzKWzjKYJFfCeiB57q3r4Bcm.png';
    return ApiClient.imageUrl(url);
  }

  void onPopularMovieRender(int index) async {
    if (index < _popularMovies.length - 1) return;
    await _loadNextListMovies(_TypeLoad.Popular);
  }

  void onUpcomingMovieRender(int index) async {
    if (index < _upcomingMovies.length - 1) return;
    await _loadNextListMovies(_TypeLoad.Upcoming);
  }

  Future<void> searchMovie(String text) async {
    _searchDebobce?.cancel();
    _searchDebobce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetMovieList();
    });
  }
}
