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
              // Crea una copia temporanea dello stato delle checkbox
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
                            fontSize: 25, // Dimensione del testo, opzionale
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Categoria 1',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 20), // Spazio tra le colonne
                                  Expanded(
                                      child: createCheckbox('Categoria 2',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Categoria 3',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 20), // Spazio tra le colonne
                                  Expanded(
                                      child: createCheckbox('Categoria 4',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Categoria 5',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 20), // Spazio tra le colonne
                                  Expanded(
                                      child: createCheckbox('Categoria 6',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: createCheckbox('Categoria 7',
                                          setState, tempCheckboxValues)),
                                  const SizedBox(width: 20), // Spazio tra le colonne
                                  Expanded(
                                      child: createCheckbox('Categoria 8',
                                          setState, tempCheckboxValues)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Chiudi il dialog
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Arrotonda i bordi del bottone
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 23, // Dimensione del testo
                              ),
                            ),
                            child: const Text('Chiudi'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Chiudi il dialog
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Arrotonda i bordi del bottone
                              ),
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 23, // Dimensione del testo
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
                const SizedBox(
                    width: 10.0), // Spazio tra l'immagine e il titolo
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
                  borderRadius:
                      BorderRadius.circular(30.0), // Bordi arrotondati
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

  Widget createCheckbox(String title, StateSetter setState,
      Map<String, bool> tempCheckboxValues) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            value:
                tempCheckboxValues[title] ?? false, // Usa lo stato temporaneo
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
            fontSize: 15.0, // Modifica la dimensione del testo qui
            color: Colors.black, // Puoi anche modificare il colore del testo
          ),
        ),
      ],
    );
  }
}
