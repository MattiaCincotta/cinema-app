class Director {
  final int id;

  final String name;

  final String imageUrl;

  Director({required this.id, required this.name, required this.imageUrl});
  
}


class Movie {
  final int directorID;

  final String title;

  final String imageUrl;

  final int year;

  Movie({required this.directorID, required this.title , required this.imageUrl, required this.year});
}