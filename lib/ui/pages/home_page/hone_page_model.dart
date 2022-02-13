import 'package:flutter/material.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/sevices/network_setvise.dart';

class HomePageModel {
  String? searchWuery;
  final popularFIlmModel = PopularFilmsModel();
  final upcommingFIlmModel = UpcommingFilmasModel();
  final searchFIlmModel = SearchFilmModel();

  Future<void> setUpLocale(BuildContext context) async {
    popularFIlmModel.loadMovies(context);
    upcommingFIlmModel.loadMovies(context);
    // searchFIlmModel.loadMovies(context, null);
  }
}

class PopularFilmsModel {
  final networkService =
      NetworkService(requestType: NetWorkRequestType.popularMovies);
  Future<void> loadMovies(BuildContext context) async {
    await networkService.setupLocale(context);
  }

  List<Movie> get movies => networkService.movies;
}

class UpcommingFilmasModel {
  final networkService =
      NetworkService(requestType: NetWorkRequestType.upcommingMovies);
  void loadMovies(BuildContext context) {
    networkService.setupLocale(context);
  }

  List<Movie> get movies => networkService.movies;
}

class SearchFilmModel {
  SearchFilmModel();
  final networkService = NetworkService(requestType: NetWorkRequestType.search);
  void loadMovies(BuildContext context, String? searchQury) {
    networkService.setupLocale(context, searchQury);
  }

  List<Movie> get movies => networkService.movies;
}
