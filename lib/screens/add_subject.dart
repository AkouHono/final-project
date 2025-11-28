import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'subject_flashcards.dart';

class AddSubjectPage extends StatefulWidget {
  @override
  _AddSubjectPageState createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController controller = TextEditingController();
  final firestore = FirestoreService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0ff),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Add Subject", style: TextStyle(color: Colors.deepPurple)),
        iconTheme: IconThemeData(color: Colors.deepPurple),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Create a new subject",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Give your subject a name to organize your flashcards.",
              style: TextStyle(color: Colors.black54),
            ),

            SizedBox(height: 40),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Subject Name",
                prefixIcon: Icon(Icons.menu_book, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save Subject",
                        style: TextStyle(fontSize: 16, color: Colors.white)),

                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;

                  setState(() => loading = true);

                  try {
                    String subjectName = controller.text.trim();

                    // TIMEOUT ADDED
                    final id = await firestore.addSubject(subjectName).timeout(
                      Duration(seconds: 8),
                      onTimeout: () {
                        throw Exception("Connection timeout — Firestore not responding.");
                      },
                    );

                    // Show success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Subject \"$subjectName\" added!"),
                        backgroundColor: Colors.deepPurple,
                      ),
                    );

                    // Navigate FIRST
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubjectFlashcardsPage(
                          subjectId: id,
                          title: subjectName,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) setState(() => loading = false);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
