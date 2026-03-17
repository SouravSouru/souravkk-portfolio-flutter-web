import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _statsController;

  late Animation<double> _opacity;
  late Animation<Offset> _slideLeft;
  late Animation<Offset> _slideRight;

  final List<_StatItem> _stats = [
    _StatItem(value: 4, suffix: '+', label: 'Years\nExperience'),
    _StatItem(value: 15, suffix: '+', label: 'Apps\nDelivered'),
    _StatItem(value: 3, suffix: '', label: 'Companies\nWorked'),
    _StatItem(value: 5, suffix: '+', label: 'Platforms\nSupported'),
  ];

  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacity = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _slideLeft = Tween<Offset>(
      begin: const Offset(-0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));
    _slideRight = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_visible) {
          _visible = true;
          _entryController.forward();
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) _statsController.forward();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.bgSurface : const Color(0xFFF1F5F9),
      child: Stack(
        children: [
          // Decorative blur circle
          Positioned(
            right: -100,
            top: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7C3AED).withOpacity(isDark ? 0.06 : 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 100,
            ),
            child: FadeTransition(
              opacity: _opacity,
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: _slideLeft,
                          child: _buildTextContent(context, isDark, isMobile),
                        ),
                        const SizedBox(height: 48),
                        SlideTransition(
                          position: _slideRight,
                          child: _buildStatsGrid(context, isDark),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: SlideTransition(
                            position: _slideLeft,
                            child: _buildTextContent(context, isDark, isMobile),
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          flex: 4,
                          child: SlideTransition(
                            position: _slideRight,
                            child: _buildStatsGrid(context, isDark),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(label: 'ABOUT ME'),
        const SizedBox(height: 16),
        Text(
          'Crafting scalable\nmobile experiences',
          style: TextStyle(
            fontSize: isMobile ? 32 : 44,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            height: 1.15,
            color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
          ),
        ),
        const SizedBox(height: 24),
        ...AppConstants.aboutDescription.split('\n\n').map(
          (para) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              para,
              style: TextStyle(
                fontSize: 16,
                height: 1.75,
                color: isDark ? AppColors.textSecondary : const Color(0xFF4B5563),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _SkillsChipRow(isDark: isDark),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: _stats.asMap().entries.map((entry) {
        final delay = entry.key * 150;
        return _AnimatedStatCard(
          stat: entry.value,
          controller: _statsController,
          delay: Duration(milliseconds: delay),
          isDark: isDark,
        );
      }).toList(),
    );
  }
}

class _StatItem {
  final int value;
  final String suffix;
  final String label;

  const _StatItem({
    required this.value,
    required this.suffix,
    required this.label,
  });
}

class _AnimatedStatCard extends StatelessWidget {
  final _StatItem stat;
  final AnimationController controller;
  final Duration delay;
  final bool isDark;

  const _AnimatedStatCard({
    required this.stat,
    required this.controller,
    required this.delay,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = math.min(
          1.0,
          math.max(
            0.0,
            (controller.value - delay.inMilliseconds / 1200.0) /
                (1 - delay.inMilliseconds / 1200.0).clamp(0.1, 1.0),
          ),
        );
        final displayValue = (stat.value * progress).toInt();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? AppColors.bgCard : Colors.white,
            border: Border.all(
              color: isDark ? AppColors.border : AppColors.lightBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ).createShader(bounds),
                child: Text(
                  '$displayValue${stat.suffix}',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -2,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                stat.label,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkillsChipRow extends StatelessWidget {
  final bool isDark;
  const _SkillsChipRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.primarySkills.take(8).map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            border: Border.all(
              color: const Color(0xFF4F46E5).withOpacity(0.2),
            ),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4F46E5),
            ),
          ),
        );
      }).toList(),
    );
  }
}


