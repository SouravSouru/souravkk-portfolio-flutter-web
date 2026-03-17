import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeHeroSection extends StatefulWidget {
  final VoidCallback? onViewAppsTap;

  const HomeHeroSection({super.key, this.onViewAppsTap});

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;
  late AnimationController _typewriterController;
  late AnimationController _floatController;
  late AnimationController _particleController;

  late Animation<double> _bgGradient;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;
  late Animation<double> _floatAnim;

  // Typewriter state
  final List<String> _roles = [
    'Flutter Developer',
    'Mobile App Expert',
    'Clean Architecture Advocate',
    'Cross-Platform Engineer',
  ];
  int _currentRoleIndex = 0;
  final ValueNotifier<String> _displayTextNotifier = ValueNotifier('');
  bool _isDeleting = false;
  int _charIndex = 0;

  // Particles
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    // Background gradient animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgGradient = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );

    // Content entrance
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _contentOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Float animation for mockup
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Init particles
    final random = math.Random(42);
    _particles = List.generate(
      18,
      (i) => _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.3 + 0.1,
        opacity: random.nextDouble() * 0.4 + 0.1,
      ),
    );

    // Typewriter controller
    _typewriterController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 80),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(
              _isDeleting
                  ? const Duration(milliseconds: 30)
                  : const Duration(milliseconds: 120),
              _updateTypewriter,
            );
          }
        });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _contentController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _startTypewriter();
    });
  }

  // Typewriter speeds
  static const int _typingSpeedMs = 80;
  static const int _deletingSpeedMs = 40;
  static const int _pauseBeforeDeleteMs = 2000;

  void _startTypewriter() {
    _updateTypewriter();
  }

  void _updateTypewriter() {
    if (!mounted) return;
    final currentRole = _roles[_currentRoleIndex];

    if (_isDeleting) {
      if (_charIndex > 0) {
        _charIndex--;
        _displayTextNotifier.value = currentRole.substring(0, _charIndex);
      } else {
        _isDeleting = false;
        _currentRoleIndex = (_currentRoleIndex + 1) % _roles.length;
      }
    } else {
      if (_charIndex < currentRole.length) {
        _charIndex++;
        _displayTextNotifier.value = currentRole.substring(0, _charIndex);
      } else {
        _isDeleting = true;
        Future.delayed(
          const Duration(milliseconds: _pauseBeforeDeleteMs),
          _updateTypewriter,
        );
        return;
      }
    }

    final delay = _isDeleting ? _deletingSpeedMs : _typingSpeedMs;
    Future.delayed(Duration(milliseconds: delay), _updateTypewriter);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    _typewriterController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    _displayTextNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: isMobile ? null : size.height - 72,
      child: Stack(
        children: [
          // Animated gradient background
          Positioned.fill(
            child: _AnimatedGradientBg(animation: _bgGradient, isDark: isDark),
          ),

          // Particle field
          Positioned.fill(
            child: _ParticleField(
              particles: _particles,
              animation: _particleController,
              isDark: isDark,
            ),
          ),

          // Grid pattern overlay
          Positioned.fill(child: _GridOverlay(isDark: isDark)),

          // Main content
          FadeTransition(
            opacity: _contentOpacity,
            child: SlideTransition(
              position: _contentSlide,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 80,
                  vertical: isMobile ? 80 : 0,
                ),
                child: isMobile
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroContent(
                              displayTextNotifier: _displayTextNotifier,
                              onViewAppsTap: widget.onViewAppsTap,
                              isMobile: isMobile,
                            ),
                            const SizedBox(height: 60),
                            Center(
                              child: AnimatedBuilder(
                                animation: _floatAnim,
                                builder: (context, child) =>
                                    Transform.translate(
                                      offset: Offset(0, _floatAnim.value),
                                      child: child,
                                    ),
                                child: _HeroVisual(isDark: isDark),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _HeroContent(
                              displayTextNotifier: _displayTextNotifier,
                              onViewAppsTap: widget.onViewAppsTap,
                              isMobile: isMobile,
                            ),
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: AnimatedBuilder(
                                animation: _floatAnim,
                                builder: (context, child) =>
                                    Transform.translate(
                                      offset: Offset(0, _floatAnim.value),
                                      child: child,
                                    ),
                                child: _HeroVisual(isDark: isDark),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // Scroll indicator (desktop only)
          if (!isMobile)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: _ScrollIndicator(),
            ),
        ],
      ),
    );
  }
}

// ─── Animated Gradient Background ───────────────────────────────────────────

class _AnimatedGradientBg extends StatelessWidget {
  final Animation<double> animation;
  final bool isDark;

  const _AnimatedGradientBg({required this.animation, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center:
                    Alignment.lerp(
                      const Alignment(-0.8, -0.6),
                      const Alignment(0.8, 0.6),
                      animation.value,
                    ) ??
                    Alignment.topLeft,
                radius: 1.8,
                colors: isDark
                    ? [
                        const Color(0xFF1a1040),
                        const Color(0xFF060A10),
                        const Color(0xFF060A10),
                      ]
                    : [
                        const Color(0xFFEEF2FF),
                        const Color(0xFFF8FAFC),
                        const Color(0xFFF8FAFC),
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Grid Overlay ─────────────────────────────────────────────────────────────

class _GridOverlay extends StatelessWidget {
  final bool isDark;
  const _GridOverlay({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDark ? 0.04 : 0.05,
      child: CustomPaint(
        painter: _GridPainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isDark;
  _GridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white : Colors.black
      ..strokeWidth = 0.5;

    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

// ─── Particle System ─────────────────────────────────────────────────────────

class _Particle {
  double x, y, size, speed, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticleField extends StatelessWidget {
  final List<_Particle> particles;
  final Animation<double> animation;
  final bool isDark;

  const _ParticleField({
    required this.particles,
    required this.animation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return CustomPaint(
            // The particle pain uses heavy masking/blur effects, isolated perfectly here.
            painter: _ParticlePainter(
              particles: particles,
              progress: animation.value,
              isDark: isDark,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final bool isDark;

  const _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.y + progress * p.speed) % 1.0;
      final x = p.x + math.sin(progress * math.pi * 2 * p.speed + p.x) * 0.02;
      final paint = Paint()
        ..color = (isDark ? const Color(0xFF4F46E5) : const Color(0xFF6366F1))
            .withOpacity(p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
      canvas.drawCircle(Offset(x * size.width, y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

// ─── Hero Content ────────────────────────────────────────────────────────────

class _HeroContent extends StatelessWidget {
  final ValueNotifier<String> displayTextNotifier;
  final VoidCallback? onViewAppsTap;
  final bool isMobile;

  const _HeroContent({
    required this.displayTextNotifier,
    this.onViewAppsTap,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.4)),
            color: const Color(0xFF4F46E5).withOpacity(0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3FB950),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Available for Freelance',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondary
                      : const Color(0xFF4F46E5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Name
        Text(
          'Sourav K K',
          style: TextStyle(
            fontSize: isMobile ? 48 : 68,
            fontWeight: FontWeight.w800,
            letterSpacing: -2.0,
            height: 1.0,
            color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
          ),
        ),
        const SizedBox(height: 12),

        // Typewriter role
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: displayTextNotifier,
              builder: (context, text, child) {
                return AnimatedGradientText(text: text, isMobile: isMobile);
              },
            ),
            // Cursor
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 2.5,
                height: isMobile ? 26 : 34,
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Description
        Text(
          AppConstants.summary,
          style: TextStyle(
            fontSize: isMobile ? 15 : 17,
            height: 1.7,
            color: isDark ? AppColors.textSecondary : const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 36),

        // CTAs
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            GradientButton(
              label: 'View Projects',
              icon: Icons.rocket_launch_rounded,
              onPressed: onViewAppsTap,
            ),
            GradientButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              outlined: true,
              onPressed: () async {
                final Uri url = Uri.parse(AppConstants.cvUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Social links
        Row(
          children: [
            _SocialLink(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              url: AppConstants.githubUrl,
            ),
            const SizedBox(width: 20),
            _SocialLink(
              icon: FontAwesomeIcons.linkedin,
              label: 'LinkedIn',
              url: AppConstants.linkedinUrl,
            ),
            const SizedBox(width: 20),
            _SocialLink(
              icon: Icons.email_rounded,
              label: 'Email',
              url: 'mailto:${AppConstants.email}',
              isMaterial: true,
            ),
          ],
        ),
        const SizedBox(height: 40),

        // Platform badges
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: const [
            _PlatformBadge(icon: Icons.phone_android_rounded, label: 'Android'),
            _PlatformBadge(icon: Icons.phone_iphone_rounded, label: 'iOS'),
            _PlatformBadge(icon: Icons.language_rounded, label: 'Web'),
            _PlatformBadge(
              icon: Icons.desktop_windows_rounded,
              label: 'Desktop',
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool isMaterial;

  const _SocialLink({
    required this.icon,
    required this.label,
    required this.url,
    this.isMaterial = false,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF4F46E5).withOpacity(0.5)
                  : (isDark ? AppColors.border : AppColors.lightBorder),
            ),
            color: _hovered
                ? const Color(0xFF4F46E5).withOpacity(0.08)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isMaterial
                  ? Icon(
                      widget.icon,
                      size: 16,
                      color: _hovered
                          ? const Color(0xFF4F46E5)
                          : (isDark
                                ? AppColors.textSecondary
                                : const Color(0xFF374151)),
                    )
                  : FaIcon(
                      widget.icon,
                      size: 15,
                      color: _hovered
                          ? const Color(0xFF4F46E5)
                          : (isDark
                                ? AppColors.textSecondary
                                : const Color(0xFF374151)),
                    ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _hovered
                      ? const Color(0xFF4F46E5)
                      : (isDark
                            ? AppColors.textSecondary
                            : const Color(0xFF374151)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlatformBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isDark ? AppColors.bgCard : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.border : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hero Visual ─────────────────────────────────────────────────────────────

class _HeroVisual extends StatefulWidget {
  final bool isDark;
  const _HeroVisual({required this.isDark});

  @override
  State<_HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<_HeroVisual>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: 380,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbitController, _pulse]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF4F46E5).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Rotating orbit ring 1
              Transform.rotate(
                angle: _orbitController.value * 2 * math.pi,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4F46E5).withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 320 / 2 - 12,
                        child: _OrbitDot(color: const Color(0xFF4F46E5)),
                      ),
                    ],
                  ),
                ),
              ),

              // Rotating orbit ring 2
              Transform.rotate(
                angle: -_orbitController.value * 2 * math.pi * 0.7,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7C3AED).withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 250 / 2 - 10,
                        child: _OrbitDot(
                          color: const Color(0xFF7C3AED),
                          size: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center card
              Transform.scale(
                scale: _pulse.value,
                child: _CenterCard(isDark: widget.isDark),
              ),

              // Tech badges orbiting
              ..._buildTechBadges(),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildTechBadges() {
    final badges = [
      {'label': 'Flutter', 'angle': 0.0},
      {'label': 'Dart', 'angle': math.pi / 2},
      {'label': 'Firebase', 'angle': math.pi},
      {'label': 'Bloc', 'angle': 3 * math.pi / 2},
    ];

    return badges.map((badge) {
      final angle =
          (badge['angle'] as double) + _orbitController.value * math.pi * 2;
      final radius = 155.0;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;

      return Transform.translate(
        offset: Offset(x, y),
        child: _TechBadge(label: badge['label'] as String),
      );
    }).toList();
  }
}

class _OrbitDot extends StatelessWidget {
  final Color color;
  final double size;
  const _OrbitDot({required this.color, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  final String label;
  const _TechBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.bgCard : Colors.white,
        border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.15),
            blurRadius: 12,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.accentBlue : const Color(0xFF4F46E5),
        ),
      ),
    );
  }
}

class _CenterCard extends StatelessWidget {
  final bool isDark;
  const _CenterCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flutter_dash, color: Colors.white, size: 48),
          const SizedBox(height: 8),
          const Text(
            '4+ Years',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Experience',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Scroll Indicator ────────────────────────────────────────────────────────

class _ScrollIndicator extends StatefulWidget {
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _bounce = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounce.value),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scroll to explore',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : const Color(0xFF9CA3AF),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? AppColors.textMuted : const Color(0xFF9CA3AF),
            size: 22,
          ),
        ],
      ),
    );
  }
}

// ─── Animated Gradient Text ───────────────────────────────────────────────────

class AnimatedGradientText extends StatefulWidget {
  final String text;
  final bool isMobile;

  const AnimatedGradientText({
    super.key,
    required this.text,
    required this.isMobile,
  });

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shader =
            LinearGradient(
              colors: const [
                Color(0xFF4F46E5),
                Color(0xFF7C3AED),
                Color(0xFF06B6D4),
                Color(
                  0xFF4F46E5,
                ), // Loop back to start color for smooth rotation
              ],
              stops: const [0.0, 0.33, 0.66, 1.0],
              begin: Alignment(-1 + (_controller.value * 2), 0),
              end: Alignment(1 + (_controller.value * 2), 0),
            ).createShader(
              const Rect.fromLTWH(0, 0, 300, 50),
            ); // Approximate bounds for text

        return Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.isMobile ? 22 : 30,
            fontWeight: FontWeight.w600,
            foreground: Paint()..shader = shader,
          ),
        );
      },
    );
  }
}
