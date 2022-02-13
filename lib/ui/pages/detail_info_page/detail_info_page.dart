import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/ui/pages/detail_info_page/detail_info_page_model.dart';
import 'package:movie_app/ui/pages/paint_indicator/paint_indecator.dart';
import 'package:provider/provider.dart';

class DetailInfoPage extends StatefulWidget {
  const DetailInfoPage({Key? key}) : super(key: key);

  @override
  State<DetailInfoPage> createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = context.read<DetailInfoPageModel>();
    model.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DetailInfoPageModel>();
    if (model.movieDetail == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return const Scaffold(
      body: HeadImageWidget(),
    );
  }
}

class HeadImageWidget extends StatelessWidget {
  const HeadImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<DetailInfoPageModel>();
    final imagePath = ApiClient.imageUrl(model.movieDetail?.backdropPath);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
          pinned: true,
          title: Text(model.movieDetail?.title ?? ''),
          expandedHeight: 216,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            centerTitle: true,
            background: ColoredBox(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            const [
              MainInfoWidget(),
              UserScoreWidget(),
              MovieDiscriptionWidget(),
              CastsWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

class MainInfoWidget extends StatelessWidget {
  const MainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<DetailInfoPageModel>();
    final iso = model.movieDetail?.productionCountries.first.iso;
    final releaseDate = model.stringFromDate(model.movieDetail?.releaseDate);
    final runtime = model.movieDetail?.runtime ?? 0;
    final hours = runtime ~/ 60;
    final minuts = runtime - (hours * 60);
    List<String?> genres = [];
    if (model.movieDetail?.genres != null) {
      if (model.movieDetail!.genres.length > 1) {
        if (model.movieDetail?.genres[0].name != null) {
          genres.add(model.movieDetail?.genres[0].name);
        }
        if (model.movieDetail?.genres[1].name != null) {
          genres.add(model.movieDetail?.genres[1].name);
        }
      }
    }
    String genre = genres.join(' ');

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 26, right: 20),
      child: SizedBox(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            model.movieDetail?.title ?? '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$iso | $releaseDate',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$hours hr $minuts min | $genre',
                    style: const TextStyle(fontSize: 13, color: Colors.blue),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 10),
                    Text('${model.movieDetail?.voteCount} votes'),
                  ],
                ),
                Text(
                  '${model.movieDetail?.originalLanguage.toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserScoreWidget extends StatelessWidget {
  const UserScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<DetailInfoPageModel>();
    final score = (model.movieDetail?.voteAverage ?? 0) * 10;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 28),
      child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: PaintIndecator(
                        percent: score,
                        widthLine: 4.3,
                      ),
                    ),
                    const Text(
                      'User Score',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.grey,
                width: 2,
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Play Trailer',
                      style: TextStyle(color: Colors.red, fontSize: 17.6),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class MovieDiscriptionWidget extends StatelessWidget {
  const MovieDiscriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<DetailInfoPageModel>();
    final owerview =
        context.read<DetailInfoPageModel>().movieDetail?.overview ?? '';
    return Padding(
      padding: const EdgeInsets.only(top: 28, left: 20, right: 20),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Movie description',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 9),
            Text(
              owerview,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CastsWidget extends StatelessWidget {
  const CastsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credits = context.watch<DetailInfoPageModel>().credits;
    if (credits == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Casts'),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: ListView.separated(
              itemCount: credits.cast.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) => _SingleActiorWidget(
                    index: index,
                  )),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _SingleActiorWidget extends StatelessWidget {
  final int index;
  const _SingleActiorWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actor = context.read<DetailInfoPageModel>().credits?.cast[index];
    final imagePath = ApiClient.imageUrl(actor?.profilePath);
    return Container(
      width: 117,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 177 / 268,
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '${actor?.name} ${actor?.character} /',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
