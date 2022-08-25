import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flappy/barriers.dart';
import 'package:flutter_flappy/bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  late int score = 0;
  late int bestScore = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      score += 1;
      initialHeight = birdYaxis;
    });
    if (score >= bestScore) {
      bestScore = score;
    }
  }

  // ignore: non_constant_identifier_names
  bool BirdIsDead() {
    if (birdYaxis > 0.6 || birdYaxis < -0.5) {
      return true;
    } else {
      return false;
    }
  }

  void startGame() {
    gameHasStarted = true;
    score = 0;
    Timer.periodic(const Duration(milliseconds: 40), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
        setState(() {
          if (barrierXone < -1.1) {
            barrierXone += 2.2;
          } else {
            barrierXone -= 0.05;
          }
        });

        if (BirdIsDead()) {
          timer.cancel();
          _showDialog();
        }

        setState(() {
          if (barrierXtwo < -1.1) {
            barrierXtwo += 2.2;
          } else {
            barrierXtwo -= 0.05;
          }
        });
      });
      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  // ignore: unused_element
  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black45,
            title: Center(
              child: Image.asset(
                'assets/images/gameover.png',
                width: 150,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: const Text(
                      ' Start Again ',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.lightBlueAccent,
                    child: const Bird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.99),
                    child: gameHasStarted
                        ? const Text('')
                        : Image.asset(
                            'assets/images/play.png',
                            width: 150,
                          ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.3),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 150,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 250,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Colors.amber,
            ),
            Expanded(
              child: Container(
                color: Colors.lightGreen,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/score.png',
                            width: 60,
                          ),
                          const Text(
                            "Score",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            score.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Image.asset(
                            'assets/images/best.png',
                            width: 60,
                          ),
                          const Text(
                            "Best Score",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            bestScore.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
