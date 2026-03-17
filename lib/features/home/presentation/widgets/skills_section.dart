import 'package:flutter/material.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _triggered = false;

  static const List<_SkillCategory> _categories = [
    _SkillCategory(
      title: 'Mobile Development',
      icon: Icons.phone_android_rounded,
      color: Color(0xFF4F46E5),
      skills: [
        _Skill('Flutter', 0.95),
        _Skill('Dart', 0.95),
        _Skill('Android (Native)', 0.70),
        _Skill('iOS', 0.70),
      ],
    ),
    _SkillCategory(
      title: 'State Management',
      icon: Icons.account_tree_rounded,
      color: Color(0xFF7C3AED),
      skills: [
        _Skill('Bloc / Cubit', 0.95),
        _Skill('Riverpod', 0.95),
        _Skill('Provider', 0.92),
        _Skill('GetX', 0.96),
      ],
    ),
    _SkillCategory(
      title: 'Backend & Cloud',
      icon: Icons.cloud_rounded,
      color: Color(0xFF06B6D4),
      skills: [
        _Skill('Firebase', 0.88),
        _Skill('REST APIs', 0.90),
        _Skill('Google Cloud', 0.72),
        _Skill('Dart Shelf', 0.65),
      ],
    ),
    _SkillCategory(
      title: 'Architecture & Tools',
      icon: Icons.architecture_rounded,
      color: Color(0xFF3FB950),
      skills: [
        _Skill('Clean Architecture', 0.92),
        _Skill('MVVM / MVC', 0.88),
        _Skill('Git / CI/CD', 0.85),
        _Skill('Payment Gateways', 0.80),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_triggered) {
          _triggered = true;
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.bgDeep : AppColors.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'EXPERTISE'),
          const SizedBox(height: 16),
          Text(
            'Technical Skills',
            style: TextStyle(
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Specialized in Flutter ecosystem with broad full-stack experience',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 60),

          // Tech grid (visual badges)
          _TechGrid(isDark: isDark),
          const SizedBox(height: 60),

          // Two-column skill bars – using LayoutBuilder for true responsiveness
          LayoutBuilder(
            builder: (context, constraints) {
              final useColumns = constraints.maxWidth > 600;
              if (!useColumns) {
                // Mobile: single column
                return Column(
                  children: _categories
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _SkillCategoryCard(
                            category: entry.value,
                            controller: _controller,
                            delay: Duration(milliseconds: entry.key * 150),
                            isDark: isDark,
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              // Desktop/tablet: two-column
              final left = _categories
                  .asMap()
                  .entries
                  .where((e) => e.key.isEven)
                  .toList();
              final right = _categories
                  .asMap()
                  .entries
                  .where((e) => e.key.isOdd)
                  .toList();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: left
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _SkillCategoryCard(
                                category: entry.value,
                                controller: _controller,
                                delay: Duration(milliseconds: entry.key * 150),
                                isDark: isDark,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: right
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _SkillCategoryCard(
                                category: entry.value,
                                controller: _controller,
                                delay: Duration(milliseconds: entry.key * 150),
                                isDark: isDark,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Skill {
  final String name;
  final double level;
  const _Skill(this.name, this.level);
}

class _SkillCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<_Skill> skills;
  const _SkillCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.skills,
  });
}

class _SkillCategoryCard extends StatelessWidget {
  final _SkillCategory category;
  final AnimationController controller;
  final Duration delay;
  final bool isDark;

  const _SkillCategoryCard({
    required this.category,
    required this.controller,
    required this.delay,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.bgCard : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.border : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: category.color.withOpacity(0.12),
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...category.skills.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _AnimatedSkillBar(
                skill: entry.value,
                controller: controller,
                color: category.color,
                delay: delay + Duration(milliseconds: entry.key * 80),
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSkillBar extends StatelessWidget {
  final _Skill skill;
  final AnimationController controller;
  final Color color;
  final Duration delay;
  final bool isDark;

  const _AnimatedSkillBar({
    required this.skill,
    required this.controller,
    required this.color,
    required this.delay,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final totalDuration = 1400.0;
        final delayFraction = delay.inMilliseconds / totalDuration;
        final progress =
            ((controller.value - delayFraction) / (1 - delayFraction)).clamp(
              0.0,
              1.0,
            );
        final easedProgress = Curves.easeOutCubic.transform(
          progress.toDouble(),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  skill.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondary
                        : const Color(0xFF4B5563),
                  ),
                ),
                Text(
                  '${(skill.level * 100 * easedProgress).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.06),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: skill.level * easedProgress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Tech Grid with hover tooltips ─────────────────────────────────────────

class _TechGrid extends StatelessWidget {
  final bool isDark;
  const _TechGrid({required this.isDark});

  static const List<_TechItem> _techs = [
    _TechItem('Flutter', Icons.flutter_dash, Color(0xFF54C5F8)),
    _TechItem(
      'Firebase',
      Icons.local_fire_department_rounded,
      Color(0xFFFFA000),
    ),
    _TechItem('Dart', Icons.code_rounded, Color(0xFF0175C2)),
    _TechItem('Android', Icons.android_rounded, Color(0xFF3DDC84)),
    _TechItem('iOS', Icons.phone_iphone_rounded, Color(0xFF888888)),
    _TechItem('Git', Icons.merge_type_rounded, Color(0xFFF05032)),
    _TechItem('REST API', Icons.api_rounded, Color(0xFF4F46E5)),
    _TechItem('Figma', Icons.design_services_rounded, Color(0xFFA259FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _techs
          .map((tech) => _TechChip(tech: tech, isDark: isDark))
          .toList(),
    );
  }
}

class _TechItem {
  final String name;
  final IconData icon;
  final Color color;
  const _TechItem(this.name, this.icon, this.color);
}

class _TechChip extends StatefulWidget {
  final _TechItem tech;
  final bool isDark;
  const _TechChip({required this.tech, required this.isDark});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: _hovered
              ? widget.tech.color.withOpacity(0.12)
              : (widget.isDark ? AppColors.bgCard : Colors.white),
          border: Border.all(
            color: _hovered
                ? widget.tech.color.withOpacity(0.5)
                : (widget.isDark ? AppColors.border : AppColors.lightBorder),
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.tech.color.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.tech.icon,
              size: 18,
              color: _hovered
                  ? widget.tech.color
                  : (widget.isDark
                        ? AppColors.textSecondary
                        : const Color(0xFF6B7280)),
            ),
            const SizedBox(width: 8),
            Text(
              widget.tech.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _hovered
                    ? widget.tech.color
                    : (widget.isDark
                          ? AppColors.textSecondary
                          : const Color(0xFF374151)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
