import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: const Text(
            'Tic tac toe!',
            textAlign: TextAlign.center,
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
  Color color = Colors.redAccent;
  List<Color> colors = List<Color>(9);
  List<int> winningCombinations = <int>[];
  bool visibilityButton = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 9; i++) {
      colors[i] = Colors.white;
    }
    visibilityButton = false;
  }

  int numberOfColoredSquares() {
    int count = 0;
    for (int i = 0; i < 9; i++) {
      if (colors[i] != Colors.white) {
        count++;
      }
    }
    return count;
  }

  //check for all possible wining combinations
  bool isGameOver() {
    if (colors[0] == colors[3] && colors[3] == colors[6] && colors[0] != Colors.white) {
      winningCombinations.addAll(<int>[0, 3, 6]);
      return true;
    } else if (colors[1] == colors[4] && colors[4] == colors[7] && colors[1] != Colors.white) {
      winningCombinations.addAll(<int>[1, 4, 7]);
      return true;
    } else if (colors[2] == colors[5] && colors[5] == colors[8] && colors[2] != Colors.white) {
      winningCombinations.addAll(<int>[2, 5, 8]);
      return true;
    } else if (colors[0] == colors[1] && colors[1] == colors[2] && colors[0] != Colors.white) {
      winningCombinations.addAll(<int>[0, 1, 2]);
      return true;
    } else if (colors[3] == colors[4] && colors[4] == colors[5] && colors[3] != Colors.white) {
      winningCombinations.addAll(<int>[3, 4, 5]);
      return true;
    } else if (colors[6] == colors[7] && colors[7] == colors[8] && colors[6] != Colors.white) {
      winningCombinations.addAll(<int>[6, 7, 8]);
      return true;
    } else if (colors[0] == colors[4] && colors[4] == colors[8] && colors[0] != Colors.white) {
      winningCombinations.addAll(<int>[0, 4, 8]);
      return true;
    } else if (colors[2] == colors[4] && colors[4] == colors[6] && colors[2] != Colors.white) {
      winningCombinations.addAll(<int>[2, 4, 6]);
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          GridView.builder(
            itemCount: 9,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return AnimatedContainer(
                onEnd: () {
                  if (isGameOver()) {
                    setState(
                      () {
                        for (int i = 0; i < 9; i++) {
                          if (!winningCombinations.contains(i)) {
                            colors[i] = Colors.white;
                          }
                        }
                        winningCombinations.clear();
                        visibilityButton = true;
                      },
                    );
                  } else if (numberOfColoredSquares() == 9)
                    setState(
                      () {
                        winningCombinations.clear();
                        visibilityButton = true;
                      },
                    );
                },
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                  color: colors[index],
                ),
                child: FlatButton(
                  onPressed: () {
                    setState(
                      () {
                        colors[index] = color;
                        if (color == Colors.redAccent)
                          color = Colors.blueGrey;
                        else
                          color = Colors.redAccent;
                      },
                    );
                  },
                  child: null,
                ),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Visibility(
            visible: visibilityButton,
            child: FlatButton(
              onPressed: () {
                setState(
                  () {
                    for (int i = 0; i < 9; i++) {
                      colors[i] = Colors.white;
                    }
                    visibilityButton = false;
                  },
                );
              },
              child: const Text('Play again!'),
            ),
          ),
        ],
      ),
    );
  }
}
