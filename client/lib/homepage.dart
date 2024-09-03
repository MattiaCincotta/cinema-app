import 'package:flutter/material.dart';
import 'package:client/login.dart';

class CinemaAppHomepage extends StatefulWidget {
  const CinemaAppHomepage({super.key});

  @override
  State<CinemaAppHomepage> createState() => _CinemaAppHomepageState();
}

class _CinemaAppHomepageState extends State<CinemaAppHomepage> {

  final List<Map<String, String>> _quotes = [
  {'quote': '"Siamo tutti e due dei meravigliosi sconosciuti."', 'author': 'The Big Lebowski'},
  {'quote':'"Meglio essere un porco che un fascista."', 'author': 'Porco Rosso'},
  {'quote': '"Che la forza sia con te."', 'author': 'Star Wars'},
  {'quote': '"Rosebud."', 'author': 'Quarto Potere'},
  {'quote': '"Mi hai completato."', 'author': 'Jerry Maguire'},
  {'quote': '"Tu non puoi mancare a questo appuntamento!"', 'author': 'L\'attimo fuggente'},
  {'quote': '"Ho visto cose che voi umani non potreste immaginare."', 'author': 'Blade Runner'},
  {'quote': '"Siamo qui per divertirci!"', 'author': 'The Blues Brothers'},
  {'quote': '"Non c’è posto come casa."', 'author': 'Il Mago di Oz'},
  {'quote': '"E.T. telefono casa."', 'author': 'E.T. l\'extraterrestre'},
  {'quote': '"Oggi è il primo giorno del resto della tua vita."', 'author': 'Lezioni di piano'},
  {'quote': '"C’è un posto per tutti nel mondo."', 'author': 'Il favoloso mondo di Amélie'},
  {'quote': '"La vita è come una scatola di cioccolatini, non sai mai quello che ti capita."', 'author': 'Forrest Gump'},
  {'quote': '"Non è un posto per un uomo onesto. Siamo i bravi ragazzi, i ragazzi che fanno le cose per bene."', 'author': 'Quei Bravi Ragazzi'},
  {'quote': '"Vivi libero o muori cercando."', 'author': 'Braveheart'},
  {'quote': '"Non sono io che ho cambiato, sei tu che sei rimasto indietro."', 'author': 'Matrix'},
  {'quote': '"La natura non è né buona né cattiva, ma è ciò che è."', 'author': 'Principessa Mononoke'},
  {'quote': '"Sei qui per sempre."', 'author': 'Casablanca'},
  {'quote': '"Non è la dimensione dell’uccello che conta, ma il suo coraggio."', 'author': 'Il Grande Lebowski'},
  {'quote': '"Fai quello che devi fare."', 'author': 'Il Padrino'},
  {'quote': '"L’amore è tutto ciò di cui hai bisogno."', 'author': 'Across the Universe'},
  {'quote': '"La mia vendetta sarà epica."', 'author': 'Kill Bill'},
  {'quote': '"L’importante non è dove sei, ma con chi sei."', 'author': 'La Vita è Bella'},
  {'quote': '"Ho un sogno." ', 'author': 'Inception'},
  {'quote': '"Nessuno è perfetto."', 'author': 'A qualcuno piace caldo'},
  {'quote': '"Siamo tutti sulla stessa barca."', 'author': 'I Soliti Ignoti'},
  {'quote': '"Il mondo è dei pazzi, ma anche il cielo lo è."', 'author': 'L\'uomo che non c\'era'},
  {'quote': '"Ehi, tu parli con me?"', 'author': 'Taxi Driver'},
  {'quote': '"Signori, non potete combattere qui! Questa è la sala delle guerre!"', 'author': 'Dottor Stranamore'},
  {'quote': '"Ho sempre avuto paura di essere solo."', 'author': 'Il Sesto Senso'},
  {'quote': 'Anche se avessi mille vite, avrei sempre la nostalgia di questo mondo.', 'author': 'Principessa Splendente'},
  {'quote': '"Penso, dunque sono."', 'author': 'Matrix'},
  {'quote': '"Siamo tutti un po’ folli."', 'author': 'Psycho'},
  {'quote': '"L’immaginazione è più importante della conoscenza."', 'author': 'Il Mago di Oz'},
  {'quote': '"Vivi come se dovessi morire domani."', 'author': 'V per Vendetta'},
  {'quote': '"Non c’è niente che non può essere risolto."', 'author': 'Il Signore degli Anelli'},
  {'quote': '"I sogni non sono mai solo sogni."', 'author': 'Inception'},
  {'quote': '"Ridi e il mondo riderà con te."', 'author': 'La vita è bella'},
  {'quote': '"Ho dei piani. Grandi piani."', 'author': 'Il Principe delle Maree'},
  {'quote': '"Non sono io, sono il mio personaggio."', 'author': 'Fight Club'},
  {'quote': '"Ho avuto una visione. Un sogno che non mi lasciava in pace."', 'author': 'L\'ombra del vampiro'},
  {'quote': '"Non avrai mai niente di buono se non combatti per esso."', 'author': 'Rocky'},
  {'quote': '"Supercazzola con scappellamento a sinistra!"', 'author': 'Amici miei'},
  {'quote': '"Tutto è possibile con la giusta determinazione."', 'author': 'L\'attimo fuggente'},
  {'quote': '"La magia è credere in te stesso."', 'author': 'Il Mago di Oz'},
  {'quote': '"Il futuro è incerto."', 'author': 'Ritorno al Futuro'},
  {'quote': '"Il tempo è relativo."', 'author': 'Interstellar'},
  {'quote': '"Ero stato curato, va bene."', 'author': 'Arancia Meccanica'},
  {'quote': '"C’è qualcosa di speciale in ogni cosa."', 'author': 'Il Grande Gatsby'},
  {'quote': '"Nessuno è perfetto." ', 'author': 'A qualcuno piace caldo'},
  {'quote': '"Le persone possono cambiare."', 'author': 'Forrest Gump'},
  {'quote': '"La speranza è l’ultima a morire."', 'author': 'Le Ali della Libertà'},
  {'quote': '"La vita è un dono.",', 'author': 'Il Cavaliere Oscuro'},
  {'quote': '"Non c’è niente di più potente di un’idea.','author': 'Inception'},
  {'quote': '"Il mondo è un palcoscenico e la recita è mal interpretata."', 'author': 'Barry Lyndon'},
  {'quote': '"La vita è un viaggio, non una destinazione."', 'author': 'Il Signore degli Anelli'},
];

  int _currentQuoteIndex = 0;

  void _changeQuote() {
    setState(() {
      _currentQuoteIndex = (_currentQuoteIndex + 1) % _quotes.length;
    });
  }

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
              radius: 150,
              backgroundColor: Colors.transparent, 
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Logo.jpg',
                  width: 300, 
                  height: 300, 
                  fit: BoxFit.cover, 
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Testo grande
            Text(
              'CineCult',
              style: TextStyle(
                fontSize: 100, 
                fontWeight: FontWeight.bold, 
                color: Colors.red[300],
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
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), 
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30), 
                elevation: 5, 
              ),
              child: const Text(
                'CONTINUA',
                style: TextStyle(fontSize: 27),
                
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _changeQuote, 
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.transparent, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _quotes[_currentQuoteIndex]['quote']!,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white, 
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '- ${_quotes[_currentQuoteIndex]['author']}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
