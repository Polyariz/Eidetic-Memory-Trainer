/* Copyright 2024 Ashraff Hathibelagal
 * Ported to Flutter/Dart 2024
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/saved_data.dart';
import '../models/lang_utils.dart';
import '../services/speaker.dart';
import '../widgets/number_button.dart';
import '../widgets/custom_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int win = 1;
  static const int lose = 0;
  static const int maxValue = 9;
  static const int nRows = 6;
  static const int nCols = 3;

  final List<_ButtonData> buttons = [];
  final List<int> sequence = List.generate(9, (i) => i + 1);

  bool gameStarted = false;
  int expectedNumber = 1;
  late SavedData data;
  late Speaker speaker;
  bool _isInitialized = false;

  DateTime? startTime;
  String additionalSpeech = '';

  Timer? progressTimer;
  int progressValue = 60;
  bool grayscaleEnabled = false;

  Color backgroundColor = const Color(0xFF121212);
  final Color gameBackgroundColor = const Color(0xFF1E1E2F);
  final Color winBackgroundColor = const Color(0xFF00CC66);
  final Color loseBackgroundColor = const Color(0xFFCC3333);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    data = SavedData();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await data.init();
    speaker = Speaker(data);
    setState(() {
      _isInitialized = true;
    });
    resetGrid();
  }

  void startProgressTimer() {
    progressTimer?.cancel();
    progressValue = 60;
    grayscaleEnabled = false;

    progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (progressValue > 0) {
          progressValue--;
        } else {
          grayscaleEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void resetGrid() {
    setState(() {
      backgroundColor = gameBackgroundColor;
      startTime = DateTime.now();
      buttons.clear();
      generateSequence();
      createButtons();
      expectedNumber = 1;
      gameStarted = false;
      additionalSpeech = '';
      progressValue = 60;
      grayscaleEnabled = false;
      startProgressTimer();
    });
  }

  void generateSequence() {
    sequence.shuffle();
  }

  void createButtons() {
    int k = 0;
    List<Point<int>> taken = [];
    Random random = Random();

    while (k < maxValue) {
      for (int i = 0; i < nRows && k < maxValue; i++) {
        for (int j = 0; j < nCols && k < maxValue; j++) {
          if (random.nextDouble() <= 0.5) {
            continue;
          }

          if (taken.any((p) => p.x == i && p.y == j)) {
            continue;
          }

          taken.add(Point(i, j));
          buttons.add(_ButtonData(
            row: i,
            col: j,
            value: sequence[k],
            visible: true,
          ));
          k++;
        }
      }
    }
  }

  String getMappedString(int value) {
    return LangUtils.getTranslation(data.getLanguage(), value);
  }

  void activatePuzzleMode() {
    setState(() {
      for (var button in buttons) {
        button.showQuestion = true;
      }
    });
  }

  Future<void> showRestart(int status) async {
    progressTimer?.cancel();

    if (status == lose) {
      await data.resetStreak();
      await data.resetStars();
    }

    setState(() {
      backgroundColor = status == win ? winBackgroundColor : loseBackgroundColor;
    });

    int timeTaken = DateTime.now().difference(startTime!).inSeconds;
    bool createdRecord = false;
    int previousRecord = data.getFastestTime();

    if (status == win) {
      await data.incrementStreak();
      createdRecord = await data.updateFastestTime(timeTaken);
      updateAdditionalSpeech(createdRecord, timeTaken);
    }

    await data.updateStats(status == win);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: status == win
            ? '🤩 You win!\n🙌 Streak: ${data.getStreak()}'
            : '😖 Game over!',
        message: status == win
            ? (createdRecord
                ? 'New record created!\n\nYou took just $timeTaken seconds.\nYour previous best time was $previousRecord seconds.\n\nReady to play again?'
                : 'You took $timeTaken seconds.\nYour best time was $previousRecord seconds.\n\nReady to play again?')
            : 'Do you want to try again?',
        onPositive: () {
          Navigator.of(context).pop();
          resetGrid();
        },
        onNegative: () {
          Navigator.of(context).pop();
          SystemNavigator.pop();
        },
        onNeutral: status == win
            ? () {
                speaker.say('You win! You completed the task in $timeTaken seconds. $additionalSpeech');
              }
            : null,
        positiveText: 'Yes',
        negativeText: 'No',
        neutralText: 'Speak',
        showNeutral: status == win,
        neutralEnabled: data.areSoundsOn(),
      ),
    );
  }

  void updateAdditionalSpeech(bool createdRecord, int timeTaken) {
    additionalSpeech = '';

    if (createdRecord) {
      additionalSpeech += 'You have created a new record! ';
    }

    int streak = data.getStreak();
    switch (streak) {
      case 5:
        additionalSpeech += 'Five in a row. Cool!';
        break;
      case 10:
        additionalSpeech += 'Ten in a row. That\'s a milestone!';
        break;
      case 25:
        additionalSpeech += 'Twenty five in a row. You seem to have mastered this!';
        break;
    }

    if (timeTaken == 5) {
      additionalSpeech += 'Wow, that was so fast!';
    } else if (timeTaken < 5) {
      additionalSpeech += 'Awesome, that was super fast!';
    }
  }

  void onButtonPressed(int value) async {
    if (!gameStarted && value != expectedNumber) {
      speaker.playErrorTone();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please start with 1'),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    if (value == expectedNumber) {
      setState(() {
        var button = buttons.firstWhere((b) => b.value == value);
        button.visible = false;
      });

      if (!gameStarted) {
        gameStarted = true;
        activatePuzzleMode();
      }

      expectedNumber += 1;
      speaker.playTone(value, false);

      if (expectedNumber == maxValue + 1) {
        speaker.playTone(10, true); // Win tone
        await showRestart(win);
      }
    } else {
      speaker.playTone(0, true); // Error tone

      if (data.getStarsAvailable() > 0) {
        await data.decrementStarsAvailable();
        setState(() {});
      } else {
        await showRestart(lose);
      }
    }
  }

  Future<void> reloadGame() async {
    await data.resetStreak();
    await data.resetStars();
    resetGrid();
  }

  void showChangeLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change language to...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LangUtils.getLanguageNames().asMap().entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              onTap: () async {
                await data.setLanguage(entry.key);
                Navigator.of(context).pop();
                if (!gameStarted) {
                  setState(() {});
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void showStatsDialog() {
    Map<String, int> stats = data.getStats();
    int nGames = stats['N_GAMES'] ?? 0;
    int nWins = stats['N_WON'] ?? 0;
    double winRate = nGames > 0 ? (100.0 * nWins / nGames) : 0.0;
    String statsText = 'Total games played: $nGames\nNumber of wins: $nWins\nWin rate: ${winRate.toStringAsFixed(2)} %';

    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Your stats',
        message: statsText,
        onPositive: () {
          Navigator.of(context).pop();
        },
        positiveText: 'Close',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while initializing
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF5AA1E6),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Eidetic', style: TextStyle(color: Colors.white)),
        actions: [
          if (data.getStarsAvailable() >= 2)
            const Icon(Icons.favorite, color: Colors.red),
          if (data.getStarsAvailable() >= 1)
            const Icon(Icons.favorite, color: Colors.red),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case 'reload':
                  await reloadGame();
                  break;
                case 'language':
                  showChangeLanguageDialog();
                  break;
                case 'stats':
                  showStatsDialog();
                  break;
                case 'sfx':
                  await data.toggleSounds();
                  setState(() {});
                  break;
                case 'difficulty':
                  await data.toggleDifficulty();
                  setState(() {});
                  await reloadGame();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(data.isHardModeOn() ? 'HARD MODE' : 'EASY MODE'),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'reload', child: Text('Reload')),
              const PopupMenuItem(value: 'language', child: Text('Change language')),
              const PopupMenuItem(value: 'stats', child: Text('Stats')),
              PopupMenuItem(
                value: 'sfx',
                child: Text(data.areSoundsOn() ? 'Turn sounds off' : 'Turn sounds on'),
              ),
              PopupMenuItem(
                value: 'difficulty',
                child: Text(data.isHardModeOn() ? 'Turn hard mode off' : 'Turn hard mode on'),
              ),
            ],
          ),
        ],
      ),
      body: ColorFiltered(
        colorFilter: grayscaleEnabled
            ? const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0, 0, 0, 0.5, 0,
              ])
            : const ColorFilter.matrix([
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1, 0, 0,
                0, 0, 0, 1, 0,
              ]),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                backgroundColor,
                backgroundColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progressValue / 60.0,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5AA1E6)),
                minHeight: 4,
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: nCols,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: nRows * nCols,
                  itemBuilder: (context, index) {
                    int row = index ~/ nCols;
                    int col = index % nCols;

                    var buttonData = buttons.where((b) => b.row == row && b.col == col).firstOrNull;

                    if (buttonData == null) {
                      return const SizedBox.shrink();
                    }

                    return NumberButton(
                      value: buttonData.value,
                      displayText: buttonData.showQuestion ? '?' : getMappedString(buttonData.value),
                      onPressed: () => onButtonPressed(buttonData.value),
                      isVisible: buttonData.visible,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    progressTimer?.cancel();
    speaker.releaseResources();
    super.dispose();
  }
}

class _ButtonData {
  final int row;
  final int col;
  final int value;
  bool visible;
  bool showQuestion;

  _ButtonData({
    required this.row,
    required this.col,
    required this.value,
    this.visible = true,
    this.showQuestion = false,
  });
}
