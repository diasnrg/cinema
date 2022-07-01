import 'package:cinema/models.dart';
import 'package:cinema/theme.dart';
import 'package:flutter/material.dart';

class FilmDetailsView extends StatelessWidget {
  const FilmDetailsView(
    this.film, {
    Key? key,
  }) : super(key: key);

  final Film film;
  static const double padding = 16;
  static const double backgroundImageHeight = 400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CinemaTheme.backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              _backgroundImage,
              _gradient,
              _title(context),
              _header,
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: padding),
                Text('О фильме', style: CinemaTheme.detailsTextStyle),
                const SizedBox(height: padding),
                Text(film.details?.genres.join(', ') ?? '',
                    style: CinemaTheme.detailsTextStyle.copyWith(fontSize: 17)),
                const SizedBox(height: padding),
                Text(film.details?.overview ?? '',
                    style: CinemaTheme.detailsTextStyle.copyWith(fontSize: 17)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _backgroundImage {
    return SizedBox(
      height: backgroundImageHeight,
      child: film.details?.backgroundImage ?? const SizedBox.shrink(),
    );
  }

  Widget get _gradient {
    return Container(
      height: backgroundImageHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CinemaTheme.backgroundColor,
            Colors.transparent.withOpacity(0.5),
            CinemaTheme.backgroundColor,
          ],
        ),
      ),
    );
  }

  Widget get _header {
    return Positioned(
      left: padding,
      right: padding,
      bottom: padding / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: film.foregroundImage ?? const SizedBox.shrink(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Дата выхода\n${film.releaseDate}',
                  style: CinemaTheme.detailsTextStyle),
              Text(film.details?.runtime.toHours ?? '',
                  style: CinemaTheme.detailsTextStyle),
              Text('Доход:\n${film.details?.revenue} \$',
                  style: CinemaTheme.detailsTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: 50,
      left: padding,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: padding),
          SizedBox(
            width: screenWidth * 0.8,
            child: Text(
              film.title,
              style: CinemaTheme.textStyle.copyWith(fontSize: 32),
              overflow: TextOverflow.visible,
            ),
          ),
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
