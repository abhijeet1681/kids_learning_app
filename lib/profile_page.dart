import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  String userName = '';
  String age = '';
  String favoriteSubject = '';
  int totalPoints = 0;

  bool isEditingName = false;
  bool isEditingAge = false;
  bool isEditingSubject = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  final List<String> randomAvatars = [
    '🦁', '🐵', '🦊', '🐰', '🐱', '🐼', '🐸', '🐯', '🐶'
  ];

  late AnimationController _avatarController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    loadProfile();

    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? '';
      age = prefs.getString('age') ?? '';
      favoriteSubject = prefs.getString('subject') ?? '';
      totalPoints = prefs.getInt('points') ?? 0;
    });
  }

  Future<void> saveField(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    setState(() {
      if (key == 'username') {
        userName = value;
        isEditingName = false;
      } else if (key == 'age') {
        age = value;
        isEditingAge = false;
      } else if (key == 'subject') {
        favoriteSubject = value;
        isEditingSubject = false;
      }
    });
  }

  String getAvatarEmoji() {
    if (userName.isNotEmpty) {
      return userName[0].toUpperCase();
    } else {
      return randomAvatars[Random().nextInt(randomAvatars.length)];
    }
  }

  Widget buildProfileCard({
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onEdit,
  }) {
    final bool isValueSet = value.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4B0082)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B0082),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isValueSet ? value : "Not set",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF4B0082),
              ),
            ),
            if (onEdit != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Color(0xFF4B0082)),
                onPressed: onEdit,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildEditField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onSave,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6F61),
          ),
          onPressed: onSave,
          icon: const Icon(Icons.check, color: Color(0xFF4B0082)),
          label: Text(
            "Save $label",
            style: const TextStyle(color: Color(0xFF4B0082)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (_, child) {
                  return Transform.translate(
                    offset: Offset(0, -_bounceAnimation.value),
                    child: child,
                  );
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: const Color(0xFFFF6F61),
                  child: Text(
                    getAvatarEmoji(),
                    style: const TextStyle(fontSize: 48, color: Color(0xFF4B0082)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName.isEmpty ? "Hello, Kiddo!" : "Hello, $userName!",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6F61),
                ),
              ),
              const SizedBox(height: 20),

              if (isEditingName)
                buildEditField(
                  label: "Name",
                  controller: nameController,
                  onSave: () {
                    if (nameController.text.trim().isNotEmpty) {
                      saveField('username', nameController.text.trim());
                    }
                  },
                ),

              if (isEditingAge)
                buildEditField(
                  label: "Age",
                  controller: ageController,
                  onSave: () {
                    if (ageController.text.trim().isNotEmpty) {
                      saveField('age', ageController.text.trim());
                    }
                  },
                ),

              if (isEditingSubject)
                buildEditField(
                  label: "Favorite Subject",
                  controller: subjectController,
                  onSave: () {
                    if (subjectController.text.trim().isNotEmpty) {
                      saveField('subject', subjectController.text.trim());
                    }
                  },
                ),

              const SizedBox(height: 20),

              buildProfileCard(
                title: "Name",
                value: userName,
                icon: Icons.person,
                onEdit: () {
                  setState(() {
                    isEditingName = true;
                    nameController.text = userName;
                  });
                },
              ),
              buildProfileCard(
                title: "Age",
                value: age,
                icon: Icons.cake,
                onEdit: () {
                  setState(() {
                    isEditingAge = true;
                    ageController.text = age;
                  });
                },
              ),
              buildProfileCard(
                title: "Favorite Subject",
                value: favoriteSubject,
                icon: Icons.school,
                onEdit: () {
                  setState(() {
                    isEditingSubject = true;
                    subjectController.text = favoriteSubject;
                  });
                },
              ),
              buildProfileCard(
                title: "Total Points",
                value: "$totalPoints pts",
                icon: Icons.star,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
