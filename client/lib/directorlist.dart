import 'package:client/favoritefilm.dart';
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
    // Aggiungi altri elementi qui
  ];

 final Map<String, bool> _checkboxValues = {
    'Opzione 1': false,
    'Opzione 2': false,
    'Opzione 3': false,
    'Opzione 4': false,
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
                'images/Logo.jpg', // Sostituisci con il percorso dell'immagine
                width: 57.0, // Dimensione dell'immagine
                height: 57.0, // Dimensione dell'immagine
                fit: BoxFit.cover, // Adatta l'immagine all'area
              ),
            ),
            const SizedBox(width: 10.0), // Spazio tra l'immagine e il titolo
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
        backgroundColor: Colors.grey[900], // Colore dello sfondo
        elevation: 4.0, // Aumenta l'elevazione per una leggera ombra
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            iconSize: 35,
            onPressed: () {
              showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Seleziona Categorie'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _checkboxValues.keys.map((String key) {
                    return Row(
                      children: [
                        Transform.scale(
                          scale: 1.5, // Dimensioni della checkbox
                          child: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Arrotonda la checkbox
                            ),
                            value: _checkboxValues[key],
                            onChanged: (bool? value) {
                              setState(() {
                                _checkboxValues[key] = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0), // Spazio tra la checkbox e il testo
                        Text(key),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Chiudi il dialog
                  },
                  child: const Text('Chiudi'),
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
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          // Divider sotto l'AppBar
          Divider(
            color: Colors.grey[900], // Colore del Divider
            thickness: 15, // Spessore del Divider
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white30, // Colore del Divider
                thickness: 1.0, // Spessore del Divider
                height:
                    20.0, // Altezza totale del Divider (compresa la spaziatura)
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
}

Widget createInkWell({
  required BuildContext context,
  required ImageProvider image,
  required String title,
}) {
  return InkWell(
    onTap: () {
      // Aggiungi qui la logica del tap, se necessario
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
              const SizedBox(width: 10.0), // Spazio tra l'immagine e il titolo
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25.0, // Dimensione del testo
                  color: Colors.white, // Colore del testo
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Aggiungi qui la logica del bottone "Esplora"
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DirectionListPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Bordi arrotondati
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 15.0), // Spaziatura interna
              textStyle: const TextStyle(
                fontSize: 20.0, // Dimensione del testo
                fontWeight: FontWeight.bold, // Peso del testo
              ),
            ),
            child: const Text('Esplora'),
          )
        ],
      ),
    ),
  );
}
