import 'dart:io';

import 'package:cinema/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState()) {
    final systemLanguage =
        Platform.localeName == 'ru_RU' ? Language.ru : Language.en;
    setLanguage(systemLanguage);
  }

  void setLanguage(Language language) {
    emit(state.copyWith(language: language));
    loadFilms();
  }

  void loadFilms() {
    emit(state.copyWith(status: AppStatus.loading));

    Network.getFilmList(language: state.language).then(
      (films) => emit(state.copyWith(
        films: films,
        status: AppStatus.success,
      )),
    );
  }

  void setSortingParameter(FilmSortingParameter sortingParameter) {
    emit(state.copyWith(sortingParameter: sortingParameter));
  }
}

class AppState {
  AppState({
    this.language = Language.en,
    this.sortingParameter = FilmSortingParameter.voteAverage,
    this.films = const <Film>[],
    this.status = AppStatus.initial,
  });

  final Language language;
  final FilmSortingParameter sortingParameter;
  final List<Film> films;
  final AppStatus status;

  AppState copyWith({
    Language? language,
    FilmSortingParameter? sortingParameter,
    List<Film>? films,
    AppStatus? status,
  }) {
    return AppState(
      language: language ?? this.language,
      sortingParameter: sortingParameter ?? this.sortingParameter,
      films: films ?? this.films,
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
