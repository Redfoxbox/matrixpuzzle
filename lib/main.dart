import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrixpuzzle/utils.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:matrixpuzzle/ai.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: Puzzle(),
  ));
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Menu'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Level 1'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Puzzle()),
            );
          },
        ),
      ),
    );
  }
}

class Puzzle extends StatelessWidget {
  static final String title = 'Matrix Puzzle';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MainPage(title: title),
      );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class Player {
  static const none = '';
  static const X = 'X';
  static const O = 'O';
  static const U = 'U';
  static const right = "▶️";
  static const left = "◀️";
  static const up = "🔼";
  static const down = "🔽";
  static List<String> decisions = [
    Player.up,
    Player.down,
    Player.right,
    Player.left
  ];
}

class _MainPageState extends State<MainPage> {
  static final countMatrix = 5;
  static final double size = 70;
  String lastMove = Player.none;
  late List<int> last = [0, 0];
  late int step = 1;
  bool start = false;
  late List<List<String>> matrix;
  late List<List<int>> barriers;

  @override
  void initState() {
    super.initState();
    initMatrix();
    setNewPuzzle();
  }

  void initMatrix() {
    setState(() {
      matrix = List.generate(
          countMatrix, (_) => List.generate(countMatrix, (_) => Player.none));
      start = false;
      step = 0;
    });
  }

  void setEmptyFields() {
    setState(() {
      for (var i = 0; i < matrix.length; i++) {
        for (var z = 0; z < matrix.length; z++) {
          if (matrix[i][z] != Player.X) {
            matrix[i][z] = Player.none;
          }
        }
      }
      start = false;
      step = 0;
    });
  }

  void setNewPuzzle() {
    setState(() {
      matrix = List.generate(
          countMatrix, (_) => List.generate(countMatrix, (_) => Player.none));
      matrix = Utils().generateBarrier(matrix, 1);
      start = false;
      step = 0;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xff457EAC),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
            ),
            Container(
                child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Row(children: [])],
                )
              ],
            ))
          ],
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Container(
                        margin: EdgeInsets.all(4),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            setNewPuzzle();
                          },
                          label: Text('New Puzzle'),
                          icon: Icon(Icons.new_label),
                        )),
                    Container(
                        margin: EdgeInsets.all(4),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setEmptyFields();
                          },
                          label: Text('Reset Puzzle'),
                          icon: Icon(Icons.replay_outlined),
                        )),
                    Container(
                        margin: EdgeInsets.all(4),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Menu()),
                            );
                          },
                          label: Text('Levels'),
                          icon: Icon(Icons.menu),
                        ))
                  ])
                ],
              )
            ],
          )
        ], /*
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AI().Solvable(matrix);
          },
          child: const Icon(Icons.navigation),
          backgroundColor: Colors.green,
        ),*/
      );

  Widget buildRow(int x) {
    final values = matrix[x];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Color getFieldColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.blue;
      case Player.U:
        return Colors.blue;
      case Player.X:
        return Colors.red;
      case Player.up:
      case Player.down:
      case Player.left:
      case Player.right:
        return Colors.blue;
      case Player.none:
        return Colors.white;
      default:
        return Colors.blue;
    }
  }

  Widget buildField(int x, int y) {
    var value = matrix[x][y];
    final color = getFieldColor(value);
    if (!Player.decisions.contains(value)) {
      value = "";
    }
    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size, size),
          primary: color,
        ),
        child: Text(value, style: TextStyle(fontSize: 32)),
        onPressed: () => selectField(value, x, y),
      ),
    );
  }

  void selectField(String value, int x, int y) {
    if (matrix[x][y] == Player.none && !start) {
      //final newValue = lastMove == Player.X ? Player.O : Player.X;
      setState(() {
        start = true;
        step = 1;
        matrix[x][y] = step.toString();
        last = [x, y];
        matrix = Utils().setDirections(matrix, step);
      });
    } else if (Player.decisions.contains(value)) {
      setState(() {
        matrix = Utils().setRoad(matrix, x, y, step);
        step++;
        matrix = Utils().setDirections(matrix, step);
      });

      if (Utils().isWinner(matrix)) {
        showEndDialog('You are solved the puzzle, nice work!👍');
      } else if (Utils().isEnd(matrix)) {
        showEndDialog('You are stuck, try again!');
      }
    }
  }

  Future showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text('Press to Restart the Game'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setEmptyFields();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            )
          ],
        ),
      );
}
