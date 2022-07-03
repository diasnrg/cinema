import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';
import 'package:cinema/theme.dart';

import '../data/data.dart';
import 'view.dart';

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
    final appCubit = context.read<AppCubit>();

    return Scaffold(
      backgroundColor: CinemaTheme.backgroundColor,
      body: BlocBuilder<AppCubit, AppState>(
        builder: ((context, state) {
          if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status.isError) {
            return ErrorView(
              onTap: () => appCubit.loadFilmDetails(film),
            );
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              _backgroundImage(appCubit),
              _gradient,
              Positioned(
                top: 50,
                left: padding,
                right: padding,
                child: Column(
                  children: [
                    _title(context),
                    _header(appCubit),
                    _overview,
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _backgroundImage(AppCubit appCubit) {
    return Image(
      width: double.infinity,
      height: backgroundImageHeight,
      image: appCubit.backgroundImage(film),
      fit: BoxFit.cover,
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

  Widget _title(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
        const SizedBox(width: padding),
        Expanded(
          child: Text(
            film.title,
            style: CinemaTheme.textStyle.copyWith(fontSize: 32),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _header(AppCubit appCubit) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 160,
            clipBehavior: Clip.hardEdge,
            decoration:
                BoxDecoration(borderRadius: CinemaTheme.cardBorderRadius),
            child: Image(
              image: appCubit.foregroundImage(film)!,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'releaseDate'.i18n()}:\n${film.releaseDate}',
                  style: CinemaTheme.detailsTextStyle),
              const SizedBox(height: 12),
              Text(film.details?.runtime.toHours ?? '',
                  style: CinemaTheme.detailsTextStyle),
              if (film.details?.revenue != 0) ...[
                const SizedBox(height: 12),
                Text('${'revenue'.i18n()}:\n${film.details?.revenue} \$',
                    style: CinemaTheme.detailsTextStyle),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget get _overview {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('aboutFilm'.i18n(), style: CinemaTheme.detailsTextStyle),
        const SizedBox(height: 8),
        Text(film.details?.genres.join(', ') ?? '',
            style: CinemaTheme.detailsTextStyle
                .copyWith(fontSize: 17, color: Colors.white.withOpacity(0.6))),
        const SizedBox(height: 8),
        Text(film.details?.overview ?? '',
            style: CinemaTheme.detailsTextStyle.copyWith(fontSize: 17)),
      ],
    );
  }
}

extension RuntimeMinutesToHoursX on int {
  String get toHours {
    int hours = this ~/ 60;
    int remainder = this % 60;
    return 'runtime'.i18n([hours.toString(), remainder.toString()]);
  }
}
