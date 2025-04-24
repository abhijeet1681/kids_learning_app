import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math';

class PracticePage extends StatelessWidget {
  PracticePage({super.key});

  final FlutterTts tts = FlutterTts();
  final Random random = Random();

  final List<String> alphabets =
      List.generate(26, (index) => String.fromCharCode(65 + index));
  final List<String> numbers =
      List.generate(10, (index) => (index + 1).toString());

  final List<Color> cardColors = [
    Color.fromARGB(255, 245, 242, 62), // Light Aqua
  ];

  Future<void> speak(String value) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1);
    await tts.setSpeechRate(0.5);
    await tts.speak(value);
  }

  Widget buildSection({
    required String title,
    required List<String> items,
    required String type,
    required Color backgroundColor,
  }) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(bottom: 24),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(top: 8),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.deepPurple, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.menu_book_outlined, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const Spacer(),
              const Icon(Icons.expand_more, color: Colors.deepPurple),
            ],
          ),
        ),
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: items.map((item) {
              final imagePath = 'assets/$type/$item.png';
              final cardColor = cardColors[random.nextInt(cardColors.length)];

              return BounceInDown(
                child: GestureDetector(
                  onTap: () => speak(item),
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.grey.shade300,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: type == 'numbers'
                            ? BoxDecoration(
                                color: Colors.orangeAccent, // Orange background for numbers
                                borderRadius: BorderRadius.circular(12),
                              )
                            : null,
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSection(
              title: "Alphabets",
              items: alphabets,
              type: "alphabets",
              backgroundColor: const Color(0xFFFFF3E0), // Soft Pink
            ),
            buildSection(
              title: "Numbers",
              items: numbers,
              type: "numbers",
              backgroundColor: const Color(0xFFFFEBEE), // Light Orange
            ),
          ],
        ),
      ),
    );
  }
}
