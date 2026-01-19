import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/entrance_fader.dart';

class HomeHeroSection extends StatelessWidget {
  final VoidCallback? onViewAppsTap;

  const HomeHeroSection({super.key, this.onViewAppsTap});

  @override
  Widget build(BuildContext context) {
    var isMobile = ResponsiveLayout.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: isMobile ? 60 : 100,
      ),
      child: isMobile
          ? Column(
              // Removed const due to non-const children
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EntranceFader(
                  offset: Offset(0, 20),
                  duration: Duration(milliseconds: 500),
                  child: _HeroTextContent(onViewAppsTap: onViewAppsTap),
                ),
                SizedBox(height: 60),
                EntranceFader(
                  delay: Duration(milliseconds: 400),
                  offset: Offset(0, 40),
                  child: Center(child: _PhoneMockupDisplay()),
                ),
              ],
            )
          : Row(
              // Removed const due to non-const children
              children: [
                Expanded(
                  child: EntranceFader(
                    offset: Offset(0, -20),
                    child: _HeroTextContent(onViewAppsTap: onViewAppsTap),
                  ),
                ),
                Expanded(
                  child: EntranceFader(
                    delay: Duration(milliseconds: 300),
                    offset: Offset(20, 0),
                    child: Center(child: _PhoneMockupDisplay()),
                  ),
                ),
              ],
            ),
    );
  }
}

class _HeroTextContent extends StatelessWidget {
  final VoidCallback? onViewAppsTap;

  const _HeroTextContent({this.onViewAppsTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EntranceFader(
          delay: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Flutter Mobile Expert",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        EntranceFader(
          delay: const Duration(milliseconds: 200),
          child: Text(
            "Building high-quality\nmobile apps with Flutter",
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 40 : 60,
              fontWeight: FontWeight.bold,
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        EntranceFader(
          delay: const Duration(milliseconds: 300),
          child: Text(
            AppConstants.summary,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: 40),
        EntranceFader(
          delay: const Duration(milliseconds: 400),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              ElevatedButton(
                onPressed: onViewAppsTap,
                child: const Text("View Apps"),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                child: const Text("Download CV"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        EntranceFader(
          delay: const Duration(milliseconds: 500),
          child: Row(
            children: [
              _PlatformBadge(icon: Icons.android, label: "Android"),
              const SizedBox(width: 20),
              _PlatformBadge(icon: Icons.apple, label: "iOS"),
              const SizedBox(width: 20),
              _PlatformBadge(icon: Icons.language, label: "Web"),
              const SizedBox(width: 20),
              _PlatformBadge(icon: Icons.desktop_windows, label: "Desktop"),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PlatformBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).textTheme.bodySmall?.color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class _PhoneMockupDisplay extends StatelessWidget {
  const _PhoneMockupDisplay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative background blob
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
          ),
        ),
        Transform.rotate(
          angle: -0.1,
          child: Container(
            width: 260,
            height: 520,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
              border: Border.all(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withOpacity(0.1),
                width: 8,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                children: [
                  // Status bar area
                  Container(
                    height: 30,
                    color: Theme.of(context).primaryColor,
                    alignment: Alignment.center,
                    child: Container(
                      width: 60,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // App Content Mockup
                  Expanded(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.menu),
                              Text(
                                "My Portfolio",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                              const Icon(Icons.notifications_none),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).colorScheme.tertiary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Mobile First",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Experience",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.code,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.brush,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Navigation Bar Mockup
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.home, color: Theme.of(context).primaryColor),
                        const Icon(Icons.search, color: Colors.grey),
                        const Icon(Icons.person, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
