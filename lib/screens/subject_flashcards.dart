import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_flashcard.dart';
import 'review_flashcards.dart';

class SubjectFlashcardsPage extends StatelessWidget {
  final String subjectId;
  final String title;
  final firestore = FirestoreService();

  SubjectFlashcardsPage({required this.subjectId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0ff),

      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.deepPurple)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
            tooltip: "Start Review",
            icon: Icon(Icons.play_circle_fill, color: Colors.deepPurple, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewFlashcardsPage(
                    subjectId: subjectId,
                    title: title,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder(
        stream: firestore.getFlashcards(subjectId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final flashcards = snapshot.data!.docs;

          return Column(
            children: [
              if (flashcards.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      "No flashcards yet.\nTap + to add one!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      final card = flashcards[index];

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(card['question']),
                          subtitle: Text(
                            card['answer'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // START REVIEW BUTTON
              if (flashcards.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow, color: Colors.white),
                      label: Text(
                        "Start Review",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReviewFlashcardsPage(
                              subjectId: subjectId,
                              title: title,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Flashcard"),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddFlashcardPage(subjectId: subjectId),
            ),
          );
        },
      ),
    );
  }
}
