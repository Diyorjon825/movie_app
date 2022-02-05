import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/domain/entity/movie.dart';

part 'movie_list_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieListResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<Movie> movies;
  final int totalResults;
  final int totalPages;

  MovieListResponse(
      {required this.page,
      required this.movies,
      required this.totalResults,
      required this.totalPages});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}
