import 'package:flutter/material.dart';
import 'package:client/favoritefilm.dart';
import 'package:client/filmpage.dart';
import 'package:client/movie_history.dart';
import 'package:client/utils/models.dart';
import 'package:client/utils/request_manager.dart';

class DirectionListPage extends StatefulWidget {
  const DirectionListPage({super.key});

  @override
  State<DirectionListPage> createState() => _DirectionListPageState();
}

class _DirectionListPageState extends State<DirectionListPage> {
  final Map<String, bool> _checkboxValues = {
    'Horror': false,
    'Thriller': false,
    'Mistero': false,
    'Romantico': false,
    'Fantasy': false,
    'Fantascienza': false,
    'Avventura': false,
    'Drammatico': false,
  };

  final RequestManager requestManager = RequestManager(baseUrl: 'http://172.18.0.3:5000');
  final TextEditingController searchController = TextEditingController();
  bool showSearchBar = false; // Variabile di stato per mostrare/nascondere la barra di ricerca

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/Logo.jpg',
                width: 45.0,
                height: 45.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15.0),
            const Text(
              'CineCult',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[850],
        elevation: 6.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 28,
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar; // Mostra o nasconde la barra di ricerca
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            iconSize: 28,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FavoriteFilmPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            iconSize: 28,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MovieHistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            iconSize: 28,
            onPressed: () {
              final Map<String, bool> tempCheckboxValues =
                  Map.from(_checkboxValues);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                        title: const Text(
                          'Filtra per Categoria',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 30.0,
                                runSpacing: 10.0,
                                children: _checkboxValues.keys.map((category) {
                                  return FilterChip(
                                    label: Text(category),
                                    selected:
                                        tempCheckboxValues[category] ?? false,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        tempCheckboxValues[category] = selected;
                                      });
                                    },
                                    selectedColor: Colors.blueAccent,
                                    backgroundColor: Colors.grey[300],
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    side: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 2,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Chiudi'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _checkboxValues.clear();
                                _checkboxValues.addAll(tempCheckboxValues);
                              });
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Applica'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          if (showSearchBar) // Mostra la barra di ricerca solo se showSearchBar è true
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  color: Colors.white, // Colore del testo digitato
                ),
                decoration: InputDecoration(
                  hintText: 'Cerca regista...',
                  hintStyle: const TextStyle(
                    color: Colors.white54, // Colore del testo suggerimento
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(color: Colors.white), // Colore del bordo
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white, // Colore dell'icona di ricerca
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white, // Colore dell'icona clear
                    ),
                    onPressed: () {
                      searchController.clear();
                      FocusScope.of(context).unfocus(); // Chiude la tastiera
                    },
                  ),
                ),
                onSubmitted: (value) {
                  // Logica di ricerca
                  print('Ricerca per: $value');
                },
              ),
            ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.grey[850],
                  child: Divider(
                    color: Colors.grey[900],
                    thickness: 15,
                  ),
                ),
                FutureBuilder(
                    future: requestManager.getDirectors(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Error loading directors.',
                            style: TextStyle(
                              color: Colors.red, // Colore rosso
                              fontWeight: FontWeight.bold, // Grassetto
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'No directors found.',
                            style: TextStyle(
                              color: Colors.red, // Colore rosso
                              fontWeight: FontWeight.bold, // Grassetto
                            ),
                          ),
                        );
                      }

                      final dynamic result = snapshot.data;

                      int count = result["count"] as int;

                      List<Director> directors = [];
                      for (int i = 0; i < count; i++) {
                        print(result["directors"][i]["name"]);
                        directors.add(Director(
                            id: result["directors"][i]["id"],
                            name: result["directors"][i]["name"],
                            imageUrl: result["directors"][i]["image_url"]));
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: directors.length,
                          itemBuilder: (context, index) {
                            print(directors[index].imageUrl);
                            return createCard(
                              context: context,
                              imageUrl: directors[index].imageUrl,
                              name: directors[index].name,
                            );
                          },
                        ),
                      );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget createCard({
    required BuildContext context,
    required String imageUrl,
    required String name,
  }) {
    return Column(
      children: [
        Card(
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        imageUrl,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FilmPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    textStyle: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Esplora'),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.white30,
          thickness: 1.0,
          height: 20.0,
        ),
      ],
    );
  }
}
