import 'package:portfolio_jps/shared/widgets/code_viewer/models/source_code_model.dart';

/// Contains curated code snippets for each section of the portfolio.
///
/// These snippets showcase clean architecture, best practices, and
/// interesting implementation details.
abstract class CodeSnippets {
  /// GitHub repository base URL
  static const String _githubBase =
      'https://github.com/JesusPerezSan/portfolio/blob/main';

  /// Hero Section - Main widget with animations
  static const SourceCodeModel heroSection = SourceCodeModel(
    fileName: 'hero_section.dart',
    filePath: 'lib/features/hero/presentation/widgets/hero_section.dart',
    language: 'dart',
    githubUrl: '$_githubBase/lib/features/hero/presentation/widgets/hero_section.dart',
    description: 'Hero section with staggered animations and particle background',
    code: _heroSectionCode,
    relatedFiles: [
      SourceCodeModel(
        fileName: 'particle_background.dart',
        filePath: 'lib/shared/widgets/particle_background.dart',
        language: 'dart',
        githubUrl: '$_githubBase/lib/shared/widgets/particle_background.dart',
        description: 'Interactive particle system with mouse interaction',
        code: _particleBackgroundCode,
      ),
      SourceCodeModel(
        fileName: 'animated_button.dart',
        filePath: 'lib/shared/widgets/animated_button.dart',
        language: 'dart',
        githubUrl: '$_githubBase/lib/shared/widgets/animated_button.dart',
        description: 'Animated button with multiple variants and hover effects',
        code: _animatedButtonCode,
      ),
    ],
  );

  /// Projects Section - 3D cards with tilt effect
  static const SourceCodeModel projectsSection = SourceCodeModel(
    fileName: 'projects_section.dart',
    filePath: 'lib/features/projects/presentation/widgets/projects_section.dart',
    language: 'dart',
    githubUrl:
        '$_githubBase/lib/features/projects/presentation/widgets/projects_section.dart',
    description: 'Project showcase with responsive grid layout',
    code: _projectsSectionCode,
    relatedFiles: [
      SourceCodeModel(
        fileName: 'project_card_3d.dart',
        filePath: 'lib/shared/widgets/project_card_3d.dart',
        language: 'dart',
        githubUrl: '$_githubBase/lib/shared/widgets/project_card_3d.dart',
        description: '3D card with perspective tilt effect on hover',
        code: _projectCard3DCode,
      ),
    ],
  );

  /// Skills Section - Animated skill cards
  static const SourceCodeModel skillsSection = SourceCodeModel(
    fileName: 'skills_section.dart',
    filePath: 'lib/features/skills/presentation/widgets/skills_section.dart',
    language: 'dart',
    githubUrl:
        '$_githubBase/lib/features/skills/presentation/widgets/skills_section.dart',
    description: 'Skills showcase with category tabs and animated cards',
    code: _skillsSectionCode,
    relatedFiles: [
      SourceCodeModel(
        fileName: 'skills_data.dart',
        filePath: 'lib/shared/data/skills_data.dart',
        language: 'dart',
        githubUrl: '$_githubBase/lib/shared/data/skills_data.dart',
        description: 'Structured data for skills and proficiency levels',
        code: _skillsDataCode,
      ),
    ],
  );

  /// Experience Section - Timeline layout
  static const SourceCodeModel experienceSection = SourceCodeModel(
    fileName: 'experience_section.dart',
    filePath: 'lib/features/experience/presentation/widgets/experience_section.dart',
    language: 'dart',
    githubUrl:
        '$_githubBase/lib/features/experience/presentation/widgets/experience_section.dart',
    description: 'Professional experience timeline with alternating layout',
    code: _experienceSectionCode,
    relatedFiles: [
      SourceCodeModel(
        fileName: 'experience_data.dart',
        filePath: 'lib/shared/data/experience_data.dart',
        language: 'dart',
        githubUrl: '$_githubBase/lib/shared/data/experience_data.dart',
        description: 'Career history data with achievements',
        code: _experienceDataCode,
      ),
    ],
  );

