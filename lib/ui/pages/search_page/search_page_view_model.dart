import 'package:flutter/material.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/sevices/network_setvise.dart';
import 'dart:async';

class SearchPageViewmodel extends ChangeNotifier {
  String? _serchText;
  final networkService = NetworkService(requestType: NetWorkRequestType.search);
  Timer? _searchDebobce;

  Future<void> setSearchText(String text, BuildContext context) async {
    _searchDebobce?.cancel();
    _searchDebobce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_serchText == searchQuery) return;
      _serchText = searchQuery;
      await networkService.resetMovieList(context, _serchText);
      notifyListeners();
    });
  }

  Future<void> loadMovies(BuildContext context, String? searchQury) async {
    await networkService.setupLocale(context, searchQury);
  }

  List<Movie> get movies => networkService.movies;
}
