import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text('Basic Phrases'),
          ),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache();
  bool soundPlaying = false;

  List<String> soundPaths = <String>[];
  List<String> soundNames = <String>[];
  List<Color> colors = <Color>[Colors.blue, Colors.lightBlueAccent];
  List<double> stops = <double>[0.6, 1.2];

  @override
  void initState() {
    super.initState();
    soundPaths.addAll(
      <String>[
        'Ce_mai_faci.mp3',
        'Comment_ca_va.mp3',
        'La revedere.mp3',
        'Au revoir.mp3',
        'Cum_ajung_la_primarie.mp3',
        'Comment me rendre à la mairie.mp3',
        'Ia-o la dreapta.mp3',
        'Prendre à droite.mp3',
      ],
    );
    soundNames.addAll(
      <String>[
        'Ce mai faci?',
        'Comment ca va?',
        'La revedere!',
        'Au revoir!',
        'Cum ajung la primarie?',
        'Comment me rendre à la mairie?',
        'Ia-o la dreapta!',
        'Prendre à droite!',
      ],
    );
  }

  Future<dynamic> playAudio(String path) async {
    if (soundPlaying == true) {
      audioPlayer.stop();
    }
    audioPlayer = await _audioCache.play(path);
    soundPlaying = true;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(5),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                stops: stops,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FlatButton(
              onPressed: () {
                setState(
                  () {
                    playAudio(soundPaths[index]);
                  },
                );
              },
              child: Text(
                soundNames[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
