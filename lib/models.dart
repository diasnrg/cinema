import 'package:cinema/network.dart';

class Film {
  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    required this.posterPath,
    this.filmDetails,
  });

  final int id;
  final String title;
  final String releaseDate;
  final double voteAverage;
  final String posterPath;
  late final FilmDetails? filmDetails;

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'].toDouble(),
      posterPath: json['poster_path'],
    );
  }

  bool get isFilmDetailsLoaded => filmDetails != null;

  Future<void> loadFilmDetails() async {
    filmDetails = await Network.getFilmDetails(this); // handle exception
  }
}

class FilmDetails {
  const FilmDetails({
    required this.id,
    required this.isForAdults,
    required this.backdropPath,
    required this.revenue,
    required this.genres,
    required this.runtime,
    required this.overview,
  });

  final int id;
  final bool isForAdults;
  final String backdropPath;
  final int revenue;
  final List<String> genres;
  final int runtime;
  final String overview;

  factory FilmDetails.fromJson(Map<String, dynamic> json) {
    return FilmDetails(
      id: json['id'],
      isForAdults: json['adults'],
      backdropPath: json['backdrop_path'],
      revenue: json['revenue'],
      genres: (json['genres'] as List<Map<String, dynamic>>)
          .toList()
          .map((e) => e['name'] as String)
          .toList(),
      runtime: json['runtime'],
      overview: json['overview'],
    );
  }
}
