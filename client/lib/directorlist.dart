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
    'Horror      ': false,
    'Thriller          ': false,
    'Mistero    ': false,
    'Romantico    ': false,
    'Fantasy    ': false,
    'Drammatico  ': false,
    'Avventura': false,
    'Fantascienza': false,
  };

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

  String _getCategoryID(String categoryName) {
    const categoryMap = {
      'Horror      ': '1',
      'Thriller          ': '2',
      'Mistero    ': '3',
      'Romantico    ': '4',
      'Fantasy    ': '5',
      'Drammatico  ': '6',
      'Avventura': '7',
      'Fantascienza': '8',
    };
    return categoryMap[categoryName.trim()] ?? '';
  }

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

                              List<int> selectedCategoryIds = _checkboxValues.entries
                                  .where((entry) => entry.value)
                                  .map((entry) {
                                    final categoryIdString = _getCategoryID(entry.key);
                                    return int.tryParse(categoryIdString);
                                  })
                                  .where((id) => id != null) // Filtra gli ID nulli
                                  .map((id) => id!) // Converti non-null ID a int
                                  .toList();

                              if (selectedCategoryIds.isNotEmpty) {
                                _searchDirectorByCategory(selectedCategoryIds);
                              }

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
                      truncateWithEllipsis(13,
                          getSurname(name)), 
                      style: const TextStyle(
                        fontSize: 23.0,
                        color: Colors.white,
                      ),
                      maxLines: 1, 
                      overflow: TextOverflow
                          .ellipsis, 
                      softWrap: false, 
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilmPage(name: name, id: id, imageUrl: imageUrl)),
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
