import 'package:flutter/material.dart';
import 'tic_tac_toe.dart' as tic_tac_toe;
import 'fun_maths.dart' as fun_maths;
import 'memory_card.dart' as memory_card;

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  late double _lollipopX;
  late double _donutX;
  late double _cupcakeX;
  late double _yPosition;

  List<String> _fluffySprites = [
    'assets/sprite01.png',
    'assets/sprite1.png',
    'assets/sprite2.png',
    'assets/sprite3.png',
    'assets/sprite4.png',
    'assets/sprite5.png',
    'assets/sprite6.png',
    'assets/sprite7.png',
  ];

  int _fluffySpriteIndex = 0;
  late AnimationController _animationController;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: 7).animate(_animationController)
      ..addListener(() {
        setState(() {
          _fluffySpriteIndex = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startFluffyAnimation() {
    _animationController.forward(from: 0);
  }

  void _showGamesList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a Game'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGameListItem('tictactoe.jpg', 'Tic-Tac Toe', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const tic_tac_toe.TicTacToePage()),
                  );
                }),
                _buildGameListItem('funmaths.png', 'Math Quiz', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const fun_maths.FunMathsPage()),
                  );
                }),
                _buildGameListItem('card3.png', 'Memory Matching Cards', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const memory_card.MemoryCardPage()),
                  );
                }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGameListItem(String iconPath, String gameName, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(iconPath, width: 40, height: 40),
      title: Text(gameName),
      onTap: () {
        Navigator.pop(context); // Close the dialog
        onTap(); // Navigate to the selected game
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the positions dynamically
    _lollipopX = screenWidth / 2 - 150;
    _donutX = screenWidth / 2 - 50;
    _cupcakeX = screenWidth / 2 + 50;
    _yPosition = screenHeight / 10; // Move even higher

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 171, 24),
        title: const Text('Play Page'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/back_button.png'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/play.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            _buildDraggableItem('assets/lollipop.png', _lollipopX, _yPosition),
            _buildDraggableItem('assets/donut.png', _donutX, _yPosition),
            _buildDraggableItem('assets/cupcake.png', _cupcakeX, _yPosition),
            Positioned(
              bottom: 50,
              left: screenWidth / 2 - 150, // Adjust left position for Fluffy
              child: GestureDetector(
                onTap: () {
                  // Start the Fluffy animation
                  _startFluffyAnimation();
                },
                child: Image.asset(
                  _fluffySprites[_fluffySpriteIndex],
                  width: 300, // Increase the width of Fluffy
                  height: 300, // Increase the height of Fluffy
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _showGamesList,
                child: const Text('Games'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableItem(String asset, double xPosition, double yPosition) {
    return Positioned(
      left: xPosition,
      top: yPosition,
      child: Draggable(
        feedback: Image.asset(asset, width: 100, height: 100),
        childWhenDragging: Container(),
        child: Image.asset(asset, width: 100, height: 100),
        onDragEnd: (details) {
          setState(() {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final double fluffyLeft = screenWidth / 2 - 150;
            final double fluffyTop = screenHeight - 350;

            if (details.offset.dx >= fluffyLeft &&
                details.offset.dx <= fluffyLeft + 300 &&
                details.offset.dy >= fluffyTop &&
                details.offset.dy <= fluffyTop + 300) {
              // Start the Fluffy animation if the item is dragged to Fluffy
              _startFluffyAnimation();
            }

            // Return to the original position after dragging
            if (asset == 'assets/lollipop.png') {
              _lollipopX = screenWidth / 2 - 150;
              _yPosition = screenHeight / 10; // Move even higher
            } else if (asset == 'assets/donut.png') {
              _donutX = screenWidth / 2 - 50;
              _yPosition = screenHeight / 10; // Move even higher
            } else if (asset == 'assets/cupcake.png') {
              _cupcakeX = screenWidth / 2 + 50;
              _yPosition = screenHeight / 10; // Move even higher
            }
          });
        },
      ),
    );
  }
}

