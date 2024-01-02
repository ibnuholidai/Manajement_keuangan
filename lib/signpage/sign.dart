import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manajement_keuangan/homepage/homepage.dart';

class LoginPage extends StatefulWidget {
  static String routename = "signpage/sign.dart";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _onLogin(LoginData data) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _login() {
    setState(() {
      _isLoading = true;
    });
    // Simulate login request
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(MyHomePage.routename);
    });
  }

    Future<String?> _onRecoverPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
          backgroundColor: Colors.blueAccent,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text('Login',),
              backgroundColor: const Color.fromARGB(255, 103, 80, 164),
            ),
            body: FlutterLogin(
              logo: AssetImage('assets/images/atk.png'),
              title: "CV.MAS",
              onLogin: (loginData) {
                return Future.delayed(loginTime).then((_) {
                  return _onLogin(loginData);
                });
              },
              onSubmitAnimationCompleted: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
              },
              onRecoverPassword: (email) {
                return Future.delayed(loginTime).then((_) {
                  return _onRecoverPassword(email);
                });
              },
              onSignup: (_) => null,
            ),
          );
  }
}
