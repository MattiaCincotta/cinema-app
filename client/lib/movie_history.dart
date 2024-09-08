import 'package:flutter/material.dart';

class MovieHistoryPage extends StatefulWidget {
  const MovieHistoryPage({super.key});

  @override
  State<MovieHistoryPage> createState() => _MovieHistoryPageState();
}

class _MovieHistoryPageState extends State<MovieHistoryPage> {
  int _favoriteCount = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Film Visti',
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
                  Icons.movie,
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
                    setState(() {
                      _showSearchBar = !_showSearchBar;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            if (_showSearchBar)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cerca film...',
                    hintStyle: const TextStyle(
                      color: Colors.white54, 
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          color: Colors.white), 
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white, 
                      ),
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    print('Ricerca per: $value');
                  },
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    createCard(
                      'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg',
                      'La storia della principessa splendente e delle sue avventure straordinarie',
                    ),
                    createCard(
                      'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg',
                      'Un altro film con un titolo molto lungo che si estende per diverse righe',
                    ),
                    createCard(
                      'https://www.agireora.org/img/news/pollo-bianco-primo-piano.jpg',
                      'La storia della principessa splendente',
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

  Widget createCard(String imageUrl, String filmName) {
    bool isChecked = true;

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
                  overflow: TextOverflow.ellipsis,
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
                          isChecked = !isChecked;
                          if (isChecked) {
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
                          boxShadow: isChecked
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
                          isChecked
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.lightBlue,
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
}
