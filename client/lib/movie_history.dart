import 'package:flutter/material.dart';

class MovieHistoryPage extends StatefulWidget {
  const MovieHistoryPage({super.key});

  @override
  State<MovieHistoryPage> createState() => _MovieHistoryPageState();
}

class _MovieHistoryPageState extends State<MovieHistoryPage> {
  int _favoriteCount = 0; // Variabile contatore

  // Funzione per creare un'immagine con un'icona (al posto della checkbox)
  Widget createImageWithStar(ImageProvider image, String filmName) {
    bool isChecked = true; // L'icona è inizialmente selezionata

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5, // Ombra della card
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filmName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  maxLines: 2, // Limita il titolo a 2 righe
                  overflow: TextOverflow
                      .ellipsis, // Aggiunge i puntini se il testo è troppo lungo
                ),
                const SizedBox(height: 15), // Spazio tra il titolo e l'immagine
                Image(
                  image: image,
                  width: double.infinity,
                  height: 275, // Aumenta l'altezza dell'immagine
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                          if (isChecked) {
                            _favoriteCount++;
                          } else {
                            _favoriteCount--;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: isChecked
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
                          isChecked
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.lightBlue,
                          size:
                              45, // Dimensione dell'icona leggermente aumentata
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
          onPressed: () {
            Navigator.pop(
                context); // Funzione per tornare alla pagina precedente
          },
        ),
        title: const Text(
          'Film Visti',
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
                  Icons.movie,
                  color: Colors.white,
                  size: 33,
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '$_favoriteCount', // Numero di film preferiti
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 35,
                  onPressed: () {
                    // TODO: Implementa la funzione per la ricerca
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B1B1B),
              Color(0xFF333333),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              createImageWithStar(
                const AssetImage('assets/images/Logo.jpg'), // Esempio di immagine
                'La storia della principessa splendente e delle sue avventure straordinarie',
              ),
              createImageWithStar(
                const AssetImage('assets/images/Logo.jpg'), // Esempio di immagine
                'Un altro film con un titolo molto lungo che si estende per diverse righe',
              ),
              createImageWithStar(
                const AssetImage('assets/images/Logo.jpg'), // Esempio di immagine
                'La storia della principessa splendente',
              ),
              // Aggiungi altre chiamate a createImageWithStar() qui se necessario
            ],
          ),
        ),
      ),
    );
  }
}