  /// Contact Section - Form with terminal animation
  static const SourceCodeModel contactSection = SourceCodeModel(
    fileName: 'contact_section.dart',
    filePath: 'lib/features/contact/presentation/widgets/contact_section.dart',
    language: 'dart',
    githubUrl:
        '$_githubBase/lib/features/contact/presentation/widgets/contact_section.dart',
    description: 'Contact form with validation and social links',
    code: _contactSectionCode,
  );
}

// ============================================================================
// CODE SNIPPETS - Curated excerpts showcasing best practices
// ============================================================================

const String _heroSectionCode = '''
/// Hero Section - The main landing area of the portfolio
///
/// Features:
/// - Staggered entrance animations using flutter_animate
/// - Particle background with interactive effects
/// - Typewriter animation for role display
/// - Responsive layout with mobile-first design
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = Responsive.isMobile(context);

    return SizedBox(
      height: screenHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Interactive particle background
          const Positioned.fill(
            child: ParticleBackground(),
          ),

          // Radial gradient overlay for depth
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    AppColors.backgroundDark.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // Main content with staggered animations
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Availability badge - appears first
                _buildAvailabilityBadge(context, l10n)
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),

                // Name with large typography
                Text(
                  l10n.heroName,
                  style: Theme.of(context).textTheme.displayLarge,
                ).animate()
                 .fadeIn(delay: 1000.ms, duration: 800.ms)
                 .slideY(begin: 0.3, end: 0),

                // Role with typewriter effect
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      l10n.heroRole,
                      speed: const Duration(milliseconds: 80),
                    ),
                  ],
                ).animate()
                 .fadeIn(delay: 1500.ms, duration: 600.ms),

                // CTA Buttons
                Wrap(
                  spacing: AppSpacing.md,
                  children: [
                    AnimatedButton(
                      text: l10n.heroCtaContact,
                      onPressed: () => _scrollToContact(),
                      icon: Icons.send,
                    ),
                    AnimatedButton(
                      text: l10n.heroCtaProjects,
                      variant: ButtonVariant.outline,
                      onPressed: () => _scrollToProjects(),
                    ),
                  ],
                ).animate()
                 .fadeIn(delay: 2200.ms, duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
''';

const String _particleBackgroundCode = '''
/// Interactive particle background with mouse repulsion
///
/// Uses CustomPainter for high-performance rendering.
/// Particles move continuously and respond to mouse position.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({
    this.particleCount = 50,
    this.color = AppColors.accent,
    super.key,
  });

  final int particleCount;
  final Color color;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  Offset? _mousePosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _particles = List.generate(
      widget.particleCount,
      (_) => Particle.random(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _mousePosition = event.localPosition,
      onExit: (_) => _mousePosition = null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          _updateParticles();
          return CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              color: widget.color,
              mousePosition: _mousePosition,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  void _updateParticles() {
    for (final particle in _particles) {
      // Apply velocity
      particle.position += particle.velocity;

      // Bounce off edges
      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
      }

      // Mouse repulsion effect
      if (_mousePosition != null) {
        final distance = (particle.position - _mousePosition!).distance;
        if (distance < 100) {
          final repulsion = (particle.position - _mousePosition!).normalize() * 2;
          particle.velocity += repulsion;
        }
      }
    }
  }
}
''';

const String _animatedButtonCode = '''
/// Animated button with multiple variants and hover effects
///
/// Supports: Primary (gradient), Secondary, Outline, Ghost variants.
/// Features shimmer effect on primary, scale transform on hover/tap.
enum ButtonVariant { primary, secondary, outline, ghost }

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _scale {
    if (_isPressed) return 0.95;
    if (_isHovered) return 1.02;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_scale),
          decoration: _buildDecoration(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(widget.text),
            ],
          ),
        ),
      ),
    );
  }
}
''';

