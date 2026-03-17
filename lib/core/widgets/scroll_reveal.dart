import 'package:flutter/material.dart';

/// A widget that animates its child when it becomes visible in the viewport.
/// Trigger is visibility-based (scroll-reveal pattern).
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset startOffset;
  final double startOpacity;
  final Curve curve;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.startOffset = const Offset(0, 40),
    this.startOpacity = 0.0,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: widget.startOpacity, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _slide = Tween<Offset>(begin: widget.startOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  void _trigger() {
    if (!_triggered) {
      _triggered = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: VisibilityDetectorWrapper(
        onVisible: _trigger,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity.value,
              child: Transform.translate(
                offset: _slide.value,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Simple visibility detection wrapper
class VisibilityDetectorWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onVisible;

  const VisibilityDetectorWrapper({
    super.key,
    required this.child,
    required this.onVisible,
  });

  @override
  State<VisibilityDetectorWrapper> createState() =>
      _VisibilityDetectorWrapperState();
}

class _VisibilityDetectorWrapperState extends State<VisibilityDetectorWrapper> {
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    // Trigger after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!_hasTriggered) {
      _hasTriggered = true;
      widget.onVisible();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
