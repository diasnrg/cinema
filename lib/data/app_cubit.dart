import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data.dart';


class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState()) {
    _init();
  }

  void _init() {
    final systemLanguage =
        Platform.localeName == 'ru_RU' ? Language.ru : Language.en;
    setSystemLanguage(systemLanguage);
    loadFilms();
  }

  void setSystemLanguage(Language language) {
    emit(state.copyWith(language: language));
  }

  Future<void> loadFilms() async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      final films = await Network.getFilmList(language: state.language);
      emit(state.copyWith(
        films: films,
        status: AppStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
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
  // cached images
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

extension AppStatusX on AppStatus {
  bool get isLoading => this == AppStatus.loading;
  bool get isError => this == AppStatus.error;
}
