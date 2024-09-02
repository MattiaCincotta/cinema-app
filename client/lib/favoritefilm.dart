import 'package:flutter/material.dart';

class FavoriteFilmPage extends StatefulWidget {
  const FavoriteFilmPage({super.key});

  @override
  State<FavoriteFilmPage> createState() => _FavoriteFilmPageState();
}

class _FavoriteFilmPageState extends State<FavoriteFilmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite film'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
