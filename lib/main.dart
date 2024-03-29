import 'package:flutter/material.dart';
import 'package:tubes_mdp/screens/home.dart';
import 'package:tubes_mdp/screens/detail.dart';
import 'package:tubes_mdp/screens/splashscreen.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sad',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(),
        '/home': (context) => const HomePage(),
        '/detail': (context) => const DetailPage(item: 0, title: ''),
      },
    );
  }
}
