import 'package:flutter/material.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/sevices/network_setvise.dart';

class HomePageModel {
  String? searchWuery;
  final popularFIlmModel = PopularFilmsModel();
  final upcommingFIlmModel = UpcommingFilmasModel();

  Future<void> setUpLocale(BuildContext context) async {
    await popularFIlmModel.loadMovies(context);
    await upcommingFIlmModel.loadMovies(context);
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
  Future<void> loadMovies(BuildContext context) async {
    await networkService.setupLocale(context);
  }

  List<Movie> get movies => networkService.movies;
}
