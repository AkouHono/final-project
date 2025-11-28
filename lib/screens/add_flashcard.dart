import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddFlashcardPage extends StatefulWidget {
  final String subjectId;

  // Optional fields for editing
  final String? flashcardId;
  final String? question;
  final String? answer;
  final bool isEdit;

  const AddFlashcardPage({
    Key? key,
    required this.subjectId,
    this.flashcardId,
    this.question,
    this.answer,
    this.isEdit = false,
  }) : super(key: key);

  @override
  _AddFlashcardPageState createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  final firestore = FirestoreService();

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      _questionController.text = widget.question ?? '';
      _answerController.text = widget.answer ?? '';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _saveFlashcard() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "question": _questionController.text.trim(),
      "answer": _answerController.text.trim(),
    };

    if (widget.isEdit && widget.flashcardId != null) {
      await firestore.updateFlashcard(
        widget.subjectId,
        widget.flashcardId!,
        data,
      );
    } else {
      await firestore.addFlashcard(
        widget.subjectId,
        data,
      );
    }

    Navigator.pop(context); // go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? "Edit Flashcard" : "Add Flashcard",
          style: TextStyle(color: Colors.deepPurple),
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: "Question"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter a question" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(labelText: "Answer"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter an answer" : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveFlashcard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text(
                  widget.isEdit ? "Update Flashcard" : "Save Flashcard",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
