import 'package:client/utils/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RequestManager {
  final String baseUrl;

  RequestManager({required this.baseUrl});

///////////////////////////////// SEARCH DIRECTOR /////////////////////////////////
  Future<Director?> searchDirector(String directorName) async {
    String endpoint = '/search/director';
    final Uri url = Uri.parse('$baseUrl$endpoint?name=$directorName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return Director(
            id: result['id'],
            name: result['name'],
            imageUrl: result['image_url']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

///////////////////////////////// SEARCH MOVIE /////////////////////////////////
  Future<Map<String, dynamic>?> searchMovie(String movieName) async {
    String endpoint = '/search/movie';
    final Uri url = Uri.parse('$baseUrl$endpoint?name=$movieName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> getDirectors() async {
    String endpoint = '/directors';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

///////////////////////////////// GET DIRECTOR BIOGRAPHY /////////////////////////////////
  Future<String?> getDirectorBiography(int id) async {
    String endpoint = '/director/$id/biography';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result['biography'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

////////////////////////////// GET DIRECTOR CATEGORY //////////////////////////////
  Future<Map<String, dynamic>?> getDirectorCategory(List<int> listID) async {
    String endpoint = '/directors/category';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw 'Token non trovato';
      }

      final body = jsonEncode({'category': listID});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  ///////////////////////////////// GET DIRECTOR MOVIES /////////////////////////////////
  Future<dynamic> getDirectorMovies(String director) async {
    String endpoint = '/director/movies';
    final Uri url = Uri.parse('$baseUrl$endpoint?director=$director');
    const storage = FlutterSecureStorage();

    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  ///////////////////////////////// GET FAVORITES FILM /////////////////////////////////
  Future<dynamic> getFavorites() async {
    String endpoint = '/favorites';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  ///////////////////////////////// GET FAVORITE FILM BY TITLE /////////////////////////////////
  Future<bool> isFavorite(int id) async {
    String endpoint = '/favorites';
    final Uri url = Uri.parse('$baseUrl$endpoint?id=$id');
    const storage = FlutterSecureStorage();
    print('URI: $url');
    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        
        return response.body.toString().contains('true');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  ///////////////////////////////// ADD FAVORITE FILM /////////////////////////////////
  Future<dynamic> addFavorite(String title) async {
    String endpoint = '/add_favorite';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw 'Token non trovato';
      }

      final body = jsonEncode({'title': title});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  ///////////////////////////////// REMOVE FAVORITE FILM /////////////////////////////////
  Future<dynamic> removeFavorite(String title) async {
    String endpoint = '/remove_favorite';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw 'Token non trovato';
      }

      final body = jsonEncode({'title': title});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  ///////////////////////////////// GET SEEN MOVIES /////////////////////////////////
  Future<dynamic> getSeenMovies() async {
    String endpoint = '/seen_movies';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        print('film visti: $result');
        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  ///////////////////////////////// GET SEEN MOVIE BY ID /////////////////////////////////
  Future<bool> isSeen(int id) async {
    String endpoint = '/seen_movies';
    final Uri url = Uri.parse('$baseUrl$endpoint?id=$id');
    const storage = FlutterSecureStorage();
    print('URI: $url');
    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        print('server response IsSeen: ${response.body.toString().contains('true')}');
        return response.body.toString().contains('true');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  ///////////////////////////////// ADD SEEN FILM /////////////////////////////////
  Future<dynamic> addSeenMovies(String title) async {
    String endpoint = '/add_seen';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw 'Token non trovato';
      }

      final body = jsonEncode({'title': title});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  ///////////////////////////////// ADD SEEN FILM /////////////////////////////////
  Future<dynamic> removeSeenMovies(String title) async {
    String endpoint = '/remove_seen';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw 'Token non trovato';
      }

      final body = jsonEncode({'title': title});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "token": token,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  ///////////////////////////////// SEARCH DIRECTOR BY CATEGORY /////////////////////////////////
  Future<dynamic> searchDirectorByCategory(String categoryID) async {
    String endpoint = '/directors/category';
    final Uri url = Uri.parse('$baseUrl$endpoint?category=$categoryID');
    const storage = FlutterSecureStorage();

    try {
      final response = await http
          .get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final dynamic result = json.decode(response.body);

        return result;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

///////////////////////////////// LOGIN /////////////////////////////////
  Future<bool> login(String username, String password) async {
    String endpoint = '/login';
    final Uri url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      const storage = FlutterSecureStorage();
      final responseData = json.decode(response.body);
      await storage.write(key: 'token', value: responseData['token']);

      return true;
    } else {
      return false;
    }
  }

///////////////////////////////// REGISTER /////////////////////////////////
  Future<bool> register(String username, String password) async {
    String endpoint = '/register';
    final Uri url = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      const storage = FlutterSecureStorage();
      final responseData = json.decode(response.body);
      await storage.write(key: 'token', value: responseData['token']);

      return true;
    } else {
      return false;
    }
  }
}
