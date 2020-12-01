import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Currency converter'),
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double sum = 0;
  String sumSting = '';
  bool isDouble = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                const Image(
                  image: NetworkImage('https://news.bitcoin.com/wp-content/uploads/2020/04/earn-1280x720.jpg'),
                ),
                TextField(
                  onChanged: (String value) {
                    if (double.tryParse(value) != null && value != null) {
                      // check input
                      sum = double.parse(value);
                      isDouble = true;
                    } else
                      isDouble = false;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter the sum you want to convert (in EUR)',
                    errorText: (isDouble == false) ? 'Only digits accepted!' : null,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(
                      () {
                        if (isDouble == false) {
                          sum = 0;
                        }
                        // if pressed, modify the value
                        sumSting = (sum * 4.85).toStringAsFixed(2);
                      },
                    );
                  },
                  child: const Text('CONVERT!'),
                ),
                Text(
                  '$sumSting RON',
                  style: TextStyle(
                    height: 5,
                    fontSize: 40,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
