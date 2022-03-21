import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:movie_app/ui/pages/search_page/search_page_view_model.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
    );
  }
}

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
        ],
      ),
    );
  }
}
