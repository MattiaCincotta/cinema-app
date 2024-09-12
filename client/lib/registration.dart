import 'package:flutter/material.dart';
import 'package:client/utils/request_manager.dart';

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
  bool _isUsernameInteracted = false;
  bool _isPassword1Valid = false;
  bool _isPassword1Interacted = false;
  bool _isPassword2Interacted = false;

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
      _showSnackBar('Registrazione non riuscita');
      return;
    }

    RequestManager mgr = RequestManager(baseUrl: 'http://172.18.0.3:5000');
    if (!(await mgr.register(_username.text, _password1.text))) {
      _showSnackBar('utente già registrato');
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/login');
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
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
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
            fontSize: 18.0,
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
        title: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.red[300],
              size: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              'Benvenuto! Crea il tuo account ',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
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
                  'Registrazione',
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
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
                    onChanged: (value) {
                      _validateUsername(value);
                    },
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
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
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
                const SizedBox(height: 10),
                Visibility(
                  visible: _isPassword1Interacted &&
                      (!_isPassword1Valid || !_isObscure),
                  child: const Text(
                    '8+ caratteri, lettere e numeri',
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
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
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
                const SizedBox(height: 10),
                Visibility(
                  visible: _isPassword2Interacted &&
                      _password1.text != _password2.text,
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
                  width: 200.0,
                  height: 65.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _register();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Registrati',
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
