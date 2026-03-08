import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_jps/core/router/app_router.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/features/about/presentation/widgets/about_section.dart';
import 'package:portfolio_jps/features/contact/presentation/widgets/contact_section.dart';
import 'package:portfolio_jps/features/experience/presentation/widgets/experience_section.dart';
import 'package:portfolio_jps/features/hero/presentation/widgets/hero_section.dart';
import 'package:portfolio_jps/features/projects/presentation/widgets/projects_section.dart';
import 'package:portfolio_jps/features/skills/presentation/widgets/skills_section.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart';
import 'package:portfolio_jps/shared/widgets/cursor_glow.dart';
import 'package:portfolio_jps/shared/widgets/custom_app_bar.dart';
import 'package:portfolio_jps/shared/widgets/footer.dart';
import 'package:portfolio_jps/shared/widgets/scroll_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());
  int _activeSection = 0;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    // Update scroll offset for parallax (throttled via setState)
    if ((offset - _scrollOffset).abs() > 2) {
      setState(() => _scrollOffset = offset);
    }

    // Determine active section
    for (var i = _sectionKeys.length - 1; i >= 0; i--) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject()! as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy;
        if (position <= 200) {
          if (_activeSection != i) {
            setState(() => _activeSection = i);
          }
          break;
        }
      }
    }
  }

  void _scrollToSection(int index) {
    if (index >= _sectionKeys.length) return;

    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backquote &&
          HardwareKeyboard.instance.isControlPressed) {
        context.push(AppRoutes.terminal);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        CursorGlow(
          child: KeyboardListener(
            focusNode: FocusNode()..requestFocus(),
            onKeyEvent: _handleKeyEvent,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: CustomAppBar(
                onNavItemTap: _scrollToSection,
                scrollController: _scrollController,
                activeSection: _activeSection,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: isDark ? AppColors.heroGradient : null,
                  color: isDark
                      ? null
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        key: _sectionKeys[0],
                        child: HeroSection(
                          onScrollToSection: _scrollToSection,
                          scrollOffset: _scrollOffset,
                        ),
                      ),
                      SizedBox(
                        key: _sectionKeys[1],
                        child: const AboutSection(),
                      ),
                      SizedBox(
                        key: _sectionKeys[2],
                        child: const ProjectsSection(),
                      ),
                      SizedBox(
                        key: _sectionKeys[3],
                        child: const ExperienceSection(),
                      ),
                      SizedBox(
                        key: _sectionKeys[4],
                        child: const SkillsSection(),
                      ),
                      SizedBox(
                        key: _sectionKeys[5],
                        child: const ContactSection(),
                      ),
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Scroll progress indicator (desktop only)
        ScrollProgress(scrollController: _scrollController),
        // Code Peek Overlay
        const CodePeekOverlay(),
      ],
    );
  }
}
