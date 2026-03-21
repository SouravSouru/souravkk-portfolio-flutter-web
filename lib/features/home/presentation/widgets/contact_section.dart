import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/email_service.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/section_label.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitted = false;
  bool _isLoading = false;
  bool _usedFallback = false;
  String _resultMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await EmailService.sendEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (!mounted) return;

      if (result.success) {
        setState(() {
          _submitted = true;
          _isLoading = false;
          _usedFallback = result.usedFallback;
          _resultMessage = result.message;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Copy Email',
              textColor: Colors.white,
              onPressed: () {
                // Fallback: let them email directly
                _openDirectEmail();
              },
            ),
          ),
        );
      }
    }
  }

  void _openDirectEmail() async {
    final uri = Uri(scheme: 'mailto', path: AppConstants.email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _resetForm() {
    setState(() {
      _submitted = false;
      _usedFallback = false;
      _resultMessage = '';
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.bgSurface : const Color(0xFFF1F5F9),
      child: Stack(
        children: [
          // Decorative glow
          Positioned(
            left: -150,
            bottom: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF4F46E5).withOpacity(isDark ? 0.06 : 0.04),
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
              opacity: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel(label: "LET'S CONNECT"),
                  const SizedBox(height: 16),
                  Text(
                    'Get In Touch',
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 44,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "I'm open to new opportunities, collaborations and freelance projects.",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.textSecondary
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 60),

                  isMobile
                      ? Column(
                          children: [
                            _buildContactInfo(context, isDark, isMobile),
                            const SizedBox(height: 48),
                            _buildForm(context, isDark),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: _buildContactInfo(
                                context,
                                isDark,
                                isMobile,
                              ),
                            ),
                            const SizedBox(width: 80),
                            Expanded(
                              flex: 6,
                              child: _buildForm(context, isDark),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's build something\namazing together.",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.4,
            color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
          ),
        ),
        const SizedBox(height: 32),
        _ContactInfoRow(
          icon: Icons.email_rounded,
          label: 'Email',
          value: AppConstants.email,
          isDark: isDark,
          onTap: () async {
            final uri = Uri(scheme: 'mailto', path: AppConstants.email);
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        const SizedBox(height: 20),
        _ContactInfoRow(
          icon: Icons.phone_rounded,
          label: 'Phone',
          value: AppConstants.phone,
          isDark: isDark,
          onTap: () async {
            final uri = Uri(
              scheme: 'tel',
              path: AppConstants.phone.replaceAll(' ', ''),
            );
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        const SizedBox(height: 40),

        // Social links
        Text(
          'Find me on',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: isDark ? AppColors.textMuted : const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _SocialIconButton(
              icon: FontAwesomeIcons.github,
              url: AppConstants.githubUrl,
              isDark: isDark,
            ),
            const SizedBox(width: 12),
            _SocialIconButton(
              icon: FontAwesomeIcons.linkedin,
              url: AppConstants.linkedinUrl,
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, bool isDark) {
    if (_submitted) {
      return _SuccessCard(
        isDark: isDark,
        usedFallback: _usedFallback,
        message: _resultMessage,
        onSendAnother: _resetForm,
      );
    }

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(32),
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
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            _PremiumTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_rounded,
              isDark: isDark,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 20),
            _PremiumTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              isDark: isDark,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _PremiumTextField(
              controller: _messageController,
              label: 'Your Message',
              icon: Icons.message_rounded,
              maxLines: 5,
              isDark: isDark,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Message is required' : null,
            ),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: _isLoading ? 'Sending...' : 'Send Message',
                icon: _isLoading ? null : Icons.send_rounded,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Premium TextField with floating label ────────────────────────────────────

class _PremiumTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final bool isDark;
  final FormFieldValidator<String>? validator;

  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    required this.isDark,
    this.validator,
  });

  @override
  State<_PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<_PremiumTextField> {
  bool _focused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF4F46E5);
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: TextStyle(
        fontSize: 15,
        color: widget.isDark ? AppColors.textPrimary : AppColors.bgDeep,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(
          widget.icon,
          size: 18,
          color: _focused
              ? accentColor
              : (widget.isDark ? AppColors.textMuted : const Color(0xFF9CA3AF)),
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          color: _focused
              ? accentColor
              : (widget.isDark
                    ? AppColors.textSecondary
                    : const Color(0xFF6B7280)),
        ),
        filled: true,
        fillColor: widget.isDark
            ? AppColors.bgSurface
            : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.isDark ? AppColors.border : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.isDark ? AppColors.border : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF87171)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.5),
        ),
      ),
    );
  }
}

// ─── Contact Info Row ────────────────────────────────────────────────────────

class _ContactInfoRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback onTap;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ContactInfoRow> createState() => _ContactInfoRowState();
}

class _ContactInfoRowState extends State<_ContactInfoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _hovered
                    ? const Color(0xFF4F46E5).withOpacity(0.12)
                    : (widget.isDark ? AppColors.bgCard : Colors.white),
                border: Border.all(
                  color: _hovered
                      ? const Color(0xFF4F46E5).withOpacity(0.3)
                      : (widget.isDark
                            ? AppColors.border
                            : AppColors.lightBorder),
                ),
              ),
              child: Icon(
                widget.icon,
                size: 18,
                color: _hovered
                    ? const Color(0xFF4F46E5)
                    : (widget.isDark
                          ? AppColors.textSecondary
                          : const Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: widget.isDark
                        ? AppColors.textMuted
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _hovered
                        ? const Color(0xFF4F46E5)
                        : (widget.isDark
                              ? AppColors.textPrimary
                              : AppColors.bgDeep),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Social Icon ──────────────────────────────────────────────────────────────

class _SocialIconButton extends StatefulWidget {
  final IconData icon;
  final String url;
  final bool isDark;

  const _SocialIconButton({
    required this.icon,
    required this.url,
    required this.isDark,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: _hovered
                ? const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  )
                : null,
            color: _hovered
                ? null
                : (widget.isDark ? AppColors.bgCard : Colors.white),
            border: Border.all(
              color: _hovered
                  ? Colors.transparent
                  : (widget.isDark ? AppColors.border : AppColors.lightBorder),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.icon == Icons.email_rounded
                ? Icon(
                    widget.icon,
                    size: 18,
                    color: _hovered
                        ? Colors.white
                        : (widget.isDark
                              ? AppColors.textSecondary
                              : const Color(0xFF6B7280)),
                  )
                : FaIcon(
                    widget.icon,
                    size: 16,
                    color: _hovered
                        ? Colors.white
                        : (widget.isDark
                              ? AppColors.textSecondary
                              : const Color(0xFF6B7280)),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Success Card ─────────────────────────────────────────────────────────────

class _SuccessCard extends StatelessWidget {
  final bool isDark;
  final bool usedFallback;
  final String message;
  final VoidCallback onSendAnother;

  const _SuccessCard({
    required this.isDark,
    this.usedFallback = false,
    this.message = '',
    required this.onSendAnother,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = usedFallback
        ? const Color(0xFF4F46E5)
        : const Color(0xFF3FB950);

    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.bgCard : Colors.white,
        border: Border.all(color: accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(isDark ? 0.08 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated checkmark icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.15),
                    accentColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                usedFallback ? Icons.email_rounded : Icons.check_rounded,
                color: accentColor,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            usedFallback ? 'Almost There!' : 'Message Sent!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? AppColors.textPrimary : AppColors.bgDeep,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            message.isNotEmpty
                ? message
                : "Thanks for reaching out. I'll get back to you as soon as possible.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? AppColors.textSecondary : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 32),

          // Send another message button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onSendAnother,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.border : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: isDark
                          ? AppColors.textSecondary
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Send Another Message',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondary
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
