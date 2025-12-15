import 'package:portfolio_jps/shared/widgets/code_peek/models/component_code.dart';

/// Repository of source code snippets for components.
///
/// These are hardcoded representations of key components
/// for the Dev Mode "Code Peek" feature.
class ComponentCodes {
  ComponentCodes._();

  static const String _githubBase =
      'https://github.com/jpsdeveloper/portfolio/blob/main';

  /// Gets a component code by its ID.
  static ComponentCode? getById(String id) {
    return _all[id];
  }

  /// All available component codes.
  static final Map<String, ComponentCode> _all = {
    animatedButton.id: animatedButton,
    particleBackground.id: particleBackground,
    availabilityBadge.id: availabilityBadge,
    glassCard.id: glassCard,
    heroSection.id: heroSection,
    projectCard.id: projectCard,
    skillCard.id: skillCard,
    timelineItem.id: timelineItem,
    contactForm.id: contactForm,
    socialIcon.id: socialIcon,
  };

  // ============================================================
  // COMPONENT DEFINITIONS
  // ============================================================

  static const animatedButton = ComponentCode(
    id: 'animated_button',
    name: 'AnimatedButton',
    description: 'Animated button with hover effects and multiple variants',
    filePath: 'lib/shared/widgets/animated_button.dart',
    githubUrl: '$_githubBase/lib/shared/widgets/animated_button.dart',
    code: '''
enum ButtonVariant { primary, secondary, outline, ghost }

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..setEntry(0, 0, _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0))
            ..setEntry(1, 1, _isPressed ? 0.95 : (_isHovered ? 1.02 : 1.0)),
          decoration: _buildDecoration(),
          child: _buildContent(),
        ),
      ),
    ).animate(target: _isHovered ? 1 : 0)
     .shimmer(duration: 1.seconds);
  }
}''',
  );

  static const particleBackground = ComponentCode(
    id: 'particle_background',
    name: 'ParticleBackground',
    description: 'Interactive particle animation with mouse tracking',
    filePath: 'lib/shared/widgets/particle_background.dart',
    githubUrl: '$_githubBase/lib/shared/widgets/particle_background.dart',
    code: '''
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({
    this.particleCount = 50,
    this.enableLines = true,
    this.lineDistance = 150,
    super.key,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  Offset? _mousePosition;

  void _updateParticles() {
    for (final particle in _particles) {
      particle
        ..x += particle.vx
        ..y += particle.vy;

      // Mouse interaction - particles repel from cursor
      if (_mousePosition != null) {
        final dx = _mousePosition!.dx - particle.x;
        final dy = _mousePosition!.dy - particle.y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 100) {
          final force = (100 - distance) / 100;
          particle
            ..vx -= dx * force * 0.01
            ..vy -= dy * force * 0.01;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _mousePosition = event.localPosition,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateParticles();
          return CustomPaint(
            painter: _ParticlePainter(
              particles: _particles,
              mousePosition: _mousePosition,
            ),
          );
        },
      ),
    );
  }
}''',
  );

  static const availabilityBadge = ComponentCode(
    id: 'availability_badge',
    name: 'AvailabilityBadge',
    description: 'Animated badge showing work availability status',
    filePath: 'lib/features/hero/presentation/widgets/hero_section.dart',
    githubUrl: '$_githubBase/lib/features/hero/presentation/widgets/hero_section.dart',
    code: '''
Widget _buildAvailabilityBadge(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      color: AppColors.success.withOpacity(0.15),
      borderRadius: AppSpacing.borderRadiusFull,
      border: Border.all(
        color: AppColors.success.withOpacity(0.3),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing indicator
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .fadeIn(duration: 1.seconds)
            .then()
            .fadeOut(duration: 1.seconds),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Available for work',
          style: const TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}''',
  );

  static const glassCard = ComponentCode(
    id: 'glass_card',
    name: 'GlassCard',
    description: 'Glassmorphism card with blur effect and gradient border',
    filePath: 'lib/shared/widgets/glass_card.dart',
    githubUrl: '$_githubBase/lib/shared/widgets/glass_card.dart',
    code: '''
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
    this.blur = 10,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}''',
  );

  static const heroSection = ComponentCode(
    id: 'hero_section',
    name: 'HeroSection',
    description: 'Main hero section with animated text and particles',
    filePath: 'lib/features/hero/presentation/widgets/hero_section.dart',
    githubUrl: '$_githubBase/lib/features/hero/presentation/widgets/hero_section.dart',
    code: '''
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight,
      child: Stack(
        children: [
          // Particle Background
          const Positioned.fill(
            child: ParticleBackground(),
          ),
          // Gradient Overlay
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
          // Content with staggered animations
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvailabilityBadge()
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(begin: -0.3, end: 0),
                // Name with typewriter effect
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText('Flutter Developer'),
                    TypewriterAnimatedText('Mobile Expert'),
                  ],
                ),
                // CTA Buttons
                Row(
                  children: [
                    AnimatedButton(text: 'Contact Me'),
                    AnimatedButton(
                      text: 'View Projects',
                      variant: ButtonVariant.outline,
                    ),
                  ],
                ).animate().fadeIn(delay: 2.2.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }
}''',
  );

  static const projectCard = ComponentCode(
    id: 'project_card',
    name: 'ProjectCard3D',
    description: '3D project card with hover tilt effect and perspective transform',
    filePath: 'lib/shared/widgets/project_card_3d.dart',
    githubUrl: '$_githubBase/lib/shared/widgets/project_card_3d.dart',
    code: '''
class ProjectCard3D extends StatefulWidget {
  const ProjectCard3D({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.techStack,
    this.role,
    this.onViewLive,
    this.onViewCode,
    this.width = 380,
    this.height = 450,
    super.key,
  });

  @override
  State<ProjectCard3D> createState() => _ProjectCard3DState();
}

class _ProjectCard3DState extends State<ProjectCard3D> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  // Calculate rotation based on mouse position
  double get _rotateX {
    if (!_isHovered) return 0;
    final centerY = widget.height / 2;
    return ((_mousePosition.dy - centerY) / centerY) * -0.1;
  }

  double get _rotateY {
    if (!_isHovered) return 0;
    final centerX = widget.width / 2;
    return ((_mousePosition.dx - centerX) / centerX) * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mousePosition = Offset.zero;
      }),
      onHover: (event) {
        setState(() => _mousePosition = event.localPosition);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002) // perspective
          ..rotateX(_rotateX)
          ..rotateY(_rotateY)
          ..setEntry(0, 0, _isHovered ? 1.02 : 1.0)
          ..setEntry(1, 1, _isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.accent.withOpacity(0.3)
                  : Colors.black.withOpacity(0.4),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            ),
          ],
        ),
        child: _buildCardContent(),
      ),
    );
  }
}''',
  );

  static const skillCard = ComponentCode(
    id: 'skill_card',
    name: 'SkillCard',
    description: 'Skill card with animated progress indicator',
    filePath: 'lib/features/skills/presentation/widgets/skill_card.dart',
    githubUrl: '$_githubBase/lib/features/skills/presentation/widgets/skill_card.dart',
    code: '''
class SkillCard extends StatelessWidget {
  const SkillCard({
    required this.skill,
    super.key,
  });

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(skill.icon, color: AppColors.accent),
              const SizedBox(width: 12),
              Text(
                skill.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Animated progress bar
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: constraints.maxWidth * skill.level,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(4),
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
}''',
  );

  static const timelineItem = ComponentCode(
    id: 'timeline_item',
    name: 'ExperienceCard',
    description: 'Experience timeline card with hover effects and achievements',
    filePath: 'lib/features/experience/presentation/widgets/experience_section.dart',
    githubUrl: '$_githubBase/lib/features/experience/presentation/widgets/experience_section.dart',
    code: '''
class _TimelineItem extends StatefulWidget {
  const _TimelineItem({
    required this.experience,
    required this.isLeft,
    required this.isFirst,
    required this.isLast,
    required this.delay,
  });

  final ExperienceData experience;
  final bool isLeft;
  final bool isFirst;
  final bool isLast;
  final int delay;
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  Widget _buildContent(BuildContext context, bool isDark) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppSpacing.paddingAllLg,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: _isHovered
                ? AppColors.accent.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
          ),
          boxShadow: _isHovered
              ? [BoxShadow(
                  color: AppColors.accent.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(widget.experience.dateRange),
            ),
            // Company & Role
            Text(widget.experience.company, style: titleLarge),
            Text(widget.experience.role, style: accent),
            // Description
            Text(widget.experience.description),
            // Achievements with checkmarks
            ...widget.experience.achievements.map((a) =>
              Row(children: [
                Icon(Icons.check_circle, color: AppColors.success),
                Text(a),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}''',
  );

  static const contactForm = ComponentCode(
    id: 'contact_form',
    name: 'ContactForm',
    description: 'Contact form with validation and animated feedback',
    filePath: 'lib/features/contact/presentation/widgets/contact_form.dart',
    githubUrl: '$_githubBase/lib/features/contact/presentation/widgets/contact_form.dart',
    code: '''
class ContactForm extends StatefulWidget {
  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Submit form
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Name',
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            validator: (v) {
              if (v!.isEmpty) return 'Required';
              if (!v.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          _buildTextField(
            controller: _messageController,
            label: 'Message',
            maxLines: 5,
          ),
          AnimatedButton(
            text: 'Send Message',
            icon: Icons.send,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}''',
  );

  static const socialIcon = ComponentCode(
    id: 'social_icon',
    name: 'SocialIcon',
    description: 'Animated social media icon with hover glow',
    filePath: 'lib/shared/widgets/social_icon.dart',
    githubUrl: '$_githubBase/lib/shared/widgets/social_icon.dart',
    code: '''
class SocialIcon extends StatefulWidget {
  const SocialIcon({
    required this.icon,
    required this.url,
    this.color,
    super.key,
  });

  final IconData icon;
  final String url;
  final Color? color;

  @override
  State<SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? color.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? color
                  : Colors.white.withOpacity(0.1),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? color : Colors.white70,
            size: 24,
          ),
        ),
      ),
    );
  }
}''',
  );
}
