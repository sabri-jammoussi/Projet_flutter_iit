import 'package:dentiste/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication auth = LocalAuthentication();
  late SharedPreferences prefs;

  bool _loading = false;
  bool _isObscuredPsw = true;
  bool _hasBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheck = await auth.canCheckBiometrics;
    setState(() {
      _hasBiometric = canCheck;
    });
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save login state locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      // Navigate to home
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
      Navigator.pushReplacementNamed(context, '/home');
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/dentist.jpg',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                  if (_hasBiometric)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        iconSize: 60,
                        color: Colors.deepOrangeAccent,
                        icon: Icon(Icons.fingerprint),
                        onPressed: _authenticateWithFingerprint,
                      ),
                    ),
                  TextButton(
                    child: Text("Don't have an account ? ",
                        style: TextStyle(fontSize: 22)),
                    onPressed: () {
                      //_login();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/singup');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _authenticateWithFingerprint() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authentifiez-vous avec votre empreinte digitale',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        // Retrieve saved credentials
        prefs = await SharedPreferences.getInstance();
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');

        if (email != null && password != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          Navigator.pushReplacementNamed(context, '/home');
          setState(() => _hasBiometric = false);
        } else {
          setState(() => _hasBiometric = true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Aucun compte enregistré pour l’empreinte.")),
          );
        }
      }
    } catch (e) {
      print("Fingerprint auth error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de reconnaissance biométrique")),
      );
    }
  }
}
