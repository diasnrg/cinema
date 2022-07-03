import 'package:localization/localization.dart';

class Film {
  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    required this.posterPath,
    this.details,
  });

  final int id;
  final String title;
  final String releaseDate;
  final double voteAverage;
  final String posterPath;
  FilmDetails? details;

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'].toDouble(),
      posterPath: json['poster_path'],
    );
  }
}

class FilmDetails {
  FilmDetails({
    required this.id,
    required this.isForAdults,
    required this.revenue,
    required this.runtime,
    required this.genres,
    required this.overview,
    required this.backdropPath,
  });

  final int id;
  final bool isForAdults;
  final int revenue;
  final int runtime;
  final List<String> genres;
  final String overview;
  final String backdropPath;

  factory FilmDetails.fromJson(Map<String, dynamic> json) {
    return FilmDetails(
      id: json['id'],
      isForAdults: json['adult'],
      revenue: json['revenue'],
      runtime: json['runtime'],
      genres: (json['genres'] as List<dynamic>)
          .toList()
          .map((e) => e['name'] as String)
          .toList(),
      overview: json['overview'],
      backdropPath: json['backdrop_path'],
    );
  }
}

enum FilmSortingParameter {
  title,
  releaseDate,
  voteAverage;

  @override
  String toString() {
    switch (this) {
      case title:
        return 'byTitle'.i18n();
      case releaseDate:
        return 'byReleaseDate'.i18n();
      default:
        return 'byRating'.i18n();
    }
  }
}

enum Language {
  en,
  ru,
}
