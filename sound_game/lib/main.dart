import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String draggedImage = "";
  String soundPlayed = "";
  final audioPlayer = AudioPlayer();

  bool isGamePlaying = false;
  Random random = Random();
  Timer? timer;

  int numberOfTries = 0;
  int score = 0;
  int numberOfWrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      _startGame();
    });
  }

  Future setAudio(String soundName) async {
    audioPlayer.setReleaseMode(ReleaseMode.release);
    final player = AudioCache(prefix: "assets/sound/");
    final url = await player.load(soundName);
    await audioPlayer.setSourceUrl(url.toString());
    await audioPlayer.resume();
    soundPlayed = soundName;
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer?.cancel();
    }
    audioPlayer.dispose();
  }

  _stopGame() {
    timer?.cancel();
    numberOfTries = 0;
    score = 0;
    if (mounted) {
      setState(() {});
    }
  }

  _startGame() {
    if (!isGamePlaying) {
      isGamePlaying = true;
      score = 0;
      numberOfTries = 0;
      int randomNumber = random.nextInt(9) + 1;
      setAudio("$randomNumber.mp3");
      numberOfTries++;
      timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
        // if(numberOfTries <= 4) {
        numberOfTries++;
        _nextSound();
        // }else{

        // }
      });
    }
  }

  _nextSound() {
    int randomNumber = random.nextInt(9) + 1;
    setAudio("$randomNumber.mp3");
    draggedImage = "";
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.purple[100],
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            _startGame();
                          },
                          icon: Icon(
                            Icons.mic,
                          )),
                      IconButton(
                          onPressed: () {
                            _nextSound();
                          },
                          icon: Icon(
                            Icons.refresh,
                          )),
                    ],
                  ),
                  Text("Score: $score")
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: DragTarget<String>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey.withOpacity(0.5),
                      child: draggedImage.isNotEmpty
                          ? Image.asset(
                              "assets/images/$draggedImage.png",
                              width: 100,
                              height: 100,
                            )
                          : Container(),
                    );
                  },
                  onWillAccept: (data) {
                    return data == '1' ||
                        data == "2" ||
                        data == "3" ||
                        data == "4" ||
                        data == "5" ||
                        data == "6" ||
                        data == "7" ||
                        data == "8" ||
                        data == "9";
                  },
                  onAccept: (data) {
                    switch (data) {
                      case "1":
                        draggedImage = "black_01";
                        break;
                      case "2":
                        draggedImage = "brown_02";
                        break;
                      case "3":
                        draggedImage = "blue_03";
                        break;
                      case "4":
                        draggedImage = "green_04";
                        break;
                      case "5":
                        draggedImage = "orange_05";
                        break;
                      case "6":
                        draggedImage = "pink_06";
                        break;
                      case "7":
                        draggedImage = "red_07";
                        break;
                      case "8":
                        draggedImage = "white_08";
                        break;
                      case "9":
                        draggedImage = "yellow_09";
                        break;
                    }
                    if (data == soundPlayed.replaceAll(".mp3", "")) {
                      score++;
                      //  Correct answer....
                      setAudio("correct_answer.mp3");
                    } else {
                      if (score > 0) {
                        score--;
                      }
                      numberOfWrongAnswers++;
                      //  Wrong answer....
                      setAudio("wrong_answer.mp3");
                    }
                    if (numberOfWrongAnswers == 5) {
                      isGamePlaying = false;
                      draggedImage = "";
                      _stopGame();
                    }
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Draggable<String>(
                      data: '1',
                      child: Image.asset(
                        "assets/images/black_01.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/black_01.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Draggable<String>(
                      data: '2',
                      child: Image.asset(
                        "assets/images/brown_02.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/brown_02.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Draggable<String>(
                      data: '3',
                      child: Image.asset(
                        "assets/images/blue_03.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/blue_03.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Draggable<String>(
                      data: '4',
                      child: Image.asset(
                        "assets/images/green_04.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/green_04.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Draggable<String>(
                      data: '5',
                      child: Image.asset(
                        "assets/images/orange_05.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/orange_05.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Draggable<String>(
                      data: '6',
                      child: Image.asset(
                        "assets/images/pink_06.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/pink_06.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Draggable<String>(
                      data: '7',
                      child: Image.asset(
                        "assets/images/red_07.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/red_07.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Draggable<String>(
                      data: '8',
                      child: Image.asset(
                        "assets/images/white_08.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/white_08.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Draggable<String>(
                      data: '9',
                      child: Image.asset(
                        "assets/images/yellow_09.png",
                        height: 70,
                      ),
                      feedback: Image.asset(
                        "assets/images/yellow_09.png",
                        height: 70,
                      ),
                      childWhenDragging: Container(
                        height: 70.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
