import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'review_flashcards.dart';
import 'add_flashcard.dart';

class SubjectFlashcardsPage extends StatelessWidget {
  final String subjectId;
  final String title;

  SubjectFlashcardsPage({required this.subjectId, required this.title});

  final firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f0ff),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(color: Colors.deepPurple),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.play_arrow, size: 20, color: Colors.white),
              label: const Text(
                "Review",
                style: TextStyle(color: Colors.white, fontSize: 14),
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
        ],
      ),

      body: StreamBuilder(
        stream: firestore.getFlashcards(subjectId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cards = snapshot.data!.docs;

          // Empty state
          if (cards.isEmpty) {
            return const Center(
              child: Text(
                "No flashcards yet.\nTap + to add your first one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          // List of flashcards
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(16),
                  child:ListTile(
  tileColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),

  // SHOW FULL FLASHCARD ON TAP
  onTap: () {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text(card['question']),
        content: Text(card['answer']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  },

  title: Text(
    card['question'],
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),

  subtitle: Text(
    card['answer'],
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(color: Colors.black54),
  ),

  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // EDIT BUTTON
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
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
        },
      ),

      // DELETE BUTTON
      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          bool confirm = await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Delete Flashcard"),
              content: const Text("Are you sure you want to delete this flashcard?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete",
                        style: TextStyle(color: Colors.red))),
              ],
            ),
          );

          if (confirm) {
            firestore.deleteFlashcard(subjectId, card.id);
          }
        },
      ),
    ],
  ),
),

                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("Add Flashcard"),
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
