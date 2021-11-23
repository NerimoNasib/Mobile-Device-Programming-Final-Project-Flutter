import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DetailFirst extends StatefulWidget {
  final int item;
  final String title;
  const DetailFirst({Key? key, required this.item, required this.title});

  @override
  _DetailFirstState createState() => _DetailFirstState();
}

class _DetailFirstState extends State<DetailFirst> {
  late Future<ShowDetail> topAiring;

  @override
  void initState() {
    super.initState();
    topAiring = fetchShowDetail(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xff063970),
      ),
      body: ListView(
        children: [
          FutureBuilder<ShowDetail>(
            future: topAiring,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Center(
                      child: Container(
                        child: Image.network(
                          snapshot.data!.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 10, left: 20, right: 20, top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data!.name}',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '#${snapshot.data!.tags}',
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong :('));
              }
              return Column(
                children: [
                  Center(child: const CircularProgressIndicator()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShowDetail {
  final int ID;
  final String bottomText;
  final String image;
  final String name;
  final int rank;
  final String tags;
  final String detail;

  ShowDetail(
      {required this.ID,
      required this.bottomText,
      required this.image,
      required this.name,
      required this.rank,
      required this.tags,
      required this.detail});
  factory ShowDetail.fromJson(Map<String, dynamic> json) {
    return ShowDetail(
        ID: json['ID'],
        bottomText: json['bottomText'],
        image: json['image'],
        name: json['name'],
        rank: json['rank'],
        tags: json['tags'],
        detail: json['detail']);
  }
}

Future<ShowDetail> fetchShowDetail(id) async {
  final response = await http
      .get(Uri.parse('https://alpha-meme-maker.herokuapp.com/memes/$id/'));
  if (response.statusCode == 200) {
    // var topShowsJson =
    return ShowDetail.fromJson(jsonDecode(response.body)['data']);
    // return topShowsJson.map((show) => ShowDetail.fromJson(show));
  } else {
    throw Exception('Failed to load shows');
  }
}
