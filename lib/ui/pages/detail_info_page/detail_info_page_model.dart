import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/credits.dart';
import 'package:movie_app/domain/entity/movie_details.dart';

class DetailInfoPageModel extends ChangeNotifier {
  final int id;
  DetailInfoPageModel({required this.id});

  Credits? _credits;
  Credits? get credits => _credits;
  MovieDetail? _movieDetail;
  MovieDetail? get movieDetail => _movieDetail;

  final _apiClient = ApiClient();
  String _locale = '';
  late DateFormat _dateFormat;

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat('yMd');
    await loadDetails();
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> loadDetails() async {
    final detail = await _apiClient.movieDetails(_locale, id);
    _movieDetail = detail;
    notifyListeners();
    loadCredits();
  }

  Future<void> loadCredits() async {
    final credits = await _apiClient.movieCredits(_locale, id);
    _credits = credits;
    notifyListeners();
  }
}
