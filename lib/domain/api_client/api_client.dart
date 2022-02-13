import 'dart:convert';
import 'dart:io';

import 'package:movie_app/domain/entity/credits.dart';
import 'package:movie_app/domain/entity/movie_details.dart';
import 'package:movie_app/domain/entity/movie_list_response.dart';

enum ApiExaptions { Auth, Network, Other }

class ApiExaption implements Exception {
  ApiExaptions type;
  ApiExaption(this.type);
}

class ApiClient {
  final _host = 'https://api.themoviedb.org/3';
  final _apiKey = "d7892bcdf6a3abafefb3e9098226c98f";
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  final _client = HttpClient();
  static imageUrl(String? path) {
    if (path != null) {
      return _imageUrl + path;
    }
    return 'image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png';
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parametrs]) {
    final uri = Uri.parse("$_host$path");
    if (parametrs != null) return uri.replace(queryParameters: parametrs);
    return uri;
  }

  Future<String> login(String username, String password) async {
    final token = await _makeToken();
    final sessionToken = await _loginWithName(
      token: token,
      username: username,
      password: password,
    );
    return _makeSession(token: sessionToken);
  }

  Future<T> _get<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? parametrs]) async {
    final url = _makeUri(path, parametrs);
    try {
      HttpClientRequest request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _checkLoginError(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiExaption(ApiExaptions.Network);
    } on ApiExaption {
      rethrow;
    } catch (_) {
      throw ApiExaption(ApiExaptions.Other);
    }
  }

  Future<T> _post<T>(String path, T Function(dynamic json) parser,
      [Map<String, dynamic>? urlParametrs,
      Map<String, dynamic>? bodyParametrs]) async {
    final url = _makeUri(path, urlParametrs);
    try {
      HttpClientRequest request = await _client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParametrs));
      final response = await request.close();
      final json = (await response.jsonDecode());
      _checkLoginError(response, json);
      final result = parser(json);
      return result;
    } on SocketException {
      throw ApiExaption(ApiExaptions.Network);
    } on ApiExaption {
      rethrow;
    } catch (_) {
      throw ApiExaption(ApiExaptions.Other);
    }
  }

  void _checkLoginError(HttpClientResponse response, json) {
    if (response.statusCode == 401) {
      final statusCode = json['status_code'] ?? 0;
      if (statusCode == 30) {
        throw ApiExaption(ApiExaptions.Auth);
      } else {
        throw ApiExaption(ApiExaptions.Other);
      }
    }
  }

  Future<String> _makeToken() async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final result =
        _get('/authentication/token/new', parser, {'api_key': _apiKey});
    return result;
  }

  Future<MovieListResponse> popularFilms(int page, String local) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = MovieListResponse.fromJson(jsonMap);
      return result;
    }

    final parametrs = {
      'api_key': _apiKey,
      'language': local,
      'page': page.toString(),
    };

    final result = _get('/movie/popular', parser, parametrs);
    return result;
  }

  Future<MovieListResponse> upcomingFilms(int page, String local) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = MovieListResponse.fromJson(jsonMap);
      return result;
    }

    final parametrs = {
      'api_key': _apiKey,
      'language': local,
      'page': page.toString(),
    };

    final result = _get('/movie/upcoming', parser, parametrs);
    return result;
  }

  Future<MovieListResponse> searchMovie(
    int page,
    String local,
    String query,
  ) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = MovieListResponse.fromJson(jsonMap);
      return result;
    }

    final parametrs = {
      'api_key': _apiKey,
      'language': local,
      'page': page.toString(),
      'query': query,
      'include_adult': true.toString(),
    };

    final result = _get('/search/movie', parser, parametrs);
    return result;
  }

  Future<MovieDetail> movieDetails(
    String local,
    int id,
  ) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = MovieDetail.fromJson(jsonMap);
      return result;
    }

    final parametrs = {
      'api_key': _apiKey,
      'language': local,
    };

    final result = _get('/movie/$id', parser, parametrs);
    return result;
  }

  Future<Credits> movieCredits(
    String local,
    int id,
  ) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = Credits.fromJson(jsonMap);
      return result;
    }

    final parametrs = {
      'api_key': _apiKey,
      'language': local,
    };

    final result = _get('/movie/$id/credits', parser, parametrs);
    return result;
  }

  Future<String> _loginWithName(
      {required String token,
      required String username,
      required String password}) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['request_token'] as String;
      return token;
    }

    final urlParametrs = {'api_key': _apiKey};
    final bodyParametrs = {
      "username": username,
      "password": password,
      "request_token": token
    };

    final result = _post('/authentication/token/validate_with_login', parser,
        urlParametrs, bodyParametrs);
    return result;
  }

  Future<String> _makeSession({required String token}) async {
    parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final token = jsonMap['session_id'] as String;
      return token;
    }

    final urlParametrs = {'api_key': _apiKey};
    final bodyParametrs = {"request_token": token};
    final result = _post(
        '/authentication/session/new', parser, urlParametrs, bodyParametrs);
    return result;
  }
}

extension HttpClientResponseJsonDecoder on HttpClientResponse {
  Future<dynamic> jsonDecode() {
    return transform(utf8.decoder)
        .toList()
        .then((value) => value.join())
        .then<dynamic>((value) => json.decode(value));
  }
}
