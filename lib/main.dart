import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/loading_screen.dart';  // <-- ADD THIS LINE
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );


  runApp(EduFlash());
}

class EduFlash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EduFlash",
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Not logged in → show login

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreen();   // <-- SHOW HERE
        }

        if (!snapshot.hasData) {
          return LoginPage();
        }

        final user = FirebaseAuth.instance.currentUser;

        // Logged in but not verified
        if (user != null && !user.emailVerified) {
          FirebaseAuth.instance.signOut();
          return LoginPage();
        }

        // All good → go to home
        return HomePage();
      },
    );
  }
}
