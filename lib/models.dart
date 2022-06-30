class Film {
  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.voteAverage,
    required this.posterPath,
  });

  final int id;
  final String title;
  final String releaseDate;
  final double voteAverage;
  final String posterPath;

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average'].toDouble(),
      posterPath: json['poster_path'],
    );
  }

  @override
  String toString() {
    return '$id:$title';
  }
}
