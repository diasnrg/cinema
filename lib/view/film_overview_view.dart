import 'package:cinema/view/film_details_view.dart';
import 'package:flutter/material.dart';
import 'package:cinema/models.dart';

class FilmOverview extends StatelessWidget {
  const FilmOverview(
    this.film, {
    Key? key,
  }) : super(key: key);

  final Film film;

  final textStyle = const TextStyle(
    color: Colors.white,
    // fontFamily: 'Rubik',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        film.loadFilmDetails().then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => FilmDetailsView(film))),
          );
        });
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          // border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            film.foregroundImage ?? const SizedBox.shrink(),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            Colors.black,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget get _titleAndReleaseDate {
    return Positioned(
      left: 12,
      bottom: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(film.title, style: textStyle),
          Text(film.releaseDate, style: textStyle)
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
          style: textStyle.copyWith(fontSize: 12),
        ),
      ),
    );
  }
}
