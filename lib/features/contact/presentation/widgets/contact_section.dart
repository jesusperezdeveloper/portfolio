import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_jps/core/config/app_config.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/widgets/animated_button.dart';
import 'package:portfolio_jps/shared/widgets/section_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simular envío (aquí iría la lógica real de Firebase/email)
    await Future<void>.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });

    // Reset después de 3 segundos
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isSubmitted = false);
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);

    return SectionWrapper(
      sectionId: 'contact',
      title: l10n.contactTitle,
      subtitle: l10n.contactSubtitle,
      child: isMobile
          ? _buildMobileLayout(context, l10n, isDark)
          : _buildDesktopLayout(context, l10n, isDark),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Info
        Expanded(
          flex: 2,
          child: _buildContactInfo(context, l10n, isDark),
        ),
        const SizedBox(width: AppSpacing.xxl),
        // Contact Form
        Expanded(
          flex: 3,
          child: _buildContactForm(context, l10n, isDark),
        ),
      ],
    );
  }

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

  Widget _buildContactInfo(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location
        _ContactInfoItem(
          icon: Icons.location_on_outlined,
          title: l10n.translate('contact_location'),
          value: AppConfig.location,
          isDark: isDark,
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: AppSpacing.lg),
        // Email
        _ContactInfoItem(
          icon: Icons.email_outlined,
          title: 'Email',
          value: AppConfig.email,
          isDark: isDark,
          onTap: () => _launchUrl('mailto:${AppConfig.email}'),
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 500.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: AppSpacing.lg),
        // Phone
        _ContactInfoItem(
          icon: Icons.phone_outlined,
          title: 'Phone',
          value: AppConfig.phone,
          isDark: isDark,
          onTap: () => _launchUrl('tel:${AppConfig.phone}'),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms)
            .slideX(begin: -0.2, end: 0),
        const SizedBox(height: AppSpacing.xl),
        // Social Links
        Text(
          'Social',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 500.ms),
        const SizedBox(height: AppSpacing.md),
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
            .fadeIn(delay: 600.ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildContactForm(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    if (_isSubmitted) {
      return _buildSuccessMessage(context, l10n, isDark);
    }

    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.contactName,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: AppSpacing.md),
            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.contactEmail,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Por favor ingresa un email válido';
                }
                return null;
              },
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: AppSpacing.md),
            // Message field
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: l10n.contactMessage,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.message_outlined),
                ),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu mensaje';
                }
                return null;
              },
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: AppSpacing.lg),
            // Submit button
            AnimatedButton(
              text: _isSubmitting
                  ? l10n.translate('contact_sending')
                  : l10n.contactSend,
              onPressed: _isSubmitting ? null : _submitForm,
              isLoading: _isSubmitting,
              icon: Icons.send,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Container(
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusLg,
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactInfoItem extends StatelessWidget {
  const _ContactInfoItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor:
            onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                icon,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: onTap != null ? AppColors.accent : null,
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
        onTap: () => _launchUrl(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.accent
                : (widget.isDark ? AppColors.cardDark : AppColors.cardLight),
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1)),
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered
                ? AppColors.primaryDark
                : (widget.isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
