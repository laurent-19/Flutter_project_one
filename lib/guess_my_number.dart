import 'dart:math';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Guess  my number'),
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

// function to set a random value for the guess
int setGuess() {
  final Random random = Random();
  return random.nextInt(100);
}

class _MyHomePageState extends State<MyHomePage> {
  String messageText = '';
  int inputGuess;
  bool isInteger = true;

  //controller used for deleting the TextField input text
  final TextEditingController controller = TextEditingController();
  int guess = setGuess();
  bool enableAlert = false;

  //function for the dialog window
  dynamic showAlertDialog(BuildContext context) {
    final Widget okButton = FlatButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context);
        enableAlert = false;
        controller.clear();
      },
    );

    final Widget retryButton = FlatButton(
      child: const Text('Try again'),
      onPressed: () {
        setState(
          () {
            messageText = '';
            guess = setGuess();
            enableAlert = false;
            controller.clear();
          },
        );
        Navigator.pop(context);
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text(
        'You guessed right!',
      ),
      content: Text('It was $guess'),
      actions: <Widget>[
        okButton,
        retryButton,
      ],
    );

    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: 380,
                  child: Text(
                    "I'm thinking of a number between 1 and 100.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),
                Container(
                  width: 380,
                  child: Text(
                    'It is your turn to guess my number!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 4,
                      fontSize: 20,
                      color: Colors.black.withOpacity(1),
                    ),
                  ),
                ),
                Container(
                  width: 280,
                  child: Text(
                    messageText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  width: 350,
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 10,
                        blurRadius: 10,
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Try a number!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 2,
                          fontSize: 30,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Enter your guess',
                          errorText: (isInteger == false) ? 'Only integers accepted!' : null,
                        ),
                        onChanged: (String value) {
                          if (int.tryParse(value) != null && value != null) {
                            // check input
                            inputGuess = int.parse(value);
                            isInteger = true;
                          } else {
                            isInteger = false;
                          }
                        },
                      ),

                      //for spacing
                      const SizedBox(height: 20),

                      RaisedButton(
                        onPressed: () {
                          setState(
                            () {
                              if (isInteger) {
                                if (inputGuess > guess) {
                                  messageText = 'You tried $inputGuess. Try lower!';
                                  controller.clear();
                                } else if (inputGuess < guess) {
                                  messageText = 'You tried $inputGuess. Try higher!';
                                  controller.clear();
                                } else {
                                  messageText = 'You tried $inputGuess. You guessed right!';
                                  enableAlert = true;
                                }
                              }
                              if (enableAlert) {
                                showAlertDialog(context);
                              }
                            },
                          );
                        },
                        child: const Text('Guess'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
