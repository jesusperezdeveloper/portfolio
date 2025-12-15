import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_jps/core/config/app_config.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: isMobile
              ? _buildMobileLayout(context, l10n, isDark)
              : _buildDesktopLayout(context, l10n, isDark),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left - Copyright
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '© ${DateTime.now().year} ${AppConfig.fullName}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.translate('footer_rights'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
            ),
          ],
        ),
        // Center - Built with
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.translate('footer_built_with'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const FlutterLogo(size: 20),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.favorite,
              size: 16,
              color: AppColors.error,
            ),
          ],
        ),
        // Right - Social Links
        _buildSocialLinks(isDark),
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
        _buildSocialLinks(isDark),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.translate('footer_built_with'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const FlutterLogo(size: 18),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.favorite,
              size: 14,
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          '© ${DateTime.now().year} ${AppConfig.fullName}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks(bool isDark) {
    final socialLinks = [
      (FontAwesomeIcons.github, AppConfig.githubUrl),
      (FontAwesomeIcons.linkedin, AppConfig.linkedInUrl),
      (FontAwesomeIcons.twitter, AppConfig.twitterUrl),
      (Icons.email_outlined, 'mailto:${AppConfig.email}'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: socialLinks.map((item) {
        return _SocialButton(
          icon: item.$1,
          url: item.$2,
          isDark: isDark,
        );
      }).toList(),
    );
  }
}

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.icon,
    required this.url,
    required this.isDark,
  });

  final IconData icon;
  final String url;
  final bool isDark;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
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
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.accent.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: AppSpacing.borderRadiusFull,
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent
                  : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.1)),
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered
                ? AppColors.accent
                : (widget.isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
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
