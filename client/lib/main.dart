import 'package:client/login.dart';
import 'package:client/registration.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'directorlist.dart';
import 'favoritefilm.dart';
import 'filmpage.dart';
void main() {
  runApp(const CinemaApp());
}

class CinemaApp extends StatefulWidget {
  const CinemaApp({super.key});

  @override
  State<CinemaApp> createState() => _CinemaAppState();
}

class _CinemaAppState extends State<CinemaApp> {
  @override
  void initState() {
    super.initState();
}

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/homepage',
      routes: {
        '/homepage': (context) => const CinemaAppHomepage(),
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const Registrationpage(),
        '/directorList.dart': (context) => const DirectionListPage(),
        '/favoritefilm.dart': (context) => const FavoriteFilmPage(),
        '/filmpage.dart': (context) => const FilmPage(),
      },
    );
  }
}