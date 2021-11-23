import 'package:flutter/material.dart';
import 'package:tubes_mdp/screens/detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tubes_mdp/screens/detail2.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Meme>> shows;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('Meme Cringe')),
      body: Center(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot<List<Meme>> snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(snapshot.data![index].image),
                        ),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].tags),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailFirst(
                                  item: snapshot.data![index].ID,
                                  title: snapshot.data![index].name),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong :('));
            }
            return const CircularProgressIndicator();
          },
          future: shows,
        ),
      ),
    );
  }
}

class Meme {
  final int ID;
  final String bottomText;
  final String image;
  final String name;
  final int rank;
  final String tags;

  Meme({
    required this.ID,
    required this.bottomText,
    required this.image,
    required this.name,
    required this.rank,
    required this.tags
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      ID: json['ID'],
      bottomText: json['bottomText'],
      image: json['image'],
      name: json['name'],
      rank: json['rank'],
      tags: json['tags']
    );
  }
}

Future<List<Meme>> fetchShows() async {
  final response =
      await http.get(Uri.parse('https://alpha-meme-maker.herokuapp.com/2/'));

  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['data'] as List;
    return topShowsJson.map((show) => Meme.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
