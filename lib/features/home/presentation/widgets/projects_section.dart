import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_label.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _selectedFilter = 'All';

  static const List<String> _filters = [
    'All',
    'Flutter',
    'Firebase',
    'REST API',
  ];

  List<ProjectItem> get _filteredProjects {
    if (_selectedFilter == 'All') return AppConstants.projects;
    return AppConstants.projects
        .where((p) => p.techStack
            .any((t) => t.toLowerCase().contains(_selectedFilter.toLowerCase())))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      color: isDark ? AppColors.bgDeep : AppColors.lightBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(label: 'PORTFOLIO'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Featured Apps',
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 44,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Production apps shipped across mobile, web and desktop',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Filter tabs
          _FilterRow(
            filters: _filters,
            selected: _selectedFilter,
            onChanged: (f) => setState(() => _selectedFilter = f),
            isDark: isDark,
          ),
          const SizedBox(height: 40),

          // Project grid
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: child,
            ),
            child: GridView.builder(
              key: ValueKey(_selectedFilter),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 3 : (isMobile ? 1 : 2),
                mainAxisExtent: 340,
                crossAxisSpacing: isMobile ? 16 : 24,
                mainAxisSpacing: isMobile ? 16 : 24,
              ),
              itemCount: _filteredProjects.length,
              itemBuilder: (context, index) {
                final project = _filteredProjects[index];
                return _ProjectCard(
                  project: project,
                  index: index,
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: f,
                  isSelected: f == selected,
                  onTap: () => onChanged(f),
                  isDark: isDark,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  )
                : null,
            color: widget.isSelected
                ? null
                : (widget.isDark ? AppColors.bgCard : Colors.white),
            border: Border.all(
              color: widget.isSelected
                  ? Colors.transparent
                  : (_hovered
                      ? const Color(0xFF4F46E5).withOpacity(0.4)
                      : (widget.isDark ? AppColors.border : AppColors.lightBorder)),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : (_hovered
                      ? const Color(0xFF4F46E5)
                      : (widget.isDark ? AppColors.textSecondary : const Color(0xFF374151))),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Project Card ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatefulWidget {
  final ProjectItem project;
  final int index;
  final bool isDark;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.isDark,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _hoverController;
  late Animation<double> _overlayOpacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _overlayOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: () => _showProjectDetails(context, widget.project),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) => Transform.scale(
            scale: _scale.value,
            child: child,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: widget.isDark ? AppColors.bgCard : Colors.white,
              border: Border.all(
                color: _hovered
                    ? const Color(0xFF4F46E5).withOpacity(0.4)
                    : (widget.isDark ? AppColors.border : AppColors.lightBorder),
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? const Color(0xFF4F46E5).withOpacity(0.2)
                      : Colors.black.withOpacity(widget.isDark ? 0.4 : 0.05),
                  blurRadius: _hovered ? 32 : 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image / Preview area
                  Expanded(
                    flex: 9,
                    child: _ProjectImageArea(
                      project: widget.project,
                      overlayOpacity: _overlayOpacity,
                      isDark: widget.isDark,
                    ),
                  ),

                  // Content area
                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: widget.isDark ? AppColors.textPrimary : AppColors.bgDeep,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.project.description,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: widget.isDark
                                  ? AppColors.textSecondary
                                  : const Color(0xFF6B7280),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          // Tech stack
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.project.techStack.take(3).map((t) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: widget.isDark 
                                      ? const Color(0xFF4F46E5).withOpacity(0.15)
                                      : const Color(0xFF4F46E5).withOpacity(0.08),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    color: widget.isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Spacer(),
                          // Links row
                          Row(
                            children: [
                              if (widget.project.androidLink != null)
                                _SmallStoreButton(
                                  icon: FontAwesomeIcons.googlePlay,
                                  label: 'Play Store',
                                  url: widget.project.androidLink!,
                                  isDark: widget.isDark,
                                ),
                              if (widget.project.androidLink != null &&
                                  widget.project.iosLink != null)
                                const SizedBox(width: 8),
                              if (widget.project.iosLink != null)
                                _SmallStoreButton(
                                  icon: FontAwesomeIcons.appStore,
                                  label: 'App Store',
                                  url: widget.project.iosLink!,
                                  isDark: widget.isDark,
                                ),
                              if (widget.project.androidLink == null &&
                                  widget.project.iosLink == null)
                                Text(
                                  'Internal App',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: widget.isDark
                                        ? AppColors.textMuted
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectImageArea extends StatelessWidget {
  final ProjectItem project;
  final Animation<double> overlayOpacity;
  final bool isDark;

  const _ProjectImageArea({
    required this.project,
    required this.overlayOpacity,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4F46E5).withOpacity(isDark ? 0.2 : 0.12),
                const Color(0xFF7C3AED).withOpacity(isDark ? 0.15 : 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // App icon
        Center(
          child: AnimatedBuilder(
            animation: overlayOpacity,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -overlayOpacity.value * 10),
              child: child,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: project.iconUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            project.iconUrl!,
                            fit: BoxFit.cover,
                            cacheWidth: 128,
                            cacheHeight: 128,
                            errorBuilder: (_, __, ___) =>
                                _DefaultIcon(isDark: isDark),
                          ),
                        )
                      : _DefaultIcon(isDark: isDark),
                ),
              ],
            ),
          ),
        ),

        // Hover overlay
        FadeTransition(
          opacity: overlayOpacity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4F46E5).withOpacity(0.85),
                  const Color(0xFF7C3AED).withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.open_in_new_rounded, color: Colors.white, size: 28),
                  SizedBox(height: 8),
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

class _DefaultIcon extends StatelessWidget {
  final bool isDark;
  const _DefaultIcon({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        ),
      ),
      child: const Icon(Icons.apps_rounded, color: Colors.white, size: 36),
    );
  }
}

class _SmallStoreButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool isDark;

  const _SmallStoreButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.isDark,
  });

  @override
  State<_SmallStoreButton> createState() => _SmallStoreButtonState();
}

