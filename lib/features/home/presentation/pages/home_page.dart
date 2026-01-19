import 'package:flutter/material.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBar(onNavTap: _scrollToSection),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeyedSubtree(
                    key: _sectionKeys[0],
                    child: const HomeHeroSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[1],
                    child: const AboutSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[2],
                    child: const SkillsSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[3],
                    child: const ExperienceSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[4],
                    child: const ProjectsSection(),
                  ),
                  KeyedSubtree(
                    key: _sectionKeys[5],
                    child: const ContactSection(),
                  ),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
