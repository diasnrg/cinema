import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:cinema/network.dart';

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
  Widget? _foregroundImage;

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'].toDouble(),
      posterPath: json['poster_path'],
    );
  }

// delete widget from model
  Widget? get foregroundImage {
    _foregroundImage ??= Image.network(
      Network.posterImageUrl(this),
      fit: BoxFit.cover,
    );
    return _foregroundImage;
  }

  Future<void> loadFilmDetails({Language? language}) async {
    details ??= await Network.getFilmDetails(
      this,
      language: language ?? Language.en,
    ); // handle exception
  }
}

class FilmDetails {
  FilmDetails({
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
  final int revenue;
  final List<String> genres;
  final int runtime;
  final String overview;
  final String backdropPath;
  Widget? _backgroundImage;

  Widget? get backgroundImage {
    return _backgroundImage ??= Image.network(
      Network.backdropImageUrl(this),
      fit: BoxFit.cover,
    );
  }

  factory FilmDetails.fromJson(Map<String, dynamic> json) {
    return FilmDetails(
      id: json['id'],
      isForAdults: json['adult'],
      backdropPath: json['backdrop_path'],
      revenue: json['revenue'],
      genres: (json['genres'] as List<dynamic>)
          .toList()
          .map((e) => e['name'] as String)
          .toList(),
      runtime: json['runtime'],
      overview: json['overview'],
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