class _SmallStoreButtonState extends State<_SmallStoreButton> {
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
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _hovered
                ? const Color(0xFF4F46E5).withOpacity(0.12)
                : (widget.isDark ? AppColors.bgSurface : const Color(0xFFF3F4F6)),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF4F46E5).withOpacity(0.4)
                  : (widget.isDark ? AppColors.border : AppColors.lightBorder),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: 12,
                color: _hovered
                    ? const Color(0xFF4F46E5)
                    : (widget.isDark ? AppColors.textSecondary : const Color(0xFF374151)),
              ),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _hovered
                      ? const Color(0xFF4F46E5)
                      : (widget.isDark ? AppColors.textSecondary : const Color(0xFF374151)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Project Details Dialog ───────────────────────────────────────────────────

void _showProjectDetails(BuildContext context, ProjectItem project) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: ResponsiveLayout.isMobile(context)
                ? MediaQuery.of(context).size.width * 0.92
                : 540,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.border : AppColors.lightBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.5 : 0.15),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 16,
                          top: 16,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          bottom: 20,
                          child: Row(
                            children: [
                              if (project.iconUrl != null)
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 12,
                                      )
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      project.iconUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                        child: const Icon(Icons.apps_rounded,
                                            color: Colors.white, size: 28),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    project.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    project.techStack.take(2).join(' · '),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: const Color(0xFF4F46E5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            project.description,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.65,
                              color: isDark
                                  ? AppColors.textSecondary
                                  : const Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Technologies',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: const Color(0xFF4F46E5),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: project.techStack.map((t) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0xFF4F46E5).withOpacity(0.08),
                                  border: Border.all(
                                    color: const Color(0xFF4F46E5).withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4F46E5),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (project.androidLink != null || project.iosLink != null) ...[
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                if (project.androidLink != null)
                                  Expanded(
                                    child: _DialogStoreButton(
                                      icon: FontAwesomeIcons.googlePlay,
                                      label: 'Play Store',
                                      backgroundColor: const Color(0xFF3DDC84),
                                      url: project.androidLink!,
                                    ),
                                  ),
                                if (project.androidLink != null &&
                                    project.iosLink != null)
                                  const SizedBox(width: 12),
                                if (project.iosLink != null)
                                  Expanded(
                                    child: _DialogStoreButton(
                                      icon: FontAwesomeIcons.apple,
                                      label: 'App Store',
                                      backgroundColor: const Color(0xFF1D6FEB),
                                      url: project.iosLink!,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim, secondary, child) {
      return ScaleTransition(
        scale: Tween(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        ),
        child: FadeTransition(opacity: anim, child: child),
      );
    },
  );
}

class _DialogStoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final String url;

  const _DialogStoreButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 15, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
