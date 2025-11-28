import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // LOGO
            Image.asset(
              "assets/fond.png",
              height: 120,
              fit: BoxFit.contain,
            ),

            SizedBox(height: 20),

            // TITLE
            Text(
              "EduFlash",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),

            SizedBox(height: 10),

            // SUBTITLE
            Text(
              "Preparing your flashcards...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            SizedBox(height: 30),

            // LOADING ICON
            CircularProgressIndicator(
              color: Colors.indigo,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
