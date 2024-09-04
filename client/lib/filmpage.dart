import 'package:flutter/material.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({super.key});

  @override
  State<FilmPage> createState() => __FilmPageStateState();
}

class __FilmPageStateState extends State<FilmPage> {
  bool isFavorite = false;
  //final int _favoriteCount = 0;
  bool isViewed = false;
  //final int _viewCount = 0;

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
        'Nome del regista',
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
    backgroundColor: Colors.grey[900],
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

            Card(
              margin: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        'assets/images/Logo.jpg', 
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16.0),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biografia regista',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Una breve descrizione o un sottotitolo qui.',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            createCardRows(
              [
                createImageWithStar(
                  const AssetImage('assets/images/Logo.jpg'),
                  'La storia della principessa splendente e delle sue avventure straordinarie',
                  '1992',
                ),
                createImageWithStar(
                  const AssetImage('assets/images/Logo.jpg'),
                  'Un altro film con un titolo molto lungo che si estende per diverse righe',
                  '1992',
                ),
                createImageWithStar(
                  const AssetImage('assets/images/Logo.jpg'),
                  'La storia della principessa splendente',
                  '1992',
                ),
                createImageWithStar(
                  const AssetImage('assets/images/Logo.jpg'),
                  'La storia della principessa splendente',
                  '1992',
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget createImageWithStar(
      ImageProvider image, String filmName, String year) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          width: 250.0,
          height: 410.0,
          child: Card(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.0),
            ),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(19.0)),
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    filmName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        year,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isViewed = !isViewed;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isViewed
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: isViewed ? Colors.blue : Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget createCardRows(List<Widget> cards) {
    List<Widget> rows = [];
    for (int i = 0; i < cards.length; i += 2) {
      if (i + 1 < cards.length) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: cards[i]),
              Expanded(child: cards[i + 1]),
            ],
          ),
        );
      } else {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 225.0,
                child: cards[i],
              ),
            ],
          ),
        );
      }
    }
    return Column(children: rows);
  }
}
