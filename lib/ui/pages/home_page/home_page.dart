import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:movie_app/ui/pages/home_page/home_page_viewModel.dart';
import 'package:movie_app/ui/widgets/full_film_item_widget.dart';
import 'package:movie_app/ui/widgets/short_film_item_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    final model = context.read<HomePageViewModel>();
    if (!model.isPageCreated) {
      model.setUpLocale(context);
      model.isPageCreated = true;
    }

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
        SliverList(
          delegate: SliverChildListDelegate(
            [const _UpcommingMovies()],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 35, bottom: 15),
                child: Text(
                  'Popular Movies',
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
        const _PopularMovies()
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<HomePageViewModel>();
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'What are you looking for ?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(10, 89, 248, 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                child: const Icon(
                  Ionicons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onTap: () => model.onSearchButtonTap(context),
              ),
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
    final model = context.watch<HomePageViewModel>();
    final films = model.upcomingMovies;

    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcomming Movies',
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
                model.onUpcomingMovieRender(index, context);
                return ShortItemMovie(film: films[index]);
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

class _PopularMovies extends StatelessWidget {
  const _PopularMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HomePageViewModel>();
    final films = model.popularMovies;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        ((context, index) {
          model.onPopularMovieRender(index, context);
          return FullItemMovie(film: films[index]);
        }),
        childCount: films.length,
      ),
    );
  }
}
