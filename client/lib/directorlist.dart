// ignore_for_file: use_build_context_synchronously

import 'package:client/homepage.dart';
import 'package:flutter/material.dart';
import 'package:client/favoritefilm.dart';
import 'package:client/filmpage.dart';
import 'package:client/movie_history.dart';
import 'package:client/utils/models.dart';
import 'package:client/utils/request_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Category {
  final int id;
  bool isSelected;

  Category(this.id, this.isSelected);
}

// Mappa delle categorie
final Map<String, Category> categories = {
  'Horror      ':  Category(1, false),
  'Thriller          ':  Category(2, false),
  'Mistero    ': Category(3, false),
  'Romantico    ': Category(4, false),
  'Fantasy    ': Category(5, false),
  'Drammatico ': Category(6, false),
  'Avventura': Category(7, false),
  'Fantascienza': Category(8, false),
};

class DirectionListPage extends StatefulWidget {
  const DirectionListPage({super.key});

  @override
  State<DirectionListPage> createState() => _DirectionListPageState();
}

class _DirectionListPageState extends State<DirectionListPage> {
  final RequestManager requestManager =
      RequestManager(baseUrl: 'http://172.18.0.3:5000');
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  List<Director> _directors = [];
  List<Director> _filteredDirectors = [];

  @override
  void initState() {
    super.initState();
    _fetchDirectors();
  }

  void _fetchDirectors() async {
    final result = await requestManager.getDirectors();
    if (result != null) {
      final count = result["count"] as int;
      final List<Director> directors = [];
      for (int i = 0; i < count; i++) {
        directors.add(Director(
          id: result["directors"][i]["id"],
          name: result["directors"][i]["name"],
          imageUrl: result["directors"][i]["image_url"],
        ));
      }
      setState(() {
        _directors = directors;
        _filteredDirectors = directors;
      });
    }
  }

  void _filterDirectors(String query) {
    final filtered = _directors.where((director) {
      final nameLower = director.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
    setState(() {
      _filteredDirectors = filtered;
    });
  }

  void _searchDirectorByCategory(List<int> categoryIds) async {
    if (categoryIds.isEmpty) {
      _fetchDirectors();
    } else {
      final result = await requestManager.getDirectorCategory(categoryIds);
      if (result != null) {
        final List<Director> directors = [];
        for (var directorData in result["directors"]) {
          directors.add(Director(
            id: directorData["id"],
            name: directorData["name"],
            imageUrl: directorData["image_url"],
          ));
        }
        setState(() {
          _directors = directors;
          _filteredDirectors = directors;
        });
      }
    }
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),  // Bordi arrotondati
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 30),  // Aggiunge un'icona di avvertimento
            SizedBox(width: 10),
            Text(
              'Conferma Logout',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Sei sicuro di voler uscire?',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Utente ha scelto "No"
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Utente ha scelto "Sì"
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Sì'),
          ),
        ],
      );
    },
  ) ?? false; // Restituisce false se l'utente chiude il dialog senza fare una scelta
}


  void _logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token'); 
    await storage.write(key: 'rememberMe', value: 'false');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const CinemaAppHomepage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
             Text(
              'CineCult',
              style: TextStyle(
                fontSize: 36,
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
                _showSearchBar = !_showSearchBar;
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
              final Map<String, Category> tempCategoryStates =
                  Map.from(categories);

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
                                children: categories.keys.map((category) {
                                  final Category categoryData =
                                      categories[category]!;
                                  return FilterChip(
                                    label: Text(category),
                                    selected: categoryData.isSelected,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        categoryData.isSelected = selected;
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
                                categories.forEach((key, value) {
                                  value.isSelected =
                                      tempCategoryStates[key]!.isSelected;
                                });
                              });

                              List<int> selectedCategoryIds = categories.values
                                  .where((category) => category.isSelected)
                                  .map((category) => category.id)
                                  .toList();

                              _searchDirectorByCategory(selectedCategoryIds);

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
           IconButton(
            icon: const Icon(Icons.logout),
            iconSize: 28,
            onPressed: () async {
              bool shouldLogout = await _showLogoutConfirmationDialog(context);
              if (shouldLogout) {
                _logout();
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(
        slivers: [
          if (_showSearchBar)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cerca regista...',
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
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        _filterDirectors('');
                      },
                    ),
                  ),
                  onChanged: (value) {
                    _filterDirectors(value);
                  },
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return createCard(
                  context: context,
                  imageUrl: _filteredDirectors[index].imageUrl,
                  name: _filteredDirectors[index].name,
                  id: _filteredDirectors[index].id,
                );
              },
              childCount: _filteredDirectors.length,
            ),
          ),
        ],
      ),
    );
  }
}

Widget createCard({
  required BuildContext context,
  required String imageUrl,
  required name,
  required id,
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
                    truncateWithEllipsis(13, getSurname(name)),
                    style: const TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FilmPage(name: name, id: id, imageUrl: imageUrl)),
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
              )
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

String truncateWithEllipsis(int cutoff, String text) {
  return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
}

String getSurname(String name) {
  List<String> parts = name.split(' ');
  if (parts.length > 1) {
    return parts.last;
  }
  return name;
}
