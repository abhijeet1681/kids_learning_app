import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'leaderboard_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<String> allChars = [
    ...'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''),
    ...List.generate(10, (index) => (index + 1).toString())
  ];

  late String correctAnswer;
  late List<String> options;
  int score = 0;
  int questionCount = 0;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    final rand = Random();
    correctAnswer = allChars[rand.nextInt(allChars.length)];
    options = [correctAnswer];

    while (options.length < 4) {
      String newOption = allChars[rand.nextInt(allChars.length)];
      if (!options.contains(newOption)) {
        options.add(newOption);
      }
    }

    options.shuffle();
  }

  Future<void> checkAnswer(String selectedOption) async {
    final isCorrect = selectedOption == correctAnswer;
    questionCount++;

    if (isCorrect) score++;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF4B0082),
        title: Text(
          isCorrect ? "🎉 Correct!" : "❌ Oops!",
          style: TextStyle(
            color: isCorrect ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Answer: $correctAnswer",
          style: const TextStyle(color: Color(0xFFADD8E6)),
        ),
        actions: [
          TextButton(
            child: const Text(
              "Next",
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (questionCount < 10) {
                setState(() => generateQuestion());
              } else {
                showFinalScore();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> showFinalScore() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('username') ?? 'Anonymous';

    List<String> leaderboard = prefs.getStringList('leaderboard') ?? [];
    leaderboard.add('$name:$score');
    await prefs.setStringList('leaderboard', leaderboard);

    int currentPoints = prefs.getInt('points') ?? 0;
    await prefs.setInt('points', currentPoints + score);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LeaderboardPage()),
    );
  }

  String getImagePath(String char) {
    if (int.tryParse(char) != null) {
      return 'assets/numbers/$char.png';
    } else {
      return 'assets/alphabets/$char.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Soft Pink
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF6A1B9A), // Deep Purple
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "Question ${questionCount + 1} of 10",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 83, 22, 157),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Which character is shown?",
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xFFFF6F61),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 235, 246, 43),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 227, 8, 247),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      getImagePath(correctAnswer),
                      height: 160,
                      width: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: options.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: const Color(0xFF4B0082),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Color(0xFF6A1B9A),
                              width: 2,
                            ),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () => checkAnswer(option),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
