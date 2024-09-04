import 'package:flutter/material.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => __FilmPageStateState();
}

class __FilmPageStateState extends State<FilmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
        elevation: 4.0,
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


Widget createImageWithStar(ImageProvider image, String filmName) {
  return SizedBox(
    width: 250.0, // Riduci la larghezza della card
    height: 420.0, // Mantieni l'altezza della card
    child: Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19.0),
      ),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Immagine di sfondo
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19.0)),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Testo in basso a sinistra
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              filmName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Icona (checkbox) centrata
          Align(
            alignment: Alignment.centerRight, // Allinea a destra
            child: GestureDetector(
              onTap: () {
                // Azione da eseguire al click
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(right: 10.0, bottom: 10.0), // Aggiungi margine a destra e in basso
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_border,
                  color: Colors.lightBlue,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
