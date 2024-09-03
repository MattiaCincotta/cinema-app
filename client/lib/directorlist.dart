import 'package:client/favoritefilm.dart';
import 'package:client/filmpage.dart';
import 'package:client/movie_history.dart';
import 'package:flutter/material.dart';

class DirectionListPage extends StatefulWidget {
  const DirectionListPage({super.key});

  @override
  State<DirectionListPage> createState() => _DirectionListPageState();
}

class _DirectionListPageState extends State<DirectionListPage> {
  final List<Map<String, dynamic>> _items = [
    {
      'image': const AssetImage('images/Logo.jpg'),
      'title': 'Title 1',
    },
    {
      'image': const AssetImage('images/Logo.jpg'),
      'title': 'Title 2',
    },

  ];

  final Map<String, bool> _checkboxValues = {
    'Categoria 1': false,
    'Categoria 2': false,
    'Categoria 3': false,
    'Categoria 4': false,
    'Categoria 5': false,
    'Categoria 6': false,
    'Categoria 7': false,
    'Categoria 8': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'images/Logo.jpg', 
                width: 57.0, 
                height: 57.0,
                fit: BoxFit.cover, 
              ),
            ),
            const SizedBox(width: 10.0),
            const Text(
              'CineCult',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900], 
        elevation: 4.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            iconSize: 35,
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
                            fontSize: 30,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Azione',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 19), 
                                  Expanded(
                                      child: createCheckbox('Commedia',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Drammatico',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 19),
                                  Expanded(
                                      child: createCheckbox('Romantico',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Horror',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 19), 
                                  Expanded(
                                      child: createCheckbox('Thriller',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Fantasy',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 19), 
                                  Expanded(
                                      child: createCheckbox('Fantascienza',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Avventura',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 19), 
                                  Expanded(
                                      child: createCheckbox('Mistero',
                                          setState, tempCheckboxValues)),
                                ],
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
                                borderRadius: BorderRadius.circular(
                                    20.0), 
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 23, 
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
                                borderRadius: BorderRadius.circular(
                                    20.0), 
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 23, 
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
            icon: const Icon(Icons.search),
            iconSize: 35,
            onPressed: () {
              // TODO: Implementa la funzione per la ricerca
            },
          ),
          IconButton(
            icon: const Icon(Icons.star_border),
            iconSize: 35,
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
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MovieHistoryPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          // Divider sotto l'AppBar
          Divider(
            color: Colors.grey[900],
            thickness: 15, 
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white30, 
                thickness: 1.0, 
                height:
                    20.0, 
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return createInkWell(
                  context: context,
                  image: item['image'],
                  title: item['title'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget createInkWell({
    required BuildContext context,
    required ImageProvider image,
    required String title,
  }) {
    return InkWell(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: image,
                  width: 75,
                  height: 75,
                ),
                const SizedBox(
                    width: 10.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25.0, 
                    color: Colors.white, 
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FilmPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30.0), 
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 15.0), 
                textStyle: const TextStyle(
                  fontSize: 20.0, 
                  fontWeight: FontWeight.bold, 
                ),
              ),
              child: const Text('Esplora'),
            )
          ],
        ),
      ),
    );
  }

  Widget createCheckbox(String title, StateSetter setState, Map<String, bool> tempCheckboxValues) {
  return Row(
    children: [
      Transform.scale(
        scale: 1.5,
        child: Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          value: tempCheckboxValues[title] ?? false,
          onChanged: (bool? value) {
            setState(() {
              tempCheckboxValues[title] = value ?? false;
            });
          },
        ),
      ),
      const SizedBox(width: 10.0),
      Text(
        title,
        style: const TextStyle(
          fontSize: 15.0,   
          fontWeight: FontWeight.bold,
          color: Colors.black,  
        ),
      ),
    ],
  );
}
}
