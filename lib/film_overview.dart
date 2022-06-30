import 'package:cinema/models.dart';
import 'package:flutter/material.dart';

class FilmOverview extends StatelessWidget {
  FilmOverview(
    this.film, {
    Key? key,
  })  : imageUrl = 'https://image.tmdb.org/t/p/w500/${film.posterPath}',
        super(key: key);
  final Film film;

  final String imageUrl;
  final textStyle = const TextStyle(
    color: Colors.white,
    // fontFamily: 'Rubik',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          Container(
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
          ),
          Positioned(
            left: 12,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(film.title, style: textStyle),
                Text(film.releaseDate, style: textStyle)
              ],
            ),
          ),
          Positioned(
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
          ),
        ],
      ),
    );
  }
}
