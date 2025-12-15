import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_jps/core/router/app_router.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/features/contact/presentation/widgets/contact_section.dart';
import 'package:portfolio_jps/features/experience/presentation/widgets/experience_section.dart';
import 'package:portfolio_jps/features/hero/presentation/widgets/hero_section.dart';
import 'package:portfolio_jps/features/projects/presentation/widgets/projects_section.dart';
import 'package:portfolio_jps/features/skills/presentation/widgets/skills_section.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart';
import 'package:portfolio_jps/shared/widgets/custom_app_bar.dart';
import 'package:portfolio_jps/shared/widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    if (index >= _sectionKeys.length) return;

    final key = _sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // Easter egg: Ctrl + ` para abrir terminal
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
        KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: _handleKeyEvent,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: CustomAppBar(
              onNavItemTap: _scrollToSection,
              scrollController: _scrollController,
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.heroGradient : null,
                color: isDark ? null : Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Hero Section
                    SizedBox(
                      key: _sectionKeys[0],
                      child: HeroSection(
                        onScrollToSection: _scrollToSection,
                      ),
                    ),
                    // Projects Section
                    SizedBox(
                      key: _sectionKeys[1],
                      child: const ProjectsSection(),
                    ),
                    // Experience Section
                    SizedBox(
                      key: _sectionKeys[2],
                      child: const ExperienceSection(),
                    ),
                    // Skills Section
                    SizedBox(
                      key: _sectionKeys[3],
                      child: const SkillsSection(),
                    ),
                    // Contact Section
                    SizedBox(
                      key: _sectionKeys[4],
                      child: const ContactSection(),
                    ),
                    // Footer
                    const Footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Code Peek Overlay - listens for component selections
        const CodePeekOverlay(),
      ],
    );
  }
}
