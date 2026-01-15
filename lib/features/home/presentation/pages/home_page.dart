import 'package:flutter/material.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  HomeHeroSection(),
                  AboutSection(),
                  SkillsSection(),
                  ExperienceSection(),
                  ProjectsSection(),
                  ContactSection(),
                  Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
