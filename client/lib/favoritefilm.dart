import 'package:flutter/material.dart';

class FavoriteFilmPage extends StatefulWidget {
  const FavoriteFilmPage({super.key});

  @override
  State<FavoriteFilmPage> createState() => _FavoriteFilmPageState();
}

class _FavoriteFilmPageState extends State<FavoriteFilmPage> {
  int _favoriteCount = 0; // Variabile contatore per i film preferiti

  // Funzione per creare una card con un'immagine e un titolo
  Widget createImageWithIcon(ImageProvider image, String filmName) {
    bool isFavorite = false; // Stato iniziale dell'icona

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
                          isFavorite = !isFavorite;
                          if (isFavorite) {
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
                          isFavorite ? Icons.favorite_border : Icons.favorite,
                          color: isFavorite ? Colors.grey: Colors.redAccent,
                          size: 45, // Dimensione dell'icona
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
              createImageWithIcon(
                const AssetImage('assets/images/Logo.jpg'), // Esempio di immagine
                'La storia della principessa splendente e delle sue avventure straordinarie',
              ),
              createImageWithIcon(
                const AssetImage('assets/images/Logo.jpg'), // Esempio di immagine
                'Un altro film con un titolo molto lungo che si estende per diverse righe',
              ),
              createImageWithIcon(
                const AssetImage('assets/images/Logo.jpg'), // Esempio di immagine
                'La storia della principessa splendente',
              ),
              // Aggiungi altre chiamate a createImageWithIcon() qui se necessario
            ],
          ),
        ),
      ),
    );
  }
}
