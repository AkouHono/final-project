import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final auth = AuthService();

  String errorMessage = "";

  bool isStrongPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 👉 FIXED BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/fond.png",
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY
          Container(color: Colors.black54),

          /// REGISTER CARD
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [

                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),

                        SizedBox(height: 20),

                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),

                        SizedBox(height: 15),

                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            helperText:
                                "Min 8 characters, must include letters & numbers",
                          ),
                        ),

                        SizedBox(height: 15),

                        TextField(
                          controller: confirmPassController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),

                        SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Sign Up"),
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String pass = passwordController.text.trim();
                            String confirm = confirmPassController.text.trim();

                            if (!isStrongPassword(pass)) {
                              setState(() {
                                errorMessage =
                                    "Password must be at least 8 characters and alphanumeric.";
                              });
                              return;
                            }

                            if (pass != confirm) {
                              setState(() {
                                errorMessage = "Passwords do not match!";
                              });
                              return;
                            }

                            String? feedback = await auth.register(email, pass);

                            if (feedback == null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                              );
                            } else {
                              setState(() => errorMessage = feedback);
                            }
                          },
                        ),

                        SizedBox(height: 10),

                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),

                        SizedBox(height: 10),

                        TextButton(
                          child: Text("Already have an account? Login"),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
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
