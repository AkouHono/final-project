import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  String errorMessage = "";

  bool _obscurePassword = true;   // 👈 ADDED

  bool isStrongPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  String getFriendlyError(String code) {
    switch (code) {
      case "invalid-email":
        return "Invalid email format.";
      case "user-not-found":
        return "No account found for this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "email-already-in-use":
        return "This email is already registered.";
      case "weak-password":
        return "Password must be at least 8 characters.";
      case "invalid-credential":
        return "Incorrect email or password.";
      default:
        return "An unexpected error occurred.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.black54),

          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 420,
                height: 500,

                child: Card(
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  elevation: 10,

                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/logo.png",
                            height: 100, fit: BoxFit.contain),

                        SizedBox(height: 10),

                        Text("EduFlash",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            )),

                        SizedBox(height: 20),

                        // EMAIL
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),

                        SizedBox(height: 12),

                        // PASSWORD (WITH SHOW/HIDE)
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword, // 👈 UPDATED
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock_outline),

                            // 👇 ADDED SHOW/HIDE ICON
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text("Forgot Password?"),
                            onPressed: () async {
                              if (emailController.text.trim().isEmpty) {
                                setState(() {
                                  errorMessage = "Please enter your email.";
                                });
                                return;
                              }

                              String? result =
                                  await auth.resetPassword(
                                      emailController.text.trim());

                              setState(() {
                                errorMessage =
                                    result ?? "Password reset link sent!";
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 10),

                        if (errorMessage.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red.shade700),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // LOGIN BUTTON
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Login",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password =
                                passwordController.text.trim();

                            String? feedback =
                                await auth.login(email, password);

                            if (feedback == null) {
                              final user =
                                  FirebaseAuth.instance.currentUser;

                              if (user != null &&
                                  !user.emailVerified) {
                                await user.sendEmailVerification();

                                setState(() {
                                  errorMessage =
                                      "Verification link sent!\nCheck your email before logging in.";
                                });

                                FirebaseAuth.instance.signOut();
                                return;
                              }

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomePage()),
                              );
                            } else {
                              final cleanCode = feedback
                                  .replaceAll("firebase_auth/", "")
                                  .replaceAll("[", "")
                                  .replaceAll("]", "");

                              setState(() {
                                errorMessage = getFriendlyError(cleanCode);
                              });
                            }
                          },
                        ),

                        SizedBox(height: 15),

                        TextButton(
                          child: Text("Create an account",
                              style: TextStyle(color: Colors.indigo)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
