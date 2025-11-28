import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'add_subject.dart';
import 'subject_flashcards.dart';

class HomePage extends StatelessWidget {
  final firestore = FirestoreService();
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0ff),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "EduFlash",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.deepPurple),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.deepPurple),
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Welcome to EduFlash 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 5),
            child: Text(
              "Organize your learning with subjects and flashcards.",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),

          SizedBox(height: 20),

          Expanded(
            child: StreamBuilder(
              stream: firestore.getSubjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final subjects = snapshot.data!.docs;

                if (subjects.isEmpty) {
                  return Center(
                    child: Text(
                      "No subjects yet.\nTap 'Add Subject' to create one!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade100.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(Icons.menu_book,
                            color: Colors.deepPurple, size: 28),
                        title: Text(
                          subject["title"],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubjectFlashcardsPage(
                                subjectId: subject.id,
                                title: subject["title"],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Add Subject", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddSubjectPage()),
          );
        },
      ),
    );
  }
}
