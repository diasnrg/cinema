import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'dart:math' as math;

import 'package:cinema/theme.dart';

import 'view.dart';
import '../data/data.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AppCubit>().reload(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status.isError) {
            return ErrorView(onTap: () => context.read<AppCubit>().loadFilms());
          }
          if (state.films.isEmpty) {
            return Center(
                child: Text('List is empty', style: CinemaTheme.textStyle));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                sliver: _buildFilmCardGrid(state.films),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilmCardGrid(List<Film> films) {
    return SliverGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.7,
      children: [...films.map((e) => FilmCardView(e)).toList()],
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
          const _SortingDropdownView(),
        ],
      ),
    );
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
