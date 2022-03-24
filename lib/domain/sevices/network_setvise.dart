import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/entity/movie_list_response.dart';

enum NetWorkRequestType { search, popularMovies, upcommingMovies }

class NetworkService {
  NetWorkRequestType requestType;
  var pageCounter = 1;
  var totalPageCounter = 1;
  bool _isLoadingProgress = false;
  final _apiClient = ApiClient();
  String? _searchQury;

  List<Movie> movies = <Movie>[];

  NetworkService({required this.requestType});

  Future<void> setupLocale(BuildContext context, [String? searchQuery]) async {
    if (_searchQury != searchQuery) {
      movies.clear();
    }
    _searchQury = searchQuery;

    final locale = Localizations.localeOf(context).toLanguageTag();
    await _loadNextPage(locale);
  }

  Future<void> resetMovieList(BuildContext context, String? searchQuery) async {
    movies.clear();
    pageCounter = 1;
    totalPageCounter = 1;
    await setupLocale(context, searchQuery);
  }

  Future<void> _loadNextPage(String locale) async {
    if (!_isLoadingProgress && pageCounter <= totalPageCounter) {
      _isLoadingProgress = true;
      final responce = await _loadMvovies(pageCounter, locale);
      movies.addAll(responce.movies);
      pageCounter = responce.page + 1;
      totalPageCounter = responce.totalPages;
      _isLoadingProgress = false;
    }
  }

  Future<MovieListResponse> _loadMvovies(int page, String local) async {
    if (requestType == NetWorkRequestType.popularMovies) {
      return _apiClient.popularFilms(page, local);
    }
    if (requestType == NetWorkRequestType.upcommingMovies) {
      return _apiClient.upcomingFilms(page, local);
    } else {
      final query = _searchQury;
      if (query != null) {
        return _apiClient.searchMovie(page, local, query);
      }
      return _apiClient.popularFilms(page, local);
    }
  }
}
