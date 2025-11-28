import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_flashcard.dart';
import 'review_flashcards.dart';

class FlashcardListPage extends StatelessWidget {
  final String subjectId;
  final String title;
  final firestore = FirestoreService();

  FlashcardListPage({required this.subjectId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0ff),

      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.deepPurple),

        actions: [
          IconButton(
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
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final flashcards = snapshot.data!.docs;

          if (flashcards.isEmpty) {
            return Center(
              child: Text(
                "No flashcards yet.\nTap Add Flashcard to create one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final card = flashcards[index];

              return Dismissible(
                key: Key(card.id),

                // SWIPE RIGHT → EDIT
                background: Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  color: Colors.blue,
                  child: Icon(Icons.edit, color: Colors.white, size: 30),
                ),

                // SWIPE LEFT → DELETE
                secondaryBackground: Container(
                  padding: EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white, size: 30),
                ),

                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Edit Flashcard
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddFlashcardPage(
                          subjectId: subjectId,
                          flashcardId: card.id,
                          question: card['question'],
                          answer: card['answer'],
                          isEdit: true,
                        ),
                      ),
                    );
                    return false;
                  }

                  // Confirm delete
                  final confirm = await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Delete Flashcard"),
                      content: Text("Are you sure you want to delete this flashcard?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Delete", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirm) firestore.deleteFlashcard(subjectId, card.id);

                  return confirm;
                },

                child: Card(
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
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddFlashcardPage(subjectId: subjectId),
            ),
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add Flashcard"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
