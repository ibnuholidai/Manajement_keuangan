import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manajement_keuangan/homepage/homepage.dart';
import 'package:manajement_keuangan/signpage/sign.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manajement keuangan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: user == null ? LoginPage() : MyHomePage(),
      );
  }
}
