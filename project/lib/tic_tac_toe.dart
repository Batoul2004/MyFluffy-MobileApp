import 'dart:math';
import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  static const int boardSize = 9;
  static const String playerSymbol = 'X';
  static const String computerSymbol = 'O';

  List<String> _board = List.filled(boardSize, '');
  bool _isPlayerTurn = true;
  String _resultMessage = '';

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    setState(() {
      _board = List.filled(boardSize, '');
      _isPlayerTurn = true;
      _resultMessage = '';
    });
  }

  void _handleTap(int index) {
    if (_board[index] == '' && _resultMessage == '') {
      setState(() {
        if (_isPlayerTurn) {
          _board[index] = playerSymbol;
          _isPlayerTurn = false;
          if (!_checkWin(playerSymbol)) {
            _computerMove();
          }
        }
      });
    }
  }

  void _computerMove() {
    int index;
    do {
      index = Random().nextInt(boardSize);
    } while (_board[index] != '');

    setState(() {
      _board[index] = computerSymbol;
      _isPlayerTurn = true;
      _checkWin(computerSymbol);
    });
  }

  bool _checkWin(String symbol) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] == symbol &&
          _board[pattern[1]] == symbol &&
          _board[pattern[2]] == symbol) {
        _resultMessage = '$symbol wins!';
        _showResultDialog(symbol == playerSymbol);
        return true;
      }
    }

    if (!_board.contains('')) {
      _resultMessage = 'It\'s a draw!';
      _showResultDialog(false);
      return true;
    }

    return false;
  }

  void _showResultDialog(bool isWin) {
    final List<String> happyGifs = [
      'happy.gif', 'happy2.gif', 'happy3.gif', 
      'happy4.gif', 'happy5.gif', 'happy6.gif'
    ];
    final List<String> sadGifs = [
      'lose.gif', 'lose2.gif', 'lose3.gif'
    ];

    final randomGif = (isWin 
      ? happyGifs 
      : sadGifs
    )[Random().nextInt(isWin ? happyGifs.length : sadGifs.length)];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isWin ? 'You Won!' : 'Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isWin ? 'Congratulations!' : 'Try again!'),
              SizedBox(height: 10),
              Image.asset('assets/$randomGif', width: 100, height: 100),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetBoard();
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
        title: const Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: boardSize,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    color: _board[index] == '' ? Colors.white : Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      _board[index],
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            _resultMessage,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
            ),
            onPressed: _resetBoard,
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

