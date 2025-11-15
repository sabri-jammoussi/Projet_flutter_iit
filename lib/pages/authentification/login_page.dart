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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _localAuth = LocalAuthentication();
  late SharedPreferences prefs;

  bool _loading = false;
  bool _hasBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    setState(() => _hasBiometric = canCheck);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Veuillez entrer votre email et mot de passe');
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _showSnack(e.code == 'user-not-found'
          ? 'Aucun utilisateur trouvé'
          : e.code == 'wrong-password'
              ? 'Mot de passe incorrect'
              : 'Échec de la connexion');
    } catch (_) {
      _showSnack('Erreur inconnue. Veuillez réessayer.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _authenticateWithFingerprint() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authentifiez-vous avec votre empreinte digitale',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email');
        final password = prefs.getString('password');

        if (email != null && password != null) {
          await _auth.signInWithEmailAndPassword(email: email, password: password);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showSnack("Aucun compte enregistré pour l’empreinte.");
        }
      }
    } catch (_) {
      _showSnack("Erreur de reconnaissance biométrique");
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/dentist.jpg', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Bienvenue 🦷',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        decoration: _inputDecoration('Email', Icons.email),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: _inputDecoration('Mot de passe', Icons.lock),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Se connecter', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      if (_hasBiometric)
                        IconButton(
                          icon: const Icon(Icons.fingerprint, size: 40, color: Colors.deepOrangeAccent),
                          onPressed: _authenticateWithFingerprint,
                        ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/singup'),
                        child: const Text("Créer un compte", style: TextStyle(color: Colors.teal)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
