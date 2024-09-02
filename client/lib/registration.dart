import 'package:flutter/material.dart';
// Aggiunto per usare TextInputFormatter
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Registrationpage extends StatefulWidget {
  const Registrationpage({super.key});

  @override
  State<Registrationpage> createState() => _RegistrationpageState();
}

class _RegistrationpageState extends State<Registrationpage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  bool _isObscure = true;
  bool _isUsernameNotEmpty = false;
  bool _isUsernameInteracted = false; // Stato per verificare se l'utente ha interagito con lo username
  bool _isPassword1Valid = false; // Stato per verificare se la password1 è valida
  bool _isPassword1Interacted = false; // Stato per verificare se l'utente ha interagito con la password1
  bool _isPassword2Interacted = false; // Stato per verificare se l'utente ha interagito con la password2

  @override
  void initState() {
    super.initState();
    _isUsernameNotEmpty = _username.text.isNotEmpty;
    _isPassword1Valid = _validatePassword1(_password1.text);
    _username.addListener(_onUsernameChange);
    _password1.addListener(_onPassword1Change);
    _password2.addListener(_onPassword2Change);
  }

  @override
  void dispose() {
    _username.removeListener(_onUsernameChange);
    _password1.removeListener(_onPassword1Change);
    _password2.removeListener(_onPassword2Change);
    super.dispose();
  }

  void _onUsernameChange() {
    setState(() {
      _isUsernameInteracted = true;
      _isUsernameNotEmpty = _username.text.isNotEmpty;
    });
  }

  void _onPassword1Change() {
    setState(() {
      _isPassword1Interacted = true;
      _isPassword1Valid = _validatePassword1(_password1.text);
    });
  }

  void _onPassword2Change() {
    setState(() {
      _isPassword2Interacted = true;
    });
  }

  Future<void> _register() async {
  bool isValid = _validateInputs();

  if (!isValid) {
    _showSnackBar('Registrazione non riuscita'); // Corretto il messaggio
    return;
  }

  List<int> bytes = utf8.encode(_password1.text);
  String hash = sha256.convert(bytes).toString();

  const storage = FlutterSecureStorage();
  await storage.write(key: 'username', value: _username.text);
  await storage.write(key: 'password', value: hash);

  // Verifica se il widget è ancora montato prima di navigare
  if (mounted) {
    Navigator.pushNamed(context, '/login');
  }
}


  bool _validateInputs() {
    bool isUsernameValid = _validateUsername(_username.text);
    bool isPassword1Valid = _validatePassword1(_password1.text);
    bool isPassword2Valid = _validatePassword2();

    return isUsernameValid && isPassword1Valid && isPassword2Valid;
  }

  bool _validateUsername(String username) {
    return username.isNotEmpty;
  }

  bool _validatePassword1(String password) {
    final regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    bool isValid = regex.hasMatch(password);
    return isValid;
  }

  bool _validatePassword2() {
    return _password1.text == _password2.text;
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 18.0, // Aumenta la dimensione del testo
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        foregroundColor: Colors.white,
        backgroundColor:  Colors.grey[900], // Imposta il colore dell'AppBar
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
                  'images/profile.jpg',
                  width: 275, // Larghezza dell'immagine
                  height: 275, // Altezza dell'immagine
                  fit: BoxFit.cover, // Adatta l'immagine per coprire l'area
                ),
              ),
                const SizedBox(height: 25),
                const Text(
                  'Sign Up',
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
                    controller: _username,
                    style: const TextStyle(
                      color: Colors.white, // Colore del testo inserito
                      fontSize: 20, // Dimensione del testo
                      fontFamily: 'Roboto', // Nome del font
                    ),
                    onChanged: (value) {
                      _validateUsername(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        //color: Colors.white, // Colore del testo dell'etichetta
                        fontSize: 20, // Dimensione del testo dell'etichetta
                      ), // Colore del testo dell'etichetta
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Colore del bordo
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple), // Colore del bordo quando il campo è focalizzato
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Colore del bordo quando il campo è abilitato
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _isUsernameInteracted && !_isUsernameNotEmpty,
                  child: const Text(
                    'Username non valido',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    obscureText: _isObscure,
                    style: const TextStyle(
                      color: Colors.white, // Colore del testo inserito
                      fontSize: 20, // Dimensione del testo
                      fontFamily: 'Roboto', // Nome del font
                    ),
                    controller: _password1,
                    onChanged: (_) {
                      setState(() {
                        _isPassword1Interacted = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 18, // Dimensione del testo dell'etichetta
                      ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Colore del bordo
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple), // Colore del bordo quando il campo è focalizzato
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white), // Colore del bordo quando il campo è abilitato
                        ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white, // Colore dell'icona
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
                const SizedBox(height: 10),
                Visibility(
                  visible: _isPassword1Interacted && (!_isPassword1Valid || !_isObscure),
                  child: const Text(
                    'password non valida',
                    style:  TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    obscureText: _isObscure,
                    style: const TextStyle(
                      color: Colors.white, // Colore del testo inserito
                      fontSize: 20, // Dimensione del testo
                      fontFamily: 'Roboto', // Nome del font
                    ),
                    controller: _password2,
                    onChanged: (_) {
                      setState(() {
                        _isPassword2Interacted = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 18, // Dimensione del testo dell'etichetta
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Colore del bordo
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple), // Colore del bordo quando il campo è focalizzato
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // Colore del bordo quando il campo è abilitato
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white, // Colore dell'icona
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
                const SizedBox(height: 10),
                Visibility(
                  visible: _isPassword2Interacted && _password1.text != _password2.text,
                  child: const Text(
                    'password non corrispondente',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 180.0,
                  height: 65.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _register();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600], // Colore di sfondo del bottone
                      foregroundColor: Colors.white, // Colore del testo del bottone
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Bordi stondati
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Spaziatura interna
                      elevation: 5, // Ombra del bottone
                    ),
                    child: const Text(
                      'CONTINUA',
                      style: TextStyle(
                        fontSize: 18, // Dimensione del testo
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
