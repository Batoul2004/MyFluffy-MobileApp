import 'dart:math';
import 'package:flutter/material.dart';

class FunMathsPage extends StatefulWidget {
  const FunMathsPage({super.key});

  @override
  _FunMathsPageState createState() => _FunMathsPageState();
}

class _FunMathsPageState extends State<FunMathsPage> {
  final List<String> _operations = ['+', '-', '*', '/'];
  late int _currentQuestion;
  late int _score;
  late int _attempts;
  late int _number1;
  late int _number2;
  late String _operation;
  late int _correctAnswer;
  late List<int> _options;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _attempts = 3;
      _generateQuestion();
    });
  }

  void _generateQuestion() {
    _operation = _operations[Random().nextInt(_operations.length)];

    if (_operation == '/') {
      _number2 = Random().nextInt(9) + 1;  // Avoid zero for division
      _number1 = _number2 * (Random().nextInt(10) + 1);  // Ensure number1 is divisible by number2
      _correctAnswer = _number1 ~/ _number2;
    } else {
      _number1 = Random().nextInt(90) + 10;  // Generates a number between 10 and 99
      _number2 = Random().nextInt(90) + 10;  // Generates a number between 10 and 99

      switch (_operation) {
        case '+':
          _correctAnswer = _number1 + _number2;
          break;
        case '-':
          _correctAnswer = _number1 - _number2;
          break;
        case '*':
          _correctAnswer = _number1 * _number2;
          break;
      }
    }

    _options = _generateOptions(_correctAnswer);
  }

  List<int> _generateOptions(int correctAnswer) {
    final options = <int>{correctAnswer};
    while (options.length < 3) {
      options.add(correctAnswer + Random().nextInt(20) - 10);
    }
    return options.toList()..shuffle();
  }

  void _checkAnswer(int selectedOption) {
    setState(() {
      if (selectedOption == _correctAnswer) {
        _score++;
        if (_currentQuestion < 4) {
          _currentQuestion++;
          _generateQuestion();
        } else {
          _showResultDialog(true);
        }
      } else {
        _attempts--;
        if (_attempts == 0) {
          _showResultDialog(false);
        }
      }
    });
  }

  void _showResultDialog(bool isWin) {
    final List<String> happyGifs = [
      'happy.gif', 'happy2.gif', 'happy3.gif',
      'happy4.gif', 'happy5.gif', 'happy6.gif',
      'happy7.gif', 'happy8.gif'
    ];
    final List<String> sadGifs = [
      'lose.gif', 'lose2.gif', 'lose3.gif',
      'lose4.gif'
    ];

    final randomGif = (isWin
      ? happyGifs
      : sadGifs
    )[Random().nextInt(isWin ? happyGifs.length : sadGifs.length)];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isWin ? 'You won!' : 'Game over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isWin ? 'You answered all questions correctly!' : 'You failed to answer the questions correctly.'),
              SizedBox(height: 10),
              Image.asset('assets/$randomGif', width: 100, height: 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewGame();
              },
              child: const Text(
                'Restart',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Fun Maths Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${_currentQuestion + 1}/5',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '$_number1 $_operation $_number2 = ?',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _options.map((option) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.green), // Green border
                ),
                onPressed: () => _checkAnswer(option),
                child: Text(option.toString()),
              )).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Attempts left: $_attempts',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
