import 'package:flutter/material.dart';

class ProfileSelectionPage extends StatelessWidget {
  const ProfileSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> profiles = [
      'profile1.png',
      'profile2.png',
      'profile3.png',
      'profile4.png',
      'profile5.png',
      'profile6.png',
      'profile7.png',
      'profile8.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Profile Image'),
        backgroundColor: Colors.green, // Set AppBar color to green
      ),
      backgroundColor: Colors.lightGreen[100], // Set background color to light green
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, profile);
            },
            child: Image.asset(
              'assets/$profile',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
