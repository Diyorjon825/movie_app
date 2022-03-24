import 'package:flutter/material.dart';
import 'package:movie_app/ui/pages/detail_info_page/detail_info_page.dart';
import 'package:movie_app/ui/pages/detail_info_page/detail_info_page_model.dart';
import 'package:movie_app/ui/pages/home_page/home_page.dart';
import 'package:movie_app/ui/pages/home_page/home_page_viewModel.dart';
import 'package:movie_app/ui/pages/search_page/search_page.dart';
import 'package:movie_app/ui/pages/search_page/search_page_view_model.dart';
import 'package:provider/provider.dart';

class PageFactory {
  Widget buildSearchPage() {
    return ChangeNotifierProvider(
      create: (context) => SearchPageViewmodel(),
      child: const SearchPage(),
    );
  }

  Widget buildHomePage() {
    return ChangeNotifierProvider(
      create: (context) => HomePageViewModel(),
      child: const HomePage(),
    );
  }

  Widget buildDetailPage(int id) {
    return ChangeNotifierProvider(
      create: (context) => DetailInfoPageModel(id: id),
      child: const DetailInfoPage(),
    );
  }

  // Widget buildPopularWidget(){

  // }
}
