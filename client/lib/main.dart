import 'package:client/login.dart';
import 'package:client/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'homepage.dart';
import 'directorlist.dart';
import 'favoritefilm.dart';
import 'filmpage.dart';

void main() async {

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
        '/directorList': (context) => const DirectionListPage(),
        '/favoritefilm': (context) => const FavoriteFilmPage(),
        '/filmpage': (context) => const FilmPage(),
      },
    );
  }
}