import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ReviewFlashcardsPage extends StatefulWidget {
  final String subjectId;
  final String title;

  ReviewFlashcardsPage({
    required this.subjectId,
    required this.title,
  });

  @override
  _ReviewFlashcardsPageState createState() => _ReviewFlashcardsPageState();
}

class _ReviewFlashcardsPageState extends State<ReviewFlashcardsPage>
    with SingleTickerProviderStateMixin {

  final firestore = FirestoreService();
  int index = 0;
  int correct = 0;
  int wrong = 0;

  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void flipCard() {
    if (!showAnswer) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => showAnswer = !showAnswer);
  }

  void nextCard(List cards) {
    if (index + 1 >= cards.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ReviewCompletePage(
            correct: correct,
            wrong: wrong,
            total: cards.length,
            title: widget.title,
          ),
        ),
      );
      return;
    }

    setState(() {
      index++;
      showAnswer = false;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0ff),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: StreamBuilder(
        stream: firestore.getFlashcards(widget.subjectId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final cards = snapshot.data!.docs;

          if (cards.isEmpty) {
            return Center(child: Text("No flashcards to review!"));
          }

          final card = cards[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: flipCard,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * 3.14;
                    final isBack = angle > 1.57;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: _buildFlashcard(
                        isBack ? card["answer"] : card["question"],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red, size: 40),
                    onPressed: () {
                      wrong++;
                      nextCard(cards);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green, size: 40),
                    onPressed: () {
                      correct++;
                      nextCard(cards);
                    },
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildFlashcard(String text) {
    return Container(
      height: 250,
      width: 350,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

class ReviewCompletePage extends StatelessWidget {
  final int correct;
  final int wrong;
  final int total;
  final String title;

  ReviewCompletePage({
    required this.correct,
    required this.wrong,
    required this.total,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff7f0ff),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("$title Review Complete"),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Great job!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              Text(
                "Correct: $correct\nIncorrect: $wrong\nTotal: $total",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Back to Flashcards",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
