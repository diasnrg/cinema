import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'dart:math' as math;

import 'package:cinema/view/film_overview_view.dart';
import 'package:cinema/models.dart';
import 'package:cinema/theme.dart';
import 'package:cinema/app_cubit.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            sliver: state.films.isEmpty
                ? _emptyState
                : _buildOverviewGrid(context, state.films),
          ),
        ],
      ),
    );
  }

  Widget get _emptyState {
    return const SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(),
      ),
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
            'films'.i18n(),
            style: CinemaTheme.textStyle.copyWith(fontSize: 32),
          ),
          // if (kDebugMode)
          //   ElevatedButton(
          //     onPressed: _setSystemLocale,
          //     child: Text('loc'),
          //   ),
          const _SortingDropdownView(),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid(BuildContext context, List<Film> films) {
    final sortingParameter = context.read<AppCubit>().state.sortingParameter;
    _sortFilms(films, sortingParameter);

    return SliverGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7,
      children: [...films.map((e) => FilmOverview(e)).toList()],
    );
  }

  void _sortFilms(
    List<Film> films,
    FilmSortingParameter sortingParameter,
  ) {
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
  }
}

class _SortingDropdownView extends StatefulWidget {
  const _SortingDropdownView({Key? key}) : super(key: key);

  @override
  State<_SortingDropdownView> createState() => _SortingDropdownViewState();
}

class _SortingDropdownViewState extends State<_SortingDropdownView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<FilmSortingParameter>(
        value: context.read<AppCubit>().state.sortingParameter,
        selectedItemBuilder: (context) => FilmSortingParameter.values
            .map((e) => Align(
                  alignment: Alignment.center,
                  child: Text(e.toString(),
                      style: CinemaTheme.detailsTextStyle
                          .copyWith(fontSize: 14, color: Colors.white)),
                ))
            .toList(),
        items: FilmSortingParameter.values
            .map((e) => DropdownMenuItem<FilmSortingParameter>(
                  value: e,
                  child: Text(e.toString(),
                      style: CinemaTheme.detailsTextStyle
                          .copyWith(fontSize: 17, color: Colors.black)),
                ))
            .toList(),
        onChanged: (value) => setState(
            () => context.read<AppCubit>().setSortingParameter(value!)),
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
    );
  }
}
