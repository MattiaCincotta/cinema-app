import 'package:client/login.dart';
import 'package:flutter/material.dart';


class CinemaAppHomepage extends StatefulWidget {
  const CinemaAppHomepage({super.key});

  @override
  State<CinemaAppHomepage> createState() => _CinemaAppHomepageState();
}

class _CinemaAppHomepageState extends State<CinemaAppHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100), 
            CircleAvatar(
              radius: 150, // Dimensione dell'immagine
              backgroundColor: Colors.transparent, // Rendi trasparente il background
              child: ClipOval(
                child: Image.asset(
                  'images/Logo.jpg',
                  width: 300, // Larghezza dell'immagine
                  height: 300, // Altezza dell'immagine
                  fit: BoxFit.cover, // Adatta l'immagine per coprire l'area
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Testo grande
            Text(
              'CineCult',
              style: TextStyle(
                fontSize: 100, // Dimensione del testo
                fontWeight: FontWeight.bold, // Peso del testo
                color: Colors.grey[300],
                fontFamily: 'Roboto',   
              ),
            ),
            const SizedBox(height: 50), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600], // Colore di sfondo del bottone
              foregroundColor: Colors.white, // Colore del testo del bottone
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40), // Bordi stondati
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30), // Spaziatura interna
              elevation: 5, // Ombra del bottone
          ),
              child: const Text(
                'CONTINUA',
                style: TextStyle(fontSize: 27),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

