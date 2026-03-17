import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileDrawer extends StatelessWidget {
  final Function(int) onNavTap;

  const MobileDrawer({super.key, required this.onNavTap});

  static const List<_DrawerNavItem> _items = [
    _DrawerNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
    _DrawerNavItem(icon: Icons.person_rounded, label: 'About', index: 1),
    _DrawerNavItem(icon: Icons.code_rounded, label: 'Skills', index: 2),
    _DrawerNavItem(icon: Icons.work_history_rounded, label: 'Experience', index: 3),
    _DrawerNavItem(icon: Icons.rocket_launch_rounded, label: 'Projects', index: 4),
    _DrawerNavItem(icon: Icons.mail_rounded, label: 'Contact', index: 5),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? AppColors.bgCard : Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1e1040), Color(0xFF0D1117)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'SK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Sourav K K',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Flutter Developer',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Nav items
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            return _DrawerItem(
              item: item,
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                onNavTap(item.index);
              },
            );
          }),

          const Spacer(),

          // Theme toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isCurrentlyDark = mode == ThemeMode.dark;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (isDark ? AppColors.bgGlass : const Color(0xFFF3F4F6)),
                    ),
                    child: Icon(
                      isCurrentlyDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      size: 18,
                      color: isDark ? AppColors.textSecondary : const Color(0xFF374151),
                    ),
                  ),
                  title: Text(
                    isCurrentlyDark ? 'Light Mode' : 'Dark Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondary : const Color(0xFF374151),
                    ),
                  ),
                  onTap: () => context.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),
          ),

          // Resume button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'Resume',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse(AppConstants.cvUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _DrawerNavItem {
  final IconData icon;
  final String label;
  final int index;
  const _DrawerNavItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}

class _DrawerItem extends StatefulWidget {
  final _DrawerNavItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: _hovered
              ? const Color(0xFF4F46E5).withOpacity(0.08)
              : Colors.transparent,
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _hovered
                  ? const Color(0xFF4F46E5).withOpacity(0.12)
                  : (widget.isDark ? AppColors.bgGlass : const Color(0xFFF3F4F6)),
            ),
            child: Icon(
              widget.item.icon,
              size: 18,
              color: _hovered
                  ? const Color(0xFF4F46E5)
                  : (widget.isDark ? AppColors.textSecondary : const Color(0xFF374151)),
            ),
          ),
          title: Text(
            widget.item.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _hovered
                  ? const Color(0xFF4F46E5)
                  : (widget.isDark ? AppColors.textSecondary : const Color(0xFF374151)),
            ),
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
