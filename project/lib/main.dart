import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'play.dart';
import 'profile.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _profileImage = 'profile1.png'; // Default profile image
  String _userName = 'Fluffy'; // Default user name

  @override
  void initState() {
    super.initState();
    _fetchUserData(1); // Fetch user data for user with ID 1
  }

  // Fetch user data from the backend
  Future<void> _fetchUserData(int userId) async {
    final response = await http.get(Uri.parse('http://myfluffy.atwebpages.com/api/get_user.php?id=$userId'));
    if (response.statusCode == 200) {
      final user = json.decode(response.body);
      setState(() {
        _userName = user['username'];
        _profileImage = user['profile_image'];
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // Update user data in the backend
  Future<void> _updateUserData(int userId, String userName, String profileImage) async {
    final response = await http.post(
      Uri.parse('http://myfluffy.atwebpages.com/api/update_user.php'),
      body: {
        'id': userId.toString(),
        'username': userName,
        'profile_image': profileImage,
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success'] != null) {
        print(result['success']);
      } else {
        print(result['error']);
      }
    } else {
      throw Exception('Failed to update user data');
    }
  }

  void _changeProfileImage() async {
    final String? selectedImage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileSelectionPage()),
    );

    if (selectedImage != null) {
      setState(() {
        _profileImage = selectedImage;
      });
      _updateUserData(1, _userName, _profileImage); // Update user data in the backend
    }
  }

  void _changeUserName() async {
    final TextEditingController _textFieldController = TextEditingController();

    final String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Name your fluffy pet'),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g: Fluffy',
            ),
            onSubmitted: (value) {
              Navigator.pop(context, value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _textFieldController.text); // Pass the text field value
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _userName = newName;
      });
      _updateUserData(1, _userName, _profileImage); // Update user data in the backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // Height of the AppBar
        flexibleSpace: Stack(
          children: [
            Positioned(
              left: 16, // Adjust as needed
              top: 3, // Move the profile image up
              child: GestureDetector(
                onTap: _changeProfileImage,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/$_profileImage'),
                  radius: 35, // Adjust radius as needed
                ),
              ),
            ),
            Positioned(
              left: 16, // Align button with profile image
              bottom: 10, // Align button with profile image
              child: ElevatedButton(
                onPressed: _changeUserName,
                child: Text(_userName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
              ),
            ),
          ],
        ),
        title: const Text(
          'My Fluffy',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('play.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 40), // Move text higher
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Hi! My name is $_userName!',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'Hifluffy.gif',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PlayPage()),
                  );
                },
                child: Image.asset(
                  'play1.png',
                  width: 200,
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
