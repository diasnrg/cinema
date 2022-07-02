import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  FilmSortingParameter? sortingParameter;

  @override
  void initState() {
    super.initState();
    films = Network.getFilmList();
    sortingParameter = FilmSortingParameter.values[0];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _header),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          sliver: FutureBuilder<List<Film>>(
            future: films,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final films = snapshot.data!;
                return _buildOverviewGrid(films);
              }

              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget get _header {
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Фильмы',
            style: CinemaTheme.textStyle.copyWith(fontSize: 32),
          ),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<FilmSortingParameter>(
              value: sortingParameter,
              selectedItemBuilder: (context) => FilmSortingParameter.values
                  .map(
                    (e) => Align(
                      alignment: Alignment.center,
                      child: Text(e.toString(),
                          style: CinemaTheme.detailsTextStyle
                              .copyWith(fontSize: 14, color: Colors.white)),
                    ),
                  )
                  .toList(),
              items: FilmSortingParameter.values
                  .map(
                    (e) => DropdownMenuItem<FilmSortingParameter>(
                      value: e,
                      child: Text(e.toString(),
                          style: CinemaTheme.detailsTextStyle
                              .copyWith(fontSize: 17, color: Colors.black)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => sortingParameter = value!);
              },
              icon: Transform.rotate(
                angle: math.pi / 2,
                child: const Icon(
                  Icons.compare_arrows,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              underline: const SizedBox.shrink(),
              dropdownColor: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid(List<Film> films) {
    switch (sortingParameter) {
      case FilmSortingParameter.title:
        films.sort((f1, f2) => f1.title.compareTo(f2.title));
        break;
      case FilmSortingParameter.releaseDate:
        films.sort((f1, f2) => f2.releaseDate.compareTo(f1.releaseDate));
        break;
      default:
        films.sort((f1, f2) => f2.voteAverage.compareTo(f1.voteAverage));
    }

    return SliverGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7,
      children: [...films.map((e) => FilmOverview(e)).toList()],
    );
  }
}

int compareByTitle(Film f1, f2) {
  return f1.title.compareTo(f2.title);
}
