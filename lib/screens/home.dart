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
      backgroundColor: const Color(0xfff7f0ff),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "EduFlash",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.deepPurple),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.deepPurple),
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
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
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
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder(
              stream: firestore.getSubjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final subjects = snapshot.data!.docs;

                if (subjects.isEmpty) {
                  return const Center(
                    child: Text(
                      "No subjects yet.\nTap 'Add Subject' to create one!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade100.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          )
                        ],
                      ),

                      child: ListTile(
                        leading: const Icon(
                          Icons.menu_book,
                          color: Colors.deepPurple,
                          size: 28,
                        ),

                        title: Text(
                          subject["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          onSelected: (value) async {
                            if (value == "edit") {
                              // *** FIXED: SEND ID + TITLE ***
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddSubjectPage(
                                    subjectId: subject.id,
                                    initialTitle: subject["title"],
                                  ),
                                ),
                              );
                            }

                            if (value == "delete") {
                              final confirm = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Subject"),
                                  content: Text(
                                    "Delete '${subject["title"]}' and all its flashcards?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                firestore.deleteSubject(subject.id);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                        ),

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
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Subject", style: TextStyle(color: Colors.white)),
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
