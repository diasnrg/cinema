import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

class Network {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String apiKey = '2f05ecb893a6f356e596873f1972d65b';

  static const String popularFilmListUrl =
      '$baseUrl/movie/popular?api_key=$apiKey';

  static String filmDetailsUrl(int id, {required Language language}) =>
      '$baseUrl/movie/$id?api_key=$apiKey&language=${language.name}';

  static String posterImageUrl(Film film) =>
      '$imageBaseUrl/w500/${film.posterPath}';
  static String backdropImageUrl(FilmDetails filmDetails) =>
      '$imageBaseUrl/original/${filmDetails.backdropPath}';

  static Future<List<Film>> getFilmList({
    Language language = Language.en,
  }) async {
    final response = await http
        .get(Uri.parse('$popularFilmListUrl&language=${language.name}'));

    if (response.statusCode != 200) {
      throw Exception('http request error');
    }

    return compute(_parseFilms, response.body);
  }

  static List<Film> _parseFilms(String responseBody) {
    final json = (jsonDecode(responseBody) as Map<String, dynamic>)['results']
        as List<dynamic>;
    return json.map((e) => Film.fromJson(e)).toList();
  }

  static Future<FilmDetails> getFilmDetails(
    Film film, {
    required Language language,
  }) async {
    final response =
        await http.get(Uri.parse(filmDetailsUrl(film.id, language: language)));
    if (response.statusCode != 200) {
      throw Exception('http request error');
    }

    return compute(_parseFilmDetails, response.body);
  }

  static FilmDetails _parseFilmDetails(String responseBody) {
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return FilmDetails.fromJson(json);
  }
}
