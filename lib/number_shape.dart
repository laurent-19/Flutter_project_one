import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Number Shapes'),
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

bool isPerfectSquare(int n) {
  for (int i = 1; i * i <= n; i++) {
    if ((n % i == 0) && (n / i == i)) {
      return true;
    }
  }
  return false;
}

bool isPerfectCube(int n) {
  int cube;
  for (int i = 1; i <= n; i++) {
    cube = i * i * i;
    if (cube == n) {
      return true;
    } else {
      return false;
    }
  }
  return false;
}

class _MyHomePageState extends State<MyHomePage> {
  int inputNumber = 0;
  bool isInteger = true;
  String messageAlert = '';
  final TextEditingController controller = TextEditingController();

  //function for the dialog window
  dynamic showAlertDialog(BuildContext context) {
    final Widget closeButton = FlatButton(
      child: const Text('Close'),
      onPressed: () {
        setState(
          () {
            controller.clear();
          },
        );
        Navigator.pop(context);
      },
    );

    final Widget alert = AlertDialog(
      title: Text(
        '$inputNumber',
      ),
      content: Text(messageAlert),
      actions: <Widget>[
        closeButton,
      ],
    );

    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                const Text(
                  'Please input a number to see if it is a square or a triangular',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    height: 2,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter a number',
                    errorText: (isInteger == false) ? 'Only integers accepted!' : null,
                  ),
                  onChanged: (String value) {
                    if (int.tryParse(value) != null && value != null) {
                      // check input
                      inputNumber = int.parse(value);
                      isInteger = true;
                    } else {
                      isInteger = false;
                    }
                  },
                ),
                const SizedBox(height: 370),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 15),
                  child: FloatingActionButton(
                    child: const Icon(Icons.check),
                    onPressed: () {
                      setState(
                        () {
                          if (isPerfectSquare(inputNumber) && isPerfectCube(inputNumber)) {
                            messageAlert = 'Number $inputNumber is both SQUARE and TRIANGULAR';
                            print(messageAlert);
                          } else if (isPerfectSquare(inputNumber)) {
                            messageAlert = 'Number $inputNumber is a SQUARE';
                          } else if (isPerfectCube(inputNumber)) {
                            messageAlert = 'Number $inputNumber is a TRIANGULAR';
                          } else {
                            messageAlert = 'Number $inputNumber is neither a SQUARE or TRIANGULAR';
                          }
                          //check if input is okay and return alert
                          if (isInteger) {
                            showAlertDialog(context);
                          }
                        },
                      );
                    },
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
