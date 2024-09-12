import 'package:flutter/material.dart';
import 'package:client/utils/request_manager.dart';

class FavoriteFilmPage extends StatefulWidget {
  const FavoriteFilmPage({super.key});

  @override
  State<FavoriteFilmPage> createState() => _FavoriteFilmPageState();
}

class _FavoriteFilmPageState extends State<FavoriteFilmPage> {
  int initialFilmNumber = 0;
  final ValueNotifier<int> filmNumberNotifier = ValueNotifier<int>(0);
  final List<String> removedFilm = [];
  bool showSearchBar = false;
  final TextEditingController searchController = TextEditingController();
  final RequestManager requestManager =
      RequestManager(baseUrl: 'http://172.18.0.3:5000');
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() async {
    final result = await requestManager.getFavorites();
    if (result != null) {
      final List<Movie> movies = [];
      for (var movieData in result) {
        movies.add(Movie(
          directorID: movieData["director_id"],
          title: movieData["title"],
          imageUrl: movieData["image_url"],
          year: movieData["year"],
        ));
      }
      setState(() {
        _movies = movies;
        _filteredMovies = movies;
      });
      filmNumberNotifier.value = _movies.length; // Imposta il valore iniziale
      initialFilmNumber = _movies.length;
    }
  }

  void _filterMovies(String query) {
    final filtered = _movies.where((movie) {
      final titleLower = movie.title.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();
    setState(() {
      _filteredMovies = filtered;
    });
  }

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
          onPressed: () async {
            bool shouldExit = await _confirmationDialog();
            if (shouldExit) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Preferiti',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            fontFamily: 'Cinematic',
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
        elevation: 4.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 33,
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<int>(
                  valueListenable: filmNumberNotifier,
                  builder: (context, filmNumber, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        filmNumber.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 35,
                  onPressed: () {
                    setState(() {
                      showSearchBar = !showSearchBar;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          if (showSearchBar)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Cerca film...',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
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
                      _filterMovies('');
                    },
                  ),
                ),
                onChanged: (value) {
                  _filterMovies(value);
                },
              ),
            ),
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(
                    child: Text(
                      'Nessun film trovato.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: _filteredMovies.map((movie) {
                        return createCard(movie.imageUrl, movie.title);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget createCard(String imageUrl, String title) {
    bool isFavorite = true;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 275,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                          if (!isFavorite) {
                            if (!removedFilm.contains(title)) {
                              removedFilm.add(title);
                              filmNumberNotifier
                                  .value--; // Diminuisci il contatore
                              print('Film aggiunto a removedFilm: $title');
                            }
                          } else {
                            removedFilm.remove(title);
                            filmNumberNotifier.value++; // Aumenta il contatore
                            print('Film rimosso da removedFilm: $title');
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: isFavorite
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.grey,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _confirmationDialog() async {
    // Condizione casuale, ad esempio un numero casuale
    if (filmNumberNotifier.value == initialFilmNumber) {
      return true; // Evita di mostrare il popup
    }

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Conferma'),
              content: const Text(
                  'Vuoi eliminare i film dai preferiti prima di uscire?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Utente ha scelto "No"
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    // Utente ha scelto "Sì"
                    for (String title in removedFilm) {
                      await requestManager.removeFavorite(title);
                    }

                    // Chiude il dialogo e ritorna true
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Sì'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

class Movie {
  final int directorID;
  final String title;
  final String imageUrl;
  final int year;

  Movie({
    required this.directorID,
    required this.title,
    required this.imageUrl,
    required this.year,
  });
}
