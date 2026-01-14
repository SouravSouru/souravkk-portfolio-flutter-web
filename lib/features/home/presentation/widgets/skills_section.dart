import 'package:flutter/material.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/entrance_fader.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileSkills = [
      "Flutter",
      "Dart",
      "Android",
      "iOS",
      "Bloc",
      "Riverpod",
      "Clean Architecture",
    ];
    final otherSkills = [
      "Firebase",
      "REST APIs",
      "Web",
      "Windows",
      "Git",
      "CI/CD",
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.isMobile(context) ? 20 : 100,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntranceFader(
            offset: const Offset(0, 20),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  "Technical Skills",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _SkillGroup(
            title: "Mobile Development",
            skills: mobileSkills,
            delayStart: 100,
          ),
          const SizedBox(height: 30),
          _SkillGroup(
            title: "Backend & Web",
            skills: otherSkills,
            delayStart: 300,
          ),
        ],
      ),
    );
  }
}

class _SkillGroup extends StatelessWidget {
  final String title;
  final List<String> skills;
  final int delayStart;

  const _SkillGroup({
    required this.title,
    required this.skills,
    this.delayStart = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EntranceFader(
          delay: Duration(milliseconds: delayStart),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            return EntranceFader(
              delay: Duration(milliseconds: delayStart + (index * 50) + 100),
              offset: const Offset(0, 20),
              child: Chip(
                avatar: const Icon(Icons.check_circle, size: 16),
                label: Text(skill),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                ),
                elevation: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
