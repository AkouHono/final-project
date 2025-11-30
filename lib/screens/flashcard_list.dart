import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_flashcard.dart';
import 'review_flashcards.dart';

class FlashcardListPage extends StatelessWidget {
  final String subjectId;
  final String title;

  FlashcardListPage({
    required this.subjectId,
    required this.title,
  });

  final firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f0ff),

      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),

        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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
            icon: const Icon(Icons.play_circle_fill),
            label: const Text("Review"),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: StreamBuilder(
        stream: firestore.getFlashcards(subjectId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cards = snapshot.data!.docs;

          if (cards.isEmpty) {
            return const Center(
              child: Text(
                "No flashcards yet.\nTap Add Flashcard to create one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 12),

                child: ListTile(
                  title: Text(
                    card['question'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  subtitle: Text(
                    card['answer'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                          final confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete Flashcard"),
                              content: const Text(
                                "Are you sure you want to delete this flashcard?",
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: const Text("Delete",
                                      style: TextStyle(color: Colors.red)),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            firestore.deleteFlashcard(subjectId, card.id);
                          }
                        },
                      ),
                    ],
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
