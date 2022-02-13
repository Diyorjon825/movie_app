import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/ui/pages/home_page/home_page_viewModel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    final model = context.watch<HomePageViewModel>();
    model.setUpLocale(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomePageViewModel>();
    if (model.popularMovies.isEmpty || model.upcomingMovies.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SearchWidget(),
            Expanded(child: _MoviesList()),
          ],
        ),
      ),
    );
  }
}

class _MoviesList extends StatelessWidget {
  const _MoviesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: <Widget>[
        SliverList(delegate: SliverChildListDelegate([const _PopularMovies()])),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 35, bottom: 15),
                child: Text(
                  'Upcomming Movies',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const _UpcommingMovies()
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomePageViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40, left: 20),
          child: Text(
            'What are you looking for ?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: TextField(
                    onChanged: (text) => model.searchText = text,
                    decoration: const InputDecoration(
                      hintText: 'Search for movies, events & more...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(10, 89, 248, 1),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Ionicons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _PopularMovies extends StatelessWidget {
  const _PopularMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final films =
        context.select((HomePageViewModel value) => value.popularMovies);

    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Movies',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 214,
            child: ListView.separated(
              itemCount: films.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final model = context.read<HomePageViewModel>();
                model.onPopularMovieRender(index, context);
                return _ShortItemMovie(index: index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 14);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ShortItemMovie extends StatelessWidget {
  final int index;
  const _ShortItemMovie({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomePageViewModel>();
    final film = model.popularMovies[index];
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
              onTap: () => model.onMovieTap(context, film.id),
            ),
          )
        ],
      ),
    );
  }
}

class _UpcommingMovies extends StatelessWidget {
  const _UpcommingMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final films =
        context.select((HomePageViewModel value) => value.upcomingMovies);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        ((context, index) {
          final model = context.read<HomePageViewModel>();
          model.onUpcomingMovieRender(index, context);
          return _FullItemMovie(
            index: index,
          );
        }),
        childCount: films.length,
      ),
    );
  }
}

class _FullItemMovie extends StatelessWidget {
  final int index;
  const _FullItemMovie({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomePageViewModel>();
    final film = model.upcomingMovies[index];
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
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
