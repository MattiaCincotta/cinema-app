import 'package:flutter/material.dart';

class MovieHistoryPage extends StatefulWidget {
  const MovieHistoryPage({super.key});

  @override
  State<MovieHistoryPage> createState() => _MovieHistoryPageState();
}

class _MovieHistoryPageState extends State<MovieHistoryPage> {
  int _counter = 0; // Variabile contatore

  // Funzione per creare un'immagine con un'icona (al posto della checkbox)
  Widget createImageWithStar(ImageProvider image, String filmName) {
    bool isChecked = true; // L'icona è inizialmente selezionata

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Visibility(
          visible: isChecked, // La visibilità dipende dallo stato dell'icona
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Allinea gli elementi a sinistra
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding orizzontale per evitare che il testo tocchi i bordi
                child: Text(
                  filmName,
                  textAlign: TextAlign.center, // Allinea il testo a sinistra
                  style: const TextStyle(
                    fontSize: 30, // Dimensione del testo
                    fontWeight: FontWeight.bold, // Testo in grassetto
                    color: Colors.redAccent,
                  ),
                  softWrap: true, // Abilita il ritorno a capo automatico
                ),
              ),
              const SizedBox(height: 20), // Spazio tra il testo e l'immagine
              Row(
                children: [
                  Image(
                    image: image,
                    width: 300, // Dimensione dell'immagine
                    height: 300, // Dimensione dell'immagine
                  ),
                  const SizedBox(width: 30), // Spazio tra l'immagine e l'icona
                  IconButton(
                    icon: const Icon(
                      Icons.check_box,
                      color: Colors.lightBlue, // Colore dell'icona
                      size: 65, // Dimensione dell'icona
                    ),
                    onPressed: () {
                      setState(() {
                        isChecked = !isChecked;
                        if (isChecked) {
                          // Incrementa il contatore quando l'icona viene selezionata
                          _counter++;
                        } else {
                          // Decrementa il contatore quando l'icona viene deselezionata
                          _counter--;
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10), // Spazio tra il Row e il Divider
              const Divider(
                color: Colors.white30, // Colore del divider
                thickness: 2, // Spessore del divider
                height: 20, // Altezza totale del divider (compresa la spaziatura)
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'La Mia Cronologia',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Imposta il testo in grassetto (bold)
            fontSize: 27,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
        elevation: 4.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                '$_counter', // Mostra il contatore nell'AppBar
                style: const TextStyle(fontSize: 30.0),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            createImageWithStar(
              const AssetImage('images/Logo.jpg'), // Esempio di immagine
              'La storia della principessa splendente',
            ),
            createImageWithStar(
              const AssetImage('images/Logo.jpg'), // Esempio di immagine
              'La storia della principessa splendente',
            ),
            createImageWithStar(
              const AssetImage('images/Logo.jpg'), // Esempio di immagine
              'La storia della principessa splendente',
            ),
            // Aggiungi altre chiamate a createImageWithStar() qui se necessario
          ],
        ),
      ),
    );
  }
}
