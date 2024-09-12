import 'package:flutter/material.dart';
import 'package:client/utils/request_manager.dart';
import 'package:client/utils/favorites_manager.dart';
import 'package:client/utils/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FilmPage extends StatefulWidget {
  final String name;
  final int id;
  final String imageUrl;

  const FilmPage({
    super.key,
    required this.name,
    required this.id,
    required this.imageUrl,
  });

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  bool isViewed = false;
  bool showSearchBar = false;
  final RequestManager requestManager =
      RequestManager(baseUrl: 'http://172.18.0.3:5000');
  final TextEditingController searchController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final FavoritesManager favoritesController = FavoritesManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            fontFamily: 'Cinematic',
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
        elevation: 4.0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            if (showSearchBar)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cerca film...',
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    print('Ricerca per: $value');
                  },
                ),
              ),
            Card(
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.imageUrl,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String?>(
                            future:
                                requestManager.getDirectorBiography(widget.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Text(
                                  'Errore nel caricamento della biografia.',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text(
                                  'Nessuna biografia disponibile.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                );
                              } else {
                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                    fontSize: 3.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
                listenable: favoritesController,
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: requestManager.getDirectorMovies(widget.name),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print('Errore: ${snapshot.error}');
                        return const Center(
                          child: Text(
                            'Error loading movies.',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            'No movies found.',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        final dynamic result = snapshot.data;

                        List<Movie> movies = [];
                        for (var movieData in result) {
                          movies.add(Movie(
                            directorID: movieData["director_id"],
                            movieID: movieData["id"],
                            title: movieData["title"],
                            imageUrl: movieData["image_url"],
                            year: movieData["year"],
                          ));
                        }

                        List<Widget> movieCards = movies.map((movie) {
                          return createCard(
                            context,
                            movie.movieID,
                            movie.title,
                            movie.imageUrl,
                            movie.year,
                          );
                        }).toList();

                        return Expanded(
                          child: SingleChildScrollView(
                            child: createCardRows(movieCards),
                          ),
                        );
                      }
                    },
                  );
                })
          ],
        ),
      ),
    );
  }

Widget createCard(
  BuildContext context, int id, String title, String imageUrl, int year) {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return FutureBuilder<bool>(
        future: requestManager.isFavorite(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 250.0,
              height: 410.0,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.0),
                ),
                elevation: 3,
                child: const Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (snapshot.hasError) {
            print('Errore: ${snapshot.error}');
            return SizedBox(
              width: 250.0,
              height: 410.0,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.0),
                ),
                elevation: 3,
                child: const Center(child: Text('Errore')),
              ),
            );
          } else {
            bool isFavorite = snapshot.data ?? false;
            print('isFavorite: $isFavorite');

            return SizedBox(
              width: 250.0,
              height: 410.0,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.0),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(19.0)),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            year.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {

                              await favoritesController.toggleFavorite(isFavorite, title, id);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.redAccent : Colors.grey,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    },
  );
}


  Widget createCardRows(List<Widget> cards) {
    List<Widget> rows = [];
    for (int i = 0; i < cards.length; i += 2) {
      if (i + 1 < cards.length) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: cards[i]),
              Expanded(child: cards[i + 1]),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 225.0,
                child: cards[i],
              ),
            ],
          ),
        );
      }
    }
    return Column(children: rows);
  }
}