const String _projectsSectionCode = '''
/// Projects showcase with responsive grid layout
///
/// Displays featured projects in a masonry-style grid.
/// Each card has 3D tilt effect on hover.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projects = ProjectsData.featuredProjects;

    return SectionWrapper(
      title: l10n.projectsTitle,
      subtitle: l10n.projectsSubtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 1 : 2;

          return Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            alignment: WrapAlignment.center,
            children: projects.asMap().entries.map((entry) {
              return ProjectCard3D(
                project: entry.value,
                index: entry.key,
              ).animate()
               .fadeIn(delay: (100 * entry.key).ms)
               .slideY(begin: 0.2, end: 0);
            }).toList(),
          );
        },
      ),
    );
  }
}
''';

const String _projectCard3DCode = '''
/// 3D Project card with perspective tilt effect
///
/// Uses Transform with perspective matrix for realistic 3D effect.
/// Calculates rotation based on mouse position within the card.
class ProjectCard3D extends StatefulWidget {
  const ProjectCard3D({
    required this.project,
    required this.index,
    super.key,
  });

  final Project project;
  final int index;

  @override
  State<ProjectCard3D> createState() => _ProjectCard3DState();
}

class _ProjectCard3DState extends State<ProjectCard3D> {
  Offset _mouseOffset = Offset.zero;
  bool _isHovered = false;

  // Maximum rotation angle in radians
  static const double _maxTilt = 0.1;
  static const double _perspective = 0.002;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mouseOffset = Offset.zero;
      }),
      onHover: (event) => _updateTilt(event.localPosition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: _buildTransform(),
        transformAlignment: Alignment.center,
        child: _buildCard(),
      ),
    );
  }

  void _updateTilt(Offset localPosition) {
    final size = context.size ?? Size.zero;
    setState(() {
      // Normalize position to -1 to 1 range
      _mouseOffset = Offset(
        (localPosition.dx / size.width - 0.5) * 2,
        (localPosition.dy / size.height - 0.5) * 2,
      );
    });
  }

  Matrix4 _buildTransform() {
    if (!_isHovered) return Matrix4.identity();

    return Matrix4.identity()
      ..setEntry(3, 2, _perspective) // perspective
      ..rotateX(-_mouseOffset.dy * _maxTilt) // tilt up/down
      ..rotateY(_mouseOffset.dx * _maxTilt)  // tilt left/right
      ..scale(_isHovered ? 1.02 : 1.0);
  }
}
''';

const String _skillsSectionCode = '''
/// Skills showcase with category tabs and animated cards
///
/// Uses AnimatedSwitcher for smooth category transitions.
/// Each skill card shows proficiency level with animated bar.
class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  SkillCategory _selectedCategory = SkillCategory.languages;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SectionWrapper(
      title: l10n.skillsTitle,
      subtitle: l10n.skillsSubtitle,
      child: Column(
        children: [
          // Category tabs
          _buildCategoryTabs(l10n),
          const SizedBox(height: AppSpacing.xl),

          // Skill cards with animated transitions
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildSkillGrid(
              key: ValueKey(_selectedCategory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillGrid({Key? key}) {
    final skills = SkillsData.getByCategory(_selectedCategory);

    return Wrap(
      key: key,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: skills.asMap().entries.map((entry) {
        return _SkillCard(
          skill: entry.value,
        ).animate()
         .fadeIn(delay: (50 * entry.key).ms)
         .scale(begin: const Offset(0.8, 0.8));
      }).toList(),
    );
  }
}
''';

