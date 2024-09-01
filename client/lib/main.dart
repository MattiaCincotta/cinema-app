import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(CinemaApp());
}

class CinemaApp extends StatefulWidget {
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
        '/homepage': (context) => const CinemaAppHomepage()
        //'/login': (context) => const LoginPage(),
      },
    );
  }
}