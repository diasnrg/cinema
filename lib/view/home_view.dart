import 'package:flutter/material.dart';

import 'package:cinema/view/film_overview_view.dart';
import 'package:cinema/models.dart';
import 'package:cinema/network.dart';
import 'package:cinema/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Film>>? films;

  @override
  void initState() {
    super.initState();
    films = Network.getFilmList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _Header()),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: FutureBuilder<List<Film>>(
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
      childAspectRatio: 0.77,
      children: [...films.map((e) => FilmOverview(e)).toList()],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Фильмы',
            style: CinemaTheme.textStyle.copyWith(fontSize: 32),
          ),
          // TODO: filter...
        ],
      ),
    );
  }
}
