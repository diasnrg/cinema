import 'package:cinema/models.dart';
import 'package:flutter/material.dart';

class FilmDetailsView extends StatelessWidget {
  const FilmDetailsView(
    this.film, {
    Key? key,
  }) : super(key: key);

  final Film film;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(21, 20, 31, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _backgroundImage,
              _gradient,
              _foregroundImage,
              _backNavigation(context),
              _headerInfo,
            ],
          ),
          const SizedBox(height: 16),
          const Text('О фильме'),
          const SizedBox(height: 16),
          Text(film.details?.genres.toString() ?? ''),
          const SizedBox(height: 16),
          Text(film.details?.overview ?? ''),
        ],
      ),
    );
  }

  Widget get _backgroundImage {
    return SizedBox(
      height: 300,
      child: film.details?.backgroundImage ?? const SizedBox.shrink(),
    );
  }

  Widget get _gradient {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color.fromRGBO(21, 20, 31, 1),
          ],
        ),
      ),
    );
  }

  Widget get _foregroundImage {
    return Positioned(
      left: 20,
      top: 100,
      child: Container(
        width: 130,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: film.foregroundImage ?? const SizedBox.shrink(),
      ),
    );
  }

  Widget _backNavigation(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios_rounded),
      ),
    );
  }

  Widget get _headerInfo {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Дата выхода\n${film.releaseDate}'),
          Text(film.details?.runtime.toHours ?? ''),
          Text('Доход:\n${film.details?.revenue} \$'),
        ],
      ),
    );
  }
}

extension MinutesToHoursX on int {
  String get toHours {
    int hours = this ~/ 60;
    int remainder = this % 60;
    return '$hours часа $remainder минут';
  }
}
