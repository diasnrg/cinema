import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/theme.dart';

import 'view.dart';
import '../data/data.dart';

class FilmOverview extends StatelessWidget {
  const FilmOverview(
    this.film, {
    Key? key,
  }) : super(key: key);

  final Film film;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final language = context.read<AppCubit>().state.language;
        film.loadFilmDetails(language: language).then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => FilmDetailsView(film))),
          );
        });
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: CinemaTheme.cardBorderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            film.foregroundImage ?? const CircularProgressIndicator(),
            _gradient,
            _titleAndReleaseDate,
            _votes,
          ],
        ),
      ),
    );
  }

  Widget get _gradient {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            CinemaTheme.backgroundColor,
          ],
        ),
      ),
    );
  }

  Widget get _titleAndReleaseDate {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(film.title, style: CinemaTheme.textStyle),
          const SizedBox(height: 4),
          Text(
            film.releaseDate,
            style: CinemaTheme.textStyle.copyWith(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          )
        ],
      ),
    );
  }

  Widget get _votes {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: Text(
          '${film.voteAverage}',
          style: CinemaTheme.textStyle.copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
