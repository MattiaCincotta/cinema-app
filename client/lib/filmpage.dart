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
    );
  }
}
