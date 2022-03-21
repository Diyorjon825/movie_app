import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/ui/main_navigation/main_navigation.dart';

class ShortItemMovie extends StatelessWidget {
  final Movie film;
  const ShortItemMovie({Key? key, required this.film}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posterPath = ApiClient.imageUrl(film.posterPath ?? '');
    return SizedBox(
      width: 120,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(posterPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                film.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    size: 20,
                    color: Colors.red,
                  ),
                  Text('${(film.voteAverage * 10).round()} %'),
                ],
              )
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.pushNamed(
                context,
                MainNavigationRouteNames.detailInfoPage,
                arguments: film.id,
              ),
            ),
          )
        ],
      ),
    );
  }
}
