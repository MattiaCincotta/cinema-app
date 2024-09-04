import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:client/utils/encrypt.dart';
import 'directorlist.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;
  bool _isObscure = true;
  String _errorMessage = '';
  bool _isSnackBarActive = false;

  Future<bool> _login() async {
    const storage = FlutterSecureStorage();
    if(await storage.read(key: 'remember') == 'true') {
      return true;
    }

    List<int> bytes = utf8.encode(_passwordController.text);
    String hash = sha256.convert(bytes).toString();

    bool isValid = (await storage.read(key: 'username') == _usernameController.text) &&
                   (hash == await storage.read(key: 'password'));

    return isValid;
  }

  void _handleLogin() async {
  const storage = FlutterSecureStorage();

  bool loginSuccess = await _login();
  if (loginSuccess) {
    await (await storage.read(key: 'remember') == 'true'
      ? Cryptography.setUpKeyFromHash((await storage.read(key: 'key'))!)
      : Cryptography.setUpKey(_passwordController.text));

    if (File(await Cryptography.getEncryptedFile()).existsSync()) {
      await Cryptography().decryptFile();
    }

    if (_isChecked) {
      await storage.write(key: 'remember', value: 'true');
      await storage.write(key: 'key', value: md5.convert(utf8.encode(_passwordController.text)).toString());
    } else {
      await storage.write(key: 'remember', value: 'false');
      await storage.write(key: 'key', value: null);
    }

    await storage.write(key: 'logged', value: 'true');


    if (mounted) {
      Navigator.pushNamed(context, '/chat');
    }
  } else {
    if (mounted) {
      setState(() {
        _errorMessage = 'Credenziali non valide';
        _showSnackBar();
      });
    }
  }
}


  void _showSnackBar() {
    if (!_isSnackBarActive && _errorMessage.isNotEmpty) {
      _isSnackBarActive = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage, style: const TextStyle(fontSize: 18.0)),
          duration: const Duration(seconds: 2),
          onVisible: () {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                _isSnackBarActive = false;
                _errorMessage = '';
              });
            });
          },
        ),
      );
    }
  }

  @override
  void initState() {
    const storage = FlutterSecureStorage();
    storage.read(key: 'remember').then((value) => {
      if(value == 'true'){
        _handleLogin()
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false,
  title: Row(
    children: [
      Icon(Icons.movie, color: Colors.red[300]), // Icona cinematografica
      const SizedBox(width: 10),
      const Text(
        'Benvenuto su CineCult',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  foregroundColor: Colors.white,
  backgroundColor: Colors.black87, 
  elevation: 10, // Ombreggiatura
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.grey[900]!, Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
),

      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                ClipOval(
                  child: Image.asset(
                    'assets/images/profile.jpg',
                    width: 275,
                    height: 275,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Accesso',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    controller: _usernameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    obscureText: _isObscure,
                    controller: _passwordController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
SizedBox(
  width: 300.0,
  child: Row(
    children: [
      InkWell(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked; // Cambia lo stato della checkbox
          });
        },
        borderRadius: BorderRadius.circular(15), // Bordo arrotondato per l'effetto splash
        splashColor: Colors.blueGrey[200], // Colore dell'effetto splash
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
          child: Row(
            children: [
              const Text(
                'Ricordami',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0), // Spazio ridotto a sinistra della checkbox
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: Colors.blueGrey[300], // Colore del bordo quando non selezionato
                  ),
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    activeColor: Colors.blueGrey[500], // Colore di sfondo quando selezionato, più scuro
                    checkColor: Colors.white, // Colore del segno di spunta
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Angoli arrotondati
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5.0), // Spazio tra checkbox e testo
            ],
          ),
        ),
      ),
      const SizedBox(width: 19.0), // Spazio fisso tra "Ricordami" e "Registrati"
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/registration');
        },
        borderRadius: BorderRadius.circular(15), // Bordo arrotondato per l'effetto splash
        splashColor: Colors.blueGrey[200], // Colore dell'effetto splash
        child: Container(
          width: 135.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey[700], // Colore di sfondo del pulsante
            borderRadius: BorderRadius.circular(15), // Bordo arrotondato
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                'Registrati',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(width: 10.0),
               Icon(
                Icons.arrow_forward, // Freccia a destra
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),






                const SizedBox(height: 30),
                SizedBox(
                  width: 180.0,
                  height: 65.0,
                  child: ElevatedButton(
                    onPressed: /*_handleLogin*/ () {      // TODO rimettere la cosa commentata e togliere il navigator.push una volta collegato il backend 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DirectionListPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Accedi',
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
