import 'package:flutter/material.dart';

class FavoriteFilmPage extends StatefulWidget {
  const FavoriteFilmPage({super.key});

  @override
  State<FavoriteFilmPage> createState() => _FavoriteFilmPageState();
}

class _FavoriteFilmPageState extends State<FavoriteFilmPage> {
  int _favoriteCount = 0; 

  Widget createImageWithIcon(String imageUrl, String filmName) {
    bool isFavorite = false; 

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5, 
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
                  maxLines: 2, 
                  overflow: TextOverflow
                      .ellipsis,
                ),
                const SizedBox(height: 15),
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 275,
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
                          size: 45, 
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
                context); 
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
                    '$_favoriteCount',
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
                'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg', 
                'La storia della principessa splendente e delle sue avventure straordinarie',
              ),
              createImageWithIcon(
                'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg',
                'Un altro film con un titolo molto lungo che si estende per diverse righe',
              ),
              createImageWithIcon(
                'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg', 
                'La storia della principessa splendente',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
