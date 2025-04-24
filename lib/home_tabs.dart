import 'package:flutter/material.dart';
import 'practice_page.dart';
import 'quiz_page.dart';
import 'leaderboard_page.dart';
import 'profile_page.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Looping left and right
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFC8E6C9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF6F61),
          title: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double dx = 10 * (1 - (_controller.value * 2)).abs(); // Oscillates from -10 to +10
              return Transform.translate(
                offset: Offset(dx, 0),
                child: child,
              );
            },
            child: const Text(
              "Kids Learning",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Color.fromARGB(255, 241, 232, 230),
                shadows: [
                  Shadow(
                    blurRadius: 12.0,
                    color: Colors.yellowAccent,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          bottom: const TabBar(
            // isScrollable: true,
            labelColor: Color.fromARGB(255, 236, 247, 79),
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            indicatorColor: Color(0xFFFFB74D),
            tabs: [
              Tab(text: 'Practice'),
              Tab(text: 'Quiz'),
              Tab(text: 'Leaderboard'),
              Tab(text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PracticePage(),
            const QuizPage(),
            const LeaderboardPage(),
            const ProfilePage(),
          ],
        ),
      ),
    );
  }
}

