import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_jps/core/config/app_config.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSubmitted = false;
  bool _isVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate sending (real Firebase/email logic would go here)
    await Future<void>.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });

    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isSubmitted = false);
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final verticalPadding = Responsive.value<double>(
      context,
      mobile: 80,
      desktop: 120,
    );
    final horizontalPadding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, l10n, isDark),
                SizedBox(
                  height: Responsive.value<double>(
                    context,
                    mobile: AppSpacing.xl,
                    tablet: AppSpacing.xxl,
                    desktop: AppSpacing.xxxl,
                  ),
                ),
                if (isMobile)
                  _buildMobileLayout(context, l10n, isDark)
                else
                  _buildDesktopLayout(context, l10n, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section Header: "LET'S CONNECT" label + "Get In Touch" title + gradient bar
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    if (!_isVisible) {
      return Opacity(
        opacity: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "LET'S CONNECT",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.contactTitle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cyan uppercase label
        Text(
          "LET'S CONNECT",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.1, end: 0, duration: 500.ms),
        const SizedBox(height: AppSpacing.sm),
        // Large title
        Text(
          l10n.contactTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.value<double>(
                  context,
                  mobile: 32,
                  desktop: 48,
                ),
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 100.ms),
        const SizedBox(height: AppSpacing.sm),
        // Subtitle
        Text(
          l10n.contactSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.6),
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms)
            .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 200.ms),
        const SizedBox(height: AppSpacing.md),
        // Gradient separator
        Container(
          width: 80,
          height: 4,
          decoration: const BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: AppSpacing.borderRadiusFull,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 300.ms)
            .scaleX(
              begin: 0,
              end: 1,
              alignment: Alignment.centerLeft,
              duration: 500.ms,
              delay: 300.ms,
            ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Desktop: Row (40% info + 60% form)
  // ---------------------------------------------------------------------------

  Widget _buildDesktopLayout(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: _buildContactInfo(context, l10n, isDark),
        ),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(
          flex: 6,
          child: _buildContactForm(context, l10n, isDark),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Mobile: Column stacked
  // ---------------------------------------------------------------------------

  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Column(
      children: [
        _buildContactInfo(context, l10n, isDark),
        const SizedBox(height: AppSpacing.xl),
        _buildContactForm(context, l10n, isDark),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Left column: Contact info items + social icons
  // ---------------------------------------------------------------------------

  Widget _buildContactInfo(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    if (!_isVisible) {
      return const Opacity(opacity: 0, child: SizedBox(height: 300));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        _ContactInfoItem(
          icon: Icons.location_on_outlined,
          label: l10n.translate('contact_location'),
          value: AppConfig.location,
          isDark: isDark,
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 200.ms),
        const SizedBox(height: AppSpacing.lg),
        // Email
        _ContactInfoItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: AppConfig.email,
          isDark: isDark,
          onTap: () => _launchUrl('mailto:${AppConfig.email}'),
        )
            .animate()
            .fadeIn(delay: 350.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 350.ms),
        const SizedBox(height: AppSpacing.lg),
        // Phone
        _ContactInfoItem(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: AppConfig.phone,
          isDark: isDark,
          onTap: () => _launchUrl('tel:${AppConfig.phone}'),
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 500.ms),
        const SizedBox(height: AppSpacing.xxl),
        // Social label
        Text(
          'Social',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        )
            .animate()
            .fadeIn(delay: 650.ms, duration: 500.ms),
        const SizedBox(height: AppSpacing.md),
        // Social icons row
        Row(
          children: [
            _SocialIconButton(
              icon: FontAwesomeIcons.github,
              url: AppConfig.githubUrl,
              isDark: isDark,
            ),
            const SizedBox(width: AppSpacing.md),
            _SocialIconButton(
              icon: FontAwesomeIcons.linkedin,
              url: AppConfig.linkedInUrl,
              isDark: isDark,
            ),
            const SizedBox(width: AppSpacing.md),
            _SocialIconButton(
              icon: FontAwesomeIcons.twitter,
              url: AppConfig.twitterUrl,
              isDark: isDark,
            ),
          ],
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 800.ms),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Right column: Form card
  // ---------------------------------------------------------------------------

  Widget _buildContactForm(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    if (_isSubmitted) {
      return _buildSuccessMessage(context, l10n, isDark);
    }

    if (!_isVisible) {
      return const Opacity(opacity: 0, child: SizedBox(height: 400));
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1A2E)
            : Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.08),
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Decorative gradient blob (top-right)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: isDark ? 0.08 : 0.05),
                    AppColors.accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          // Decorative gradient blob (bottom-left)
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondaryStart
                        .withValues(alpha: isDark ? 0.06 : 0.04),
                    AppColors.secondaryStart.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          // Form content
          Padding(
            padding: EdgeInsets.all(
              Responsive.value<double>(
                context,
                mobile: AppSpacing.lg,
                desktop: AppSpacing.xl,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name
                  _FloatingLabelField(
                    controller: _nameController,
                    label: l10n.contactName,
                    isDark: isDark,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 500.ms)
                      .slideX(
                        begin: 0.15,
                        end: 0,
                        duration: 500.ms,
                        delay: 300.ms,
                      ),
                  const SizedBox(height: AppSpacing.md),
                  // Email
                  _FloatingLabelField(
                    controller: _emailController,
                    label: l10n.contactEmail,
                    keyboardType: TextInputType.emailAddress,
                    isDark: isDark,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(v)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 500.ms)
                      .slideX(
                        begin: 0.15,
                        end: 0,
                        duration: 500.ms,
                        delay: 400.ms,
                      ),
                  const SizedBox(height: AppSpacing.md),
                  // Subject (optional)
                  _FloatingLabelField(
                    controller: _subjectController,
                    label: 'Subject',
                    isDark: isDark,
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 500.ms)
                      .slideX(
                        begin: 0.15,
                        end: 0,
                        duration: 500.ms,
                        delay: 500.ms,
                      ),
                  const SizedBox(height: AppSpacing.md),
                  // Message
                  _FloatingLabelField(
                    controller: _messageController,
                    label: l10n.contactMessage,
                    maxLines: 5,
                    isDark: isDark,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideX(
                        begin: 0.15,
                        end: 0,
                        duration: 500.ms,
                        delay: 600.ms,
                      ),
                  const SizedBox(height: AppSpacing.lg),
                  // Submit button
                  _GradientSubmitButton(
                    label: _isSubmitting
                        ? l10n.translate('contact_sending')
                        : l10n.contactSend,
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _submitForm,
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 500.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 500.ms,
                        delay: 700.ms,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideX(begin: 0.08, end: 0, duration: 600.ms, delay: 200.ms);
  }

  // ---------------------------------------------------------------------------
  // Success message after submit
  // ---------------------------------------------------------------------------

  Widget _buildSuccessMessage(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: AppColors.success,
          )
              .animate()
              .scale(
                begin: Offset.zero,
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.contactSuccess,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

// =============================================================================
// _ContactInfoItem — icon + label + value with hover highlight
// =============================================================================

class _ContactInfoItem extends StatefulWidget {
  const _ContactInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  State<_ContactInfoItem> createState() => _ContactInfoItemState();
}

class _ContactInfoItemState extends State<_ContactInfoItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Icon container with glow
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            color: widget.isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMutedLight,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: widget.onTap != null
                                ? AppColors.accent
                                : (widget.isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _SocialIconButton — circle with hover glow + scale spring
// =============================================================================

class _SocialIconButton extends StatefulWidget {
  const _SocialIconButton({
    required this.icon,
    required this.url,
    required this.isDark,
  });

  final IconData icon;
  final String url;
  final bool isDark;

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.12)
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05)),
              border: Border.all(
                color: _isHovered
                    ? AppColors.accent
                    : (widget.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)),
                width: _isHovered ? 1.5 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 16,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 18,
                color: _isHovered
                    ? AppColors.accent
                    : (widget.isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// =============================================================================
// _FloatingLabelField — dark input with animated float label + cyan focus glow
// =============================================================================

class _FloatingLabelField extends StatefulWidget {
  const _FloatingLabelField({
    required this.controller,
    required this.label,
    required this.isDark,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool isDark;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  State<_FloatingLabelField> createState() => _FloatingLabelFieldState();
}

class _FloatingLabelFieldState extends State<_FloatingLabelField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDark
        ? const Color(0xFF14142B)
        : const Color(0xFFF1F5F9);
    final borderColor = _isFocused
        ? AppColors.accent
        : (widget.isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.1));

    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.2),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          validator: widget.validator,
          style: TextStyle(
            color: widget.isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _isFocused
                  ? AppColors.accent
                  : (widget.isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight),
              fontSize: 14,
            ),
            floatingLabelStyle: const TextStyle(
              color: AppColors.accent,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: bgColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: widget.maxLines > 1 ? AppSpacing.md : AppSpacing.sm,
            ),
            alignLabelWithHint: widget.maxLines > 1,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _GradientSubmitButton — full width, accent gradient, send icon, glow shadow
// =============================================================================

class _GradientSubmitButton extends StatefulWidget {
  const _GradientSubmitButton({
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  State<_GradientSubmitButton> createState() => _GradientSubmitButtonState();
}

class _GradientSubmitButtonState extends State<_GradientSubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentDark],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent
                    .withValues(alpha: _isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 24 : 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
