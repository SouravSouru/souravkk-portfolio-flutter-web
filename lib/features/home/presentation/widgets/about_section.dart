import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.5),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.isMobile(context) ? 20 : 100,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Me",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 4,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            "I am a passionate Senior Flutter Developer with a strong foundation in mobile application development. "
            "With over 4 years of experience, I have successfully delivered scalable and high-performance applications "
            "using Clean Architecture and modern state management solutions like Bloc and Riverpod.\n\n"
            "While my primary focus is Mobile Development (Android & iOS), I also have extensive experience in building "
            "responsive Web applications and Desktop applications/tools for Windows using Flutter. "
            "I believe in writing clean, maintainable, and testable code.",
            style: const TextStyle(fontSize: 18, height: 1.6),
          ),
        ],
      ),
    );
  }
}
