import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.bgDeep : AppColors.lightBg,
      child: Column(
        children: [
          // Divider with gradient
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF4F46E5).withOpacity(isDark ? 0.3 : 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo + copyright
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF06B6D4)],
                      ).createShader(bounds),
                      child: const Text(
                        '<SouravKK />',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '© 2026 Sourav K K. Built with Flutter & ❤️',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMuted : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),

                // Social icons
                Row(
                  children: [
                    _FooterSocialIcon(
                      icon: FontAwesomeIcons.github,
                      url: AppConstants.githubUrl,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _FooterSocialIcon(
                      icon: FontAwesomeIcons.linkedin,
                      url: AppConstants.linkedinUrl,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _FooterSocialIcon(
                      isMaterial: true,
                      icon: Icons.email_rounded,
                      url: 'mailto:${AppConstants.email}',
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final bool isDark;
  final bool isMaterial;

  const _FooterSocialIcon({
    required this.icon,
    required this.url,
    required this.isDark,
    this.isMaterial = false,
  });

  @override
  State<_FooterSocialIcon> createState() => _FooterSocialIconState();
}

class _FooterSocialIconState extends State<_FooterSocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _hovered
                ? const Color(0xFF4F46E5).withOpacity(0.12)
                : Colors.transparent,
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF4F46E5).withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Center(
            child: widget.isMaterial
                ? Icon(
                    widget.icon,
                    size: 16,
                    color: _hovered
                        ? const Color(0xFF4F46E5)
                        : (widget.isDark ? AppColors.textMuted : const Color(0xFF9CA3AF)),
                  )
                : FaIcon(
                    widget.icon,
                    size: 14,
                    color: _hovered
                        ? const Color(0xFF4F46E5)
                        : (widget.isDark ? AppColors.textMuted : const Color(0xFF9CA3AF)),
                  ),
          ),
        ),
      ),
    );
  }
}
