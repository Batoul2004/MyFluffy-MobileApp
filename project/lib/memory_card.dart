import 'dart:math';
import 'package:flutter/material.dart';

class MemoryCardPage extends StatefulWidget {
  const MemoryCardPage({super.key});

  @override
  _MemoryCardPageState createState() => _MemoryCardPageState();
}

class _MemoryCardPageState extends State<MemoryCardPage> {
  List<String> _cardImages = [
    'assets/card1.png',
    'assets/card2.png',
    'assets/card3.png',
    'assets/card4.png',
    'assets/card5.png',
    'assets/card6.png',
    'assets/card1.png',
    'assets/card2.png',
    'assets/card3.png',
    'assets/card4.png',
    'assets/card5.png',
    'assets/card6.png',
  ];

  List<bool> _cardFlipped = List<bool>.filled(12, false);
  List<bool> _cardMatched = List<bool>.filled(12, false);
  int _firstFlippedIndex = -1;
  int _secondFlippedIndex = -1;
  bool _isChecking = false;
  bool _hasWon = false;

  @override
  void initState() {
    super.initState();
    _cardImages.shuffle();
  }

  void _flipCard(int index) {
    if (_isChecking || _cardMatched[index] || _cardFlipped[index] || _hasWon) {
      return;
    }

    setState(() {
      _cardFlipped[index] = true;
      if (_firstFlippedIndex == -1) {
        _firstFlippedIndex = index;
      } else {
        _secondFlippedIndex = index;
        _isChecking = true;
        Future.delayed(const Duration(seconds: 1), _checkMatch);
      }
    });
  }

  void _checkMatch() {
    setState(() {
      if (_cardImages[_firstFlippedIndex] == _cardImages[_secondFlippedIndex]) {
        _cardMatched[_firstFlippedIndex] = true;
        _cardMatched[_secondFlippedIndex] = true;
      } else {
        _cardFlipped[_firstFlippedIndex] = false;
        _cardFlipped[_secondFlippedIndex] = false;
      }
      _firstFlippedIndex = -1;
      _secondFlippedIndex = -1;
      _isChecking = false;

      if (_cardMatched.every((matched) => matched)) {
        _hasWon = true;
        _showWinningDialog();
      }
    });
  }

  void _restartGame() {
    setState(() {
      _cardImages.shuffle();
      _cardFlipped = List<bool>.filled(12, false);
      _cardMatched = List<bool>.filled(12, false);
      _firstFlippedIndex = -1;
      _secondFlippedIndex = -1;
      _isChecking = false;
      _hasWon = false;
    });
  }

  void _showWinningDialog() {
    final List<String> happyGifs = [
      'happy.gif', 'happy2.gif', 'happy3.gif', 
      'happy4.gif', 'happy5.gif', 'happy6.gif'
    ];

    final randomGif = happyGifs[Random().nextInt(happyGifs.length)];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('You\'ve made it!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Congratulations!'),
              SizedBox(height: 10),
              Image.asset('assets/$randomGif', width: 100, height: 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartGame();
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
        title: const Text('Memory Card Game'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _cardImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _flipCard(index),
            child: Card(
              color: _cardFlipped[index] || _cardMatched[index]
                  ? Colors.white
                  : Colors.green,
              child: _cardFlipped[index] || _cardMatched[index]
                  ? Image.asset(_cardImages[index])
                  : const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
