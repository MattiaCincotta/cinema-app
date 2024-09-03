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
      'image': const AssetImage('assets/images/Logo.jpg'),
      'title': 'Title 1',
    },
    {
      'image': const AssetImage('assets/images/Logo.jpg'),
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
          'assets/images/Logo.jpg', 
          width: 45.0, 
          height: 45.0,
          fit: BoxFit.cover, 
        ),
      ),
      const SizedBox(width: 15.0), // Maggiore spazio tra il logo e il testo
      const Text(
        'CineCult',
        style: TextStyle(
          fontSize: 26, // Ridotto per una proporzione migliore
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  foregroundColor: Colors.white,
  backgroundColor: Colors.grey[850], // Colore di sfondo leggermente diverso
  elevation: 6.0, // Maggiore elevazione per un'ombra più pronunciata
  actions: [
    IconButton(
      icon: const Icon(Icons.star_border),
      iconSize: 28, // Ridotto per coerenza con il testo
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
      icon: const Icon(Icons.search),
      iconSize: 28,
      onPressed: () {
        // TODO: Implementa la funzione per la ricerca
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
                      fontSize: 24,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: _checkboxValues.keys.map((category) {
                            return FilterChip(
                              label: Text(category),
                              selected: tempCheckboxValues[category] ?? false,
                              onSelected: (bool selected) {
                                setState(() {
                                  tempCheckboxValues[category] = selected;
                                });
                              },
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey[300],
                              labelStyle: const TextStyle(color: Colors.white),
                              side: BorderSide(
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
                          fontSize: 18,
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
                          fontSize: 18,
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
    // Divider sotto l'AppBar
    Container(
      color: Colors.grey[850], // Colore leggermente diverso per il Divider
      child: Divider(
        color: Colors.grey[900],
        thickness: 15,
      ),
    ),
    Expanded(
      child: ListView.separated(
        itemCount: _items.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.white30,
          thickness: 1.0,
          height: 20.0,
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
          activeColor: Colors.blueAccent, // Colore per checkbox selezionato
          checkColor: Colors.white, // Colore per spunta
          value: tempCheckboxValues[title] ?? false,
          onChanged: (bool? value) {
            setState(() {
              tempCheckboxValues[title] = value ?? false;
            });
          },
        ),
      ),
      const SizedBox(width: 15.0), // Maggiore spazio tra checkbox e testo
      Text(
        title,
        style: const TextStyle(
          fontSize: 16.0, // Maggiore leggibilità
          fontWeight: FontWeight.w600, // Peso font più visibile
          color: Colors.white, 
        ),
      ),
    ],
  );
}
}