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
        return Director(id: result['id'], name: result['name'], imageUrl: result['image_url']);
      } else {
        print('Errore durante la richiesta GET: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta GET: $e');
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
        print('Errore durante la richiesta GET: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta GET: $e');
      return null;
    }
  }

  Future<List<Director>?> getDirectors() async {
    String endpoint = '/directors';
    final Uri url = Uri.parse('$baseUrl$endpoint');
    const storage = FlutterSecureStorage();

    try {
      final response = await http.get(url, headers: {"token": (await storage.read(key: 'token'))!});

      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);

        List<Director> directors = List.empty(growable: true);
        for (var value in result) {
            directors.add(Director(id: value["id"], name: value["name"], imageUrl: value["image_url"]));
        }

        return directors;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

///////////////////////////////// GET DIRECTOR BIOGRAPHY /////////////////////////////////
  Future<String?> getDirectorBiography() async {
    String endpoint = '/director/biography';
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data['biography'] as String?; //specificare il campo
      } else {
        print('Errore durante la richiesta GET: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta GET: $e');
      return null;
    }
  }

///////////////////////////////// GET DIRECTOR CATEGORIE /////////////////////////////////
  Future<String?> getDirectorCategory() async {
    String endpoint = '/director/category';
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data['category'] as String?; //specificare il campo
      } else {
        print('Errore durante la richiesta GET: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta GET: $e');
      return null;
    }
  }

  ///////////////////////////////// GET DIRECTOR MOVIE /////////////////////////////////
  Future<String?> getDirectorMovie() async {
    String endpoint = '/director/movies';
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data['category'] as String?; //specificare il campo
      } else {
        print('Errore durante la richiesta GET: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Errore durante la richiesta GET: $e');
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
      await storage.write(key: 'token',value: responseData['token']);

      print('login riuscito: ${responseData['message']}');
      return true;
    } else {

      print('Errore nel login: ${response.body}');
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

      print(await storage.read(key: "token"));

      print('Registrazione riuscita: ${responseData['token']}');
      return true;
    } else {

      print('Errore nella registrazione: ${response.body}');
      return false; 
    }
  }
}
