import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _expandedIndex = 0; // First one expanded by default

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
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
      color: isDark ? AppColors.bgSurface : const Color(0xFFF1F5F9),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'CAREER'),
          const SizedBox(height: 16),
          Text(
            'Work Experience',
            style: TextStyle(
              fontSize: isMobile ? 32 : 44,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '4+ years of professional Flutter development across startups',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 60),

          // Timeline
          FadeTransition(
            opacity: _controller,
            child: _Timeline(
              experiences: AppConstants.experience,
              expandedIndex: _expandedIndex,
              onExpandChanged: (i) => setState(() => _expandedIndex = i),
              isDark: isDark,
              isMobile: isMobile,
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<ExperienceItem> experiences;
  final int expandedIndex;
  final ValueChanged<int> onExpandChanged;
  final bool isDark;
  final bool isMobile;

  const _Timeline({
    required this.experiences,
    required this.expandedIndex,
    required this.onExpandChanged,
    required this.isDark,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    // Single unified timeline - works on both mobile and desktop
    return Column(
      children: experiences.asMap().entries.map((entry) {
        final isLast = entry.key == experiences.length - 1;
        final isActive = expandedIndex == entry.key;
        final double dotColumnWidth = isMobile ? 32 : 48;
        return Stack(
          children: [
            // Connecting line that fills remaining height
            if (!isLast)
              Positioned(
                left: dotColumnWidth / 2 - 1, // center line
                top: 48, // slightly below the dot
                bottom: 0,
                child: Container(
                  width: 2,
                  color: isDark ? AppColors.border : AppColors.lightBorder,
                ),
              ),
            // Content Row (determines the intrinsic height of the stack automatically)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: dot 
                SizedBox(
                  width: dotColumnWidth,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 36), // Align roughly with card title
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 18 : 12,
                        height: isActive ? 18 : 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isActive
                              ? const LinearGradient(
                                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                )
                              : null,
                          color: isActive
                              ? null
                              : (isDark ? AppColors.bgCard : AppColors.lightBorder),
                          border: Border.all(
                            color: isActive
                                ? Colors.transparent
                                : (isDark
                                    ? AppColors.borderHover
                                    : const Color(0xFFD1D5DB)),
                            width: 2,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ]
                              : [],
                        ),
                      ),
                    ),
                  ),
                ),
                // Right: card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isMobile ? 12 : 20,
                      bottom: isLast ? 0 : 16,
                    ),
                    child: _TimelineCard(
                      experience: entry.value,
                      isActive: isActive,
                      onTap: () => onExpandChanged(entry.key),
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }
}


class _TimelineCard extends StatefulWidget {
  final ExperienceItem experience;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  const _TimelineCard({
    required this.experience,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.isDark ? AppColors.bgCard : Colors.white,
            border: Border.all(
              color: widget.isActive
                  ? const Color(0xFF4F46E5).withOpacity(0.4)
                  : (widget.isDark ? AppColors.border : AppColors.lightBorder),
              width: widget.isActive ? 1.5 : 1,
            ),
            boxShadow: widget.isActive || _hovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(widget.isActive ? 0.12 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.experience.role,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: widget.isDark ? AppColors.textPrimary : AppColors.bgDeep,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.experience.company,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF4F46E5).withOpacity(0.08),
                        ),
                        child: Text(
                          widget.experience.period,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expandable description
              AnimatedCrossFade(
                firstChild: const SizedBox(height: 0),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Divider(
                      color: widget.isDark ? AppColors.border : AppColors.lightBorder,
                    ),
                    const SizedBox(height: 12),
                    ...widget.experience.description.split('\n').map(
                      (line) => line.isEmpty
                          ? const SizedBox(height: 4)
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                line,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: widget.isDark
                                      ? AppColors.textSecondary
                                      : const Color(0xFF4B5563),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                crossFadeState: widget.isActive
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

