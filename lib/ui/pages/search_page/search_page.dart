import 'package:flutter/material.dart';
import 'package:movie_app/ui/pages/search_page/search_page_view_model.dart';
import 'package:movie_app/ui/widgets/full_film_item_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 67, 54, 1),
        title: const Text(
          "What are you looking for ?",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: const [
          _SearchFieldWidget(),
          Expanded(child: _FindMoviesList()),
        ],
      ),
    );
  }
}

// const Color.fromRGBO(244, 67, 54, 1)
class _SearchFieldWidget extends StatelessWidget {
  const _SearchFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<SearchPageViewmodel>();
    return Padding(
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
                onChanged: (text) => model.setSearchText(text, context),
                decoration: const InputDecoration(
                  hintText: 'Search for movies, events & more...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _FindMoviesList extends StatelessWidget {
  const _FindMoviesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchPageViewmodel>();
    if (viewModel.movies.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final film = viewModel.movies[index];
        return FullItemMovie(film: film);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: viewModel.movies.length,
    );
  }
}
