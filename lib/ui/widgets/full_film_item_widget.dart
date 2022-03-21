import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/ui/main_navigation/main_navigation.dart';

class FullItemMovie extends StatelessWidget {
  final Movie film;
  const FullItemMovie({Key? key, required this.film}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final posterPath = ApiClient.imageUrl(film.posterPath ?? '');
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 120,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(posterPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        film.title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Text(
                          film.overview,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
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
      ),
    );
  }
}
