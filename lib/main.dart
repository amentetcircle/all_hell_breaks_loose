import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.deepPurple[100],
    canvasColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple[100],
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
    ),
  );
  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurpleAccent[100],
    canvasColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple[100],
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Session Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Have a nice session'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _controllerTimer;
  bool _timerOn = false;
  final TextEditingController _textFieldController = TextEditingController();
  final List<Map<String, dynamic>> _allCauses = [
    {"error": "Luisa Vocalmic stops working", "solved": false},
    {"error": "IEM Luisa stops working", "solved": false},
    {"error": "IEM Jendrik stops working", "solved": false},
    {"error": "IEM Finn stops working", "solved": false},
    {"error": "IEM Axel stops working", "solved": false},
    {"error": "IEM Freddy stops working", "solved": false},
    {"error": "MacBook stops playing", "solved": false},
    {"error": "Freddy moves 1 beat", "solved": false},
    {"error": "guitar Finn stops working", "solved": false},
    {"error": "guitar Jendrik stops working", "solved": false},
    {"error": "guitar Axel stops working", "solved": false}
  ];
  late List<Map<String, dynamic>> _causes;
  Map<String, dynamic>? _currentCause;
  bool _iemUsed = false;
  bool _guitarUsed = false;
  final TextStyle _textStyle = TextStyle(color: Colors.grey[100]);

  void _startTimer() {
    _causes.clear();

    for (final element in _allCauses) {
      if (element["error"].toString().contains("IEM")) {
        if (!_iemUsed) {
          print("_causes.add(iem)");
          _causes.add(element);
        }
      } else if (element["error"].toString().contains("guitar")) {
        if (!_guitarUsed) {
          print("_causes.add(guitar)");
          _causes.add(element);
        }
      } else {
        _causes.add(element);
      }
    }
    print(_causes.length);

    setState(() {
      _timerOn = true;
      _controllerTimer.forward();
    });
    _showCause();
  }

  void _pauseTimer() {
    setState(() {
      _timerOn = false;
      _controllerTimer.stop();
    });
  }

  Future<void> _showCause() async {
    int length = _causes.length;
    print(length);
    // Wait at least 10 minutes (600 seconds) but up to 20 minutes (1200 seconds).
    int waitTime = 600 + Random().nextInt(601);
    print(waitTime / 60);

    var nextCause = _causes[Random().nextInt(length)];
    print("next cause: ${nextCause["error"]}");

    await Future.delayed(Duration(seconds: waitTime));

    setState(() {
      if (nextCause["error"].contains("IEM")) {
        print("iem true");
        _iemUsed = true;
      }
      if (nextCause["error"].contains("guitar")) {
        print("guitar true");
        _guitarUsed = true;
      }
      _currentCause = nextCause;
    });
  }

  void _solveProblem() {
    setState(() {
      _currentCause = null;
    });
    _startTimer();
  }

  Future<void> _showChangeDialog(BuildContext context) async {
    String valueText = "";
    _textFieldController.text = "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New error:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'new error'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _allCauses.add({"error": valueText, "solved": false});
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    _controllerTimer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _causes = [..._allCauses];
    _controllerTimer = AnimationController(
        vsync: this, duration: const Duration(seconds: 2700));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _currentCause == null ? "" : _currentCause?["error"],
              style: _textStyle,
            ),
            const SizedBox(
              height: 50.0,
            ),
            TimerAnimation(
              animation: StepTween(
                begin: 2700,
                end: 0,
              ).animate(_controllerTimer),
              textStyle: _textStyle,
            ),
            const SizedBox(
              height: 25.0,
            ),
            _currentCause == null
                ? TextButton(
                    onPressed: _timerOn ? _pauseTimer : _startTimer,
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 24),
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary)),
                    ),
                    child: _timerOn ? const Text("pause") : const Text("start"),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _timerOn
                            ? _pauseTimer
                            : () {
                                _startTimer();
                                _showCause();
                              },
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 24),
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer)),
                        ),
                        child: _timerOn
                            ? const Text("pause")
                            : const Text("start"),
                      ),
                      TextButton(
                        onPressed: _solveProblem,
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 24),
                          elevation: 10.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer)),
                        ),
                        child: const Text("solved"),
                      )
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButton: !_timerOn
          ? FloatingActionButton(
              elevation: 10,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              tooltip: "add causes",
              onPressed: () {
                _showChangeDialog(context);
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
    );
  }
}

class TimerAnimation extends AnimatedWidget {
  const TimerAnimation(
      {super.key, required this.animation, required this.textStyle})
      : super(listenable: animation);
  final Animation<int> animation;
  final TextStyle textStyle;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    String timerText = printDuration(clockTimer);

    return Text(
      timerText,
      style: textStyle,
    );
  }
}
