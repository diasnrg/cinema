import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState()) {
    _init();
  }

  Future<void> _init() async {
    final systemLanguage =
        Platform.localeName == 'ru_RU' ? Language.ru : Language.en;
    setSystemLanguage(systemLanguage);
    return loadFilms();
  }

  Future<void> reload() => _init();

  void setSystemLanguage(Language language) {
    emit(state.copyWith(language: language));
  }

  void setSortingParameter(FilmSortingParameter sortingParameter) {
    final films = List<Film>.from(state.films);
    _sortFilmsByParameter(films, sortingParameter);
    emit(state.copyWith(
      sortingParameter: sortingParameter,
      films: films,
    ));
  }

  Future<void> loadFilms() async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final films = await Network.getFilmList(language: state.language);
      _sortFilmsByParameter(films, state.sortingParameter);
      _loadForegroundImages(films);

      emit(state.copyWith(
        films: films,
        status: AppStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  void _sortFilmsByParameter(
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

  Future<void> loadFilmDetails(Film film) async {
    if (film.details != null) {
      return;
    }

    emit(state.copyWith(status: AppStatus.loading));

    try {
      film.details =
          await Network.getFilmDetails(film, language: state.language);
      _loadBackgroundImage(film);

      emit(state.copyWith(status: AppStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  void _loadForegroundImages(List<Film> films) {
    final Map<String, ImageProvider> images =
        Map.fromEntries(state.images.entries);
    for (var f in films) {
      String key = '${f.id}_foreground';
      if (images.containsKey(key)) {
        continue;
      }
      images[key] = Image.network(
        Network.posterImageUrl(f),
      ).image;
    }

    emit(state.copyWith(images: images));
  }

  void _loadBackgroundImage(Film film) {
    final Map<String, ImageProvider> images =
        Map.fromEntries(state.images.entries);

    String key = '${film.id}_background';
    images[key] = Image.network(
      Network.posterImageUrl(film),
    ).image;

    emit(state.copyWith(images: images));
  }

  ImageProvider? foregroundImage(Film film) {
    return state.images['${film.id}_foreground'];
  }

  ImageProvider backgroundImage(Film film) {
    String key = '${film.id}_background';
    if (!state.images.containsKey(key)) {
      _loadBackgroundImage(film);
    }
    return state.images['${film.id}_background']!;
  }
}

class AppState {
  AppState({
    this.language = Language.en,
    this.sortingParameter = FilmSortingParameter.voteAverage,
    this.films = const <Film>[],
    this.images = const <String, ImageProvider>{},
    this.status = AppStatus.initial,
  });

  final Language language;
  final FilmSortingParameter sortingParameter;
  final List<Film> films;
  final Map<String, ImageProvider> images;
  final AppStatus status;

  AppState copyWith({
    Language? language,
    FilmSortingParameter? sortingParameter,
    List<Film>? films,
    Map<int, FilmDetails>? filmDetails,
    Map<String, ImageProvider>? images,
    AppStatus? status,
  }) {
    return AppState(
      language: language ?? this.language,
      sortingParameter: sortingParameter ?? this.sortingParameter,
      films: films ?? this.films,
      images: images ?? this.images,
      status: status ?? this.status,
    );
  }
}

enum AppStatus {
  initial,
  loading,
  success,
  error,
}

extension AppStatusX on AppStatus {
  bool get isLoading => this == AppStatus.loading;
  bool get isError => this == AppStatus.error;
}
