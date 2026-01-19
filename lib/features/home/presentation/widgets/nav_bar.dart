import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/entrance_fader.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatelessWidget {
  final Function(int) onNavTap;

  const NavBar({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "<SouravKK />",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          if (!ResponsiveLayout.isMobile(context))
            Row(
              children: [
                EntranceFader(
                  delay: const Duration(milliseconds: 100),
                  offset: const Offset(0, -10),
                  child: _NavItem(title: "Home", onTap: () => onNavTap(0)),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 150),
                  offset: const Offset(0, -10),
                  child: _NavItem(title: "About", onTap: () => onNavTap(1)),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 200),
                  offset: const Offset(0, -10),
                  child: _NavItem(title: "Skills", onTap: () => onNavTap(2)),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 250),
                  offset: const Offset(0, -10),
                  child: _NavItem(
                    title: "Experience",
                    onTap: () => onNavTap(3),
                  ),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 300),
                  offset: const Offset(0, -10),
                  child: _NavItem(title: "Projects", onTap: () => onNavTap(4)),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 350),
                  offset: const Offset(0, -10),
                  child: _NavItem(title: "Contact", onTap: () => onNavTap(5)),
                ),
                const SizedBox(width: 20),
                EntranceFader(
                  delay: const Duration(milliseconds: 400),
                  offset: const Offset(0, -10),
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => RotationTransition(
                        turns: Tween(begin: 0.75, end: 1.0).animate(anim),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: Icon(
                        key: ValueKey(
                          context.watch<ThemeCubit>().state == ThemeMode.dark,
                        ),
                        context.watch<ThemeCubit>().state == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                    ),
                    onPressed: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ),
                const SizedBox(width: 20),
                EntranceFader(
                  delay: const Duration(milliseconds: 450),
                  offset: const Offset(0, -10),
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(AppConstants.cvUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: const Text("Resume"),
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Open drawer or modal
                Scaffold.of(context).openDrawer();
              },
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
