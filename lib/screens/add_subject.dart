import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddSubjectPage extends StatefulWidget {
  final String? subjectId;        // null = create mode
  final String? initialTitle;     // title to pre-fill when editing

  const AddSubjectPage({
    this.subjectId,
    this.initialTitle,
    Key? key,
  }) : super(key: key);

  @override
  _AddSubjectPageState createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController controller = TextEditingController();
  final firestore = FirestoreService();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    // If editing → show the subject name
    if (widget.initialTitle != null) {
      controller.text = widget.initialTitle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.subjectId != null;

    return Scaffold(
      backgroundColor: const Color(0xfff7f0ff),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isEdit ? "Edit Subject" : "Add Subject",
          style: const TextStyle(color: Colors.deepPurple),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? "Update subject name" : "Create a new subject",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Give your subject a name to organize your flashcards.",
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 40),

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Subject Name",
                prefixIcon: const Icon(Icons.menu_book, color: Colors.deepPurple),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isEdit ? "Update Subject" : "Save Subject",
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;

                  setState(() => loading = true);

                  try {
                    final title = controller.text.trim();

                    if (isEdit) {
                      /// -------------------------
                      /// UPDATE SUBJECT
                      /// -------------------------
                      await firestore.updateSubject(
                        widget.subjectId!,
                        {"title": title},
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Subject updated!")),
                      );
                    } else {
                      /// -------------------------
                      /// CREATE SUBJECT
                      /// -------------------------
                      await firestore.addSubject(title);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Subject \"$title\" added!")),
                      );
                    }

                    Navigator.pop(context);

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
