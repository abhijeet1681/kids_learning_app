import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaders = [];

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboard = prefs.getStringList('leaderboard') ?? [];

    leaders = leaderboard.map((entry) {
      final parts = entry.split(':');
      return {
        'name': parts[0],
        'score': int.tryParse(parts[1]) ?? 0,
      };
    }).toList();

    leaders.sort((a, b) => b['score'].compareTo(a['score']));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 242, 244),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(255, 96, 10, 109),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 92, 13, 106).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "Top Learners",
                  style: TextStyle(
                    color: Color.fromARGB(255, 140, 19, 145),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: leaders.isEmpty
                  ? const Center(
                      child: Text(
                        "No scores yet!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: leaders.length,
                      itemBuilder: (context, index) {
                        final leader = leaders[index];
                        return Card(
                          color: const Color(0xFFFFD700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF4B0082),
                              child: Text(
                                "#${index + 1}",
                                style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              leader["name"],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 93, 15, 122),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            trailing: Text(
                              "${leader["score"]} pts",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 55, 10, 99),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
