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
            AppConstants.aboutDescription,
            style: const TextStyle(fontSize: 18, height: 1.6),
          ),
        ],
      ),
    );
  }
}
