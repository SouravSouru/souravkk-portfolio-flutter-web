import 'package:flutter/material.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/mobile_drawer.dart';
import '../../../../core/theme/app_theme.dart';

// Deferred imports for code splitting (reduces initial JS bundle size significantly)
import '../widgets/about_section.dart' deferred as about;
import '../widgets/skills_section.dart' deferred as skills;
import '../widgets/experience_section.dart' deferred as experience;
import '../widgets/projects_section.dart' deferred as projects;
import '../widgets/contact_section.dart' deferred as contact;
import '../widgets/footer.dart' deferred as footer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());
  bool _showScrollTop = false;

  /// Whether the hero section is still roughly visible.
  bool _heroVisible = true;
  
  /// Track if deferred libraries are loaded
  bool _sectionsLoaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadDeferredSections();
  }
  
  Future<void> _loadDeferredSections() async {
    // Load below-the-fold content libraries in parallel to split the JS bundle
    await Future.wait([
      about.loadLibrary(),
      skills.loadLibrary(),
      experience.loadLibrary(),
      projects.loadLibrary(),
      contact.loadLibrary(),
      footer.loadLibrary(),
    ]);
    if (mounted) {
      setState(() {
        _sectionsLoaded = true;
      });
    }
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    // Show/hide scroll-to-top FAB
    final shouldShow = offset > 400;
    if (shouldShow != _showScrollTop) {
      setState(() => _showScrollTop = shouldShow);
    }

    // Pause hero tickers once the user scrolls past ~90% of the viewport height.
    final viewportH = _scrollController.position.viewportDimension;
    final heroOnScreen = offset < viewportH * 0.9;
    if (heroOnScreen != _heroVisible) {
      setState(() => _heroVisible = heroOnScreen);
    }
  }

  void _scrollToSection(int index) {
    final key = _sectionKeys[index];
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Using RepaintBoundary prevents the animated hero from repainting the whole page
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDeep : AppColors.lightBg,
      drawer: MobileDrawer(onNavTap: _scrollToSection),
      floatingActionButton: AnimatedScale(
        scale: _showScrollTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _showScrollTop ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            mini: true,
            onPressed: _scrollToTop,
            backgroundColor: const Color(0xFF4F46E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          NavBar(onNavTap: _scrollToSection),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              // Using Slivers allows Flutter to only render widgets in viewport
              slivers: [
                SliverToBoxAdapter(
                  child: RepaintBoundary(
                    child: KeyedSubtree(
                      key: _sectionKeys[0],
                      child: TickerMode(
                        enabled: _heroVisible,
                        child: HomeHeroSection(
                          onViewAppsTap: () => _scrollToSection(4),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_sectionsLoaded) 
                  SliverList(
                    delegate: SliverChildListDelegate([
                      RepaintBoundary(
                        child: KeyedSubtree(
                          key: _sectionKeys[1],
                          child: about.AboutSection(),
                        ),
                      ),
                      RepaintBoundary(
                        child: KeyedSubtree(
                          key: _sectionKeys[2],
                          child: skills.SkillsSection(),
                        ),
                      ),
                      RepaintBoundary(
                        child: KeyedSubtree(
                          key: _sectionKeys[3],
                          child: experience.ExperienceSection(),
                        ),
                      ),
                      RepaintBoundary(
                        child: KeyedSubtree(
                          key: _sectionKeys[4],
                          child: projects.ProjectsSection(),
                        ),
                      ),
                      RepaintBoundary(
                        child: KeyedSubtree(
                          key: _sectionKeys[5],
                          child: contact.ContactSection(),
                        ),
                      ),
                      RepaintBoundary(
                        child: footer.Footer(),
                      ),
                    ]),
                  )
                else
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFF4F46E5).withOpacity(0.5),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
