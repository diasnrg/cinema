import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cinema/film_overview.dart';
import 'package:cinema/models.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const Scaffold(
        backgroundColor: Color.fromRGBO(21, 20, 31, 1),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String filmsUri =
      'https://api.themoviedb.org/3/movie/popular?api_key=2f05ecb893a6f356e596873f1972d65b&language=en';
  Future<List<Film>>? films;

  @override
  void initState() {
    super.initState();
    films = _getFilms();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: Header()),
        FutureBuilder<List<Film>>(
          future: films,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final films = snapshot.data!;
              return _grid(films);
            }

            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          }),
        ),
      ],
    );
  }

  Widget _grid(List<Film> films) {
    return SliverGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      // padding: const EdgeInsets.all(12),
      childAspectRatio: 0.7,
      children: [...films.map((e) => FilmOverview(e)).toList()],
    );
  }

  Future<List<Film>> _getFilms() async {
    final response = await http.get(Uri.parse(filmsUri));

    if (response.statusCode != 200) {
      throw Exception('failed to load cinema list');
    }

    final json = (jsonDecode(response.body) as Map<String, dynamic>)['results']
        as List<dynamic>;
    final films = json.map((e) => Film.fromJson(e)).toList();
    return films;
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Фильмы',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 32),
          ),
          // TODO: filter...
        ],
      ),
    );
  }
}
