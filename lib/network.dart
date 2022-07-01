import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cinema/models.dart';

class Network {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String apiKey = '2f05ecb893a6f356e596873f1972d65b';
  static const String popularFilmListUrl =
      '$baseUrl/movie/popular?api_key=$apiKey&language=en';

  static String filmDetailsUrl(int id) =>
      '$baseUrl/movie/$id?api_key=$apiKey&language=en';

  static String posterImageUrl(Film film) =>
      '$imageBaseUrl/w500/${film.posterPath}';
  static String backdropImageUrl(FilmDetails filmDetails) =>
      '$imageBaseUrl/original/${filmDetails.backdropPath}';

  static Future<List<Film>> getFilmList() async {
    final response = await http.get(Uri.parse(popularFilmListUrl));

    if (response.statusCode != 200) {
      throw Exception('failed to load cinema list');
    } // handle exception

    final json = (jsonDecode(response.body) as Map<String, dynamic>)['results']
        as List<dynamic>;
    final films = json.map((e) => Film.fromJson(e)).toList(); // validate json
    return films;
  }

  static Future<FilmDetails> getFilmDetails(Film film) async {
    final response = await http.get(Uri.parse(filmDetailsUrl(film.id)));
    if (response.statusCode != 200) {
      throw Exception('failed to load cinema list');
    } // handle exception

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final filmDetails = FilmDetails.fromJson(json);
    return filmDetails;
  }
}
