###Features
User Authentication

Email and password login and registration.

Email verification required before accessing the app.

Password reset functionality via email.

Subject Management

Create subjects to organize study material.

Real-time subject list updates using Firestore streams.

Persistent data stored securely in Firestore.

Flashcard Management

Add flashcards under each subject.

Real-time flashcard listing.

View flashcards in card format.

Flashcard Review Mode

Flip-card animation to reveal answers.

Next/previous navigation for efficient learning.

Tracks study progress per subject.

Design and UI

Attractive and clean UI built with Flutter.

Loading screen integrated during authentication.

Consistent theme using deep purple color palette.

Tech Stack

Flutter (Dart)

Firebase Authentication

Cloud Firestore

Firebase Core

Firebase App Check

###project_structure
lib/
  main.dart
  screens/
      login.dart
      register.dart
      home.dart
      add_subject.dart
      subject_flashcards.dart
      add_flashcard.dart
      review_flashcards.dart
  services/
      firestore_service.dart
      auth_service.dart
assets/
  logo.png
  fond.png
pubspec.yaml

###firebase structure
subjects/
   subjectId/
       title: string
       createdAt: timestamp
       flashcards/
           flashcardId/
               question: string
               answer: string
               timestamp: date

               




