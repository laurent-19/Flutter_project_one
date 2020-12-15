import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Center(
            child: Text(
              'Movies',
            ),
          ),
        ),
        body: MovieStateFull(),
      ),
    );
  }
}

class Movie {
  Movie(this.title, this.image, this.url, this.backgroundMovie, this.rating, this.genres);

  String title, image, url, backgroundMovie;
  double rating;
  List<String> genres;
}

class MovieStateFull extends StatefulWidget {
  @override
  _MovieStateFullState createState() => _MovieStateFullState();
}

class _MovieStateFullState extends State<MovieStateFull> {
  List<Movie> movies, allOfMovies;
  String menuText = 'None';
  final List<String> allOfGenders = <String>[];

  Future<void> getMovies() async {
    final Response response = await get('https://yts.mx/api/v2/list_movies.json?limit=50');
    final Map<String, dynamic> json = jsonDecode(response.body) as Map<String, dynamic>;

    allOfMovies = <Movie>[];

    for (int i = 0; i < 50; i++) {
      final String movieTitle = json['data']['movies'][i]['title'] as String;
      final String movieImage = json['data']['movies'][i]['large_cover_image'] as String;
      final String background = json['data']['movies'][i]['background_image'] as String;
      double rating;
      rating = json['data']['movies'][i]['rating'].toDouble() as double;

      final List<dynamic> dynamicListOfGenders = json['data']['movies'][i]['genres'] as List<dynamic>;
      final List<String> genres = dynamicListOfGenders.cast<String>().toList();
      for (int j = 0; j < genres.length; j++) {
        if (!allOfGenders.contains(genres[j])) {
          allOfGenders.add(genres[j]);
        }
      }
      final String urlMovie = json['data']['movies'][i]['urlMovie'].toString();
      allOfMovies.add(Movie(movieTitle, movieImage, urlMovie, background, rating, genres));
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      allOfGenders.add('None');
      allOfGenders.add('Rating Up');
      allOfGenders.add('Rating Down');
      getMovies();
    });

    Future<void>.delayed(const Duration(seconds: 5), () {
      setState(() {
        //update movieList
        movies = allOfMovies;
      });
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void filter(String filterChoice) {
    setState(() {
      if (filterChoice.contains('Rating')) {
        if (filterChoice.contains('Up')) {
          movies = allOfMovies.toList();
          movies.sort((Movie a, Movie b) => a.rating.compareTo(b.rating));
        } else {
          movies = allOfMovies.toList();
          movies.sort((Movie a, Movie b) => b.rating.compareTo(a.rating));
        }
      } else if (filterChoice != 'None') {
        movies = allOfMovies.where((Movie element) => element.genres.contains(filterChoice)).toList();
      } else {
        movies = allOfMovies;
      }
    });
  }

  String getMovieHeadTitle(int index) {
    if (movies == null)
      return 'Almost there..';
    else
      return movies[index].title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          DropdownButton<String>(
            value: menuText,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 30,
            elevation: 20,
            style: const TextStyle(color: Colors.blueGrey),
            underline: Container(
              height: 5,
              color: Colors.blueGrey,
            ),
            onChanged: (String value) {
              setState(() {
                menuText = value;
                filter(menuText);
              });
            },
            items: allOfGenders.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: movies == null ? 20 : movies.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(4.0),
                color: Colors.black,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    if (movies == null)
                      const CircularProgressIndicator()
                    else
                      Image.network(
                        movies[index].backgroundMovie,
                        fit: BoxFit.fitHeight,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            getMovieHeadTitle(index),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.blueGrey,
                              backgroundColor: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: movies == null
                                ? const CircularProgressIndicator()
                                : Image.network(
                                    movies[index].image,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _launchURL(movies == null ? '' : movies[index].url);
                      },
                      child: null,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
