import 'package:flutter_bloc/flutter_bloc.dart';

import 'models.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  void setLanguage(Language language) => emit(AppState(language: language));
  void setSortingParameter(FilmSortingParameter sortingParameter) =>
      emit(AppState(sortingParameter: sortingParameter));
  void setFilms(List<Film> films) => emit(AppState(films: films));
}

class AppState {
  AppState({
    this.language = Language.en,
    this.sortingParameter = FilmSortingParameter.voteAverage,
    this.films = const <Film>[],
  });

  final Language language;
  final FilmSortingParameter sortingParameter;
  final List<Film> films;
}
