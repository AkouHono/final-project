import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddFlashcardPage extends StatefulWidget {
  final String subjectId;
  final String? flashcardId;
  final String? question;
  final String? answer;
  final bool isEdit;

  AddFlashcardPage({
    required this.subjectId,
    this.flashcardId,
    this.question,
    this.answer,
    this.isEdit = false,
  });

  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final firestore = FirestoreService();

  late TextEditingController questionController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(text: widget.question ?? "");
    answerController = TextEditingController(text: widget.answer ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Flashcard" : "Add Flashcard"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: answerController,
              decoration: InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              child: Text(widget.isEdit ? "Update" : "Add"),
              onPressed: () async {
                final question = questionController.text.trim();
                final answer = answerController.text.trim();

                if (question.isEmpty || answer.isEmpty) return;

                if (widget.isEdit) {
                  // UPDATE EXISTING
                  await firestore.updateFlashcard(
                    widget.subjectId,
                    widget.flashcardId!,
                    {"question": question, "answer": answer},
                  );
                } else {
                  // ADD NEW
                  await firestore.addFlashcard(
                    widget.subjectId,
                    {"question": question, "answer": answer},
                  );
                }

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
