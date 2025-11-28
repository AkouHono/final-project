import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all subjects
  Stream<QuerySnapshot> getSubjects() {
    return _db.collection('subjects').orderBy('title').snapshots();
  }

  // Add a subject and return its ID
  Future<String> addSubject(String title) async {
    DocumentReference ref = await _db.collection('subjects').add({
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  // Update subject (optional)
  Future<void> updateSubject(String subjectId, Map<String, dynamic> data) async {
    await _db.collection('subjects').doc(subjectId).update(data);
  }

  // Delete subject (optional)
  Future<void> deleteSubject(String subjectId) async {
    await _db.collection('subjects').doc(subjectId).delete();
  }

  // Get flashcards for a subject
  Stream<QuerySnapshot> getFlashcards(String subjectId) {
    return _db
        .collection('subjects')
        .doc(subjectId)
        .collection('flashcards')
        .orderBy('question')
        .snapshots();
  }

  // Add flashcard
  Future<void> addFlashcard(String subjectId, Map<String, dynamic> data) async {
    await _db
        .collection('subjects')
        .doc(subjectId)
        .collection('flashcards')
        .add(data);
  }

  // Update flashcard
  Future<void> updateFlashcard(
      String subjectId, String flashcardId, Map<String, dynamic> data) async {
    await _db
        .collection('subjects')
        .doc(subjectId)
        .collection('flashcards')
        .doc(flashcardId)
        .update(data);
  }

  // Delete flashcard
  Future<void> deleteFlashcard(String subjectId, String flashcardId) async {
    await _db
        .collection('subjects')
        .doc(subjectId)
        .collection('flashcards')
        .doc(flashcardId)
        .delete();
  }
}