const String _skillsDataCode = '''
/// Structured data for skills with proficiency levels
///
/// Using enums for type safety and easy categorization.
enum SkillCategory { languages, frameworks, tools, cloud }
enum ProficiencyLevel { beginner, intermediate, advanced, expert }

class Skill {
  const Skill({
    required this.name,
    required this.icon,
    required this.category,
    required this.level,
    this.color,
  });

  final String name;
  final IconData icon;
  final SkillCategory category;
  final ProficiencyLevel level;
  final Color? color;

  double get proficiencyValue {
    switch (level) {
      case ProficiencyLevel.beginner:
        return 0.25;
      case ProficiencyLevel.intermediate:
        return 0.5;
      case ProficiencyLevel.advanced:
        return 0.75;
      case ProficiencyLevel.expert:
        return 1.0;
    }
  }
}

abstract class SkillsData {
  static const List<Skill> all = [
    Skill(
      name: 'Dart',
      icon: FontAwesomeIcons.dartLang,
      category: SkillCategory.languages,
      level: ProficiencyLevel.expert,
      color: Color(0xFF0175C2),
    ),
    Skill(
      name: 'Flutter',
      icon: FontAwesomeIcons.flutter,
      category: SkillCategory.frameworks,
      level: ProficiencyLevel.expert,
      color: Color(0xFF02569B),
    ),
    // ... more skills
  ];

  static List<Skill> getByCategory(SkillCategory category) {
    return all.where((s) => s.category == category).toList();
  }
}
''';

const String _experienceSectionCode = '''
/// Experience timeline with alternating layout
///
/// Desktop: Alternates items left and right of timeline.
/// Mobile: Single column with timeline on the left.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final experiences = ExperienceData.all;
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      title: l10n.experienceTitle,
      subtitle: l10n.experienceSubtitle,
      child: Stack(
        children: [
          // Vertical timeline line
          Positioned(
            left: isMobile ? 20 : null,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              color: AppColors.accent.withOpacity(0.3),
            ),
          ),

          // Experience items
          Column(
            children: experiences.asMap().entries.map((entry) {
              final isEven = entry.key.isEven;

              return _ExperienceItem(
                experience: entry.value,
                isLeft: !isMobile && isEven,
                index: entry.key,
              ).animate()
               .fadeIn(delay: (200 * entry.key).ms)
               .slideX(
                 begin: isEven ? -0.2 : 0.2,
                 end: 0,
               );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
''';

const String _experienceDataCode = r'''
/// Career history data with achievements
class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.achievements,
    this.companyUrl,
    this.logoUrl,
  });

  final String company;
  final String role;
  final DateTime startDate;
  final DateTime? endDate; // null = present
  final String description;
  final List<String> achievements;
  final String? companyUrl;
  final String? logoUrl;

  bool get isCurrent => endDate == null;

  String get dateRange {
    final start = DateFormat('MMM yyyy').format(startDate);
    final end = isCurrent ? 'Present' : DateFormat('MMM yyyy').format(endDate!);
    return '$start - $end';
  }
}

abstract class ExperienceData {
  static const List<Experience> all = [
    Experience(
      company: 'SlashMobility',
      role: 'Senior Flutter Engineer',
      startDate: DateTime(2025, 5),
      description: 'Building Risk Engineers app for UK/USA insurance sector.',
      achievements: [
        'Clean Architecture implementation',
        'BLoC state management patterns',
        'Cross-platform mobile development',
      ],
    ),
    // ... more experiences
  ];
}
''';

const String _contactSectionCode = r'''
/// Contact section with form validation and social links
///
/// Features responsive layout and success state animation.
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      title: l10n.contactTitle,
      child: isMobile
          ? Column(children: [_buildInfo(), _buildForm()])
          : Row(children: [
              Expanded(child: _buildInfo()),
              const SizedBox(width: AppSpacing.xxl),
              Expanded(child: _buildForm()),
            ]),
    );
  }

  Widget _buildForm() {
    if (_isSuccess) {
      return _buildSuccessState();
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: _validateEmail,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(labelText: 'Message'),
            maxLines: 5,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedButton(
            text: _isSubmitting ? 'Sending...' : 'Send Message',
            onPressed: _submit,
            isLoading: _isSubmitting,
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Send to backend...
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _isSuccess = true;
    });
  }
}
''';
