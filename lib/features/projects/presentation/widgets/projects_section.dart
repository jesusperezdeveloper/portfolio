import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/localization/app_localizations.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';
import 'package:portfolio_jps/core/utils/responsive.dart';
import 'package:portfolio_jps/shared/data/projects_data.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart';
import 'package:portfolio_jps/shared/widgets/horizontal_carousel.dart';
import 'package:portfolio_jps/shared/widgets/project_card_3d.dart';
import 'package:portfolio_jps/shared/widgets/section_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projects = ProjectsData.featuredProjects;
    final columns = Responsive.gridColumns(context);

    return SectionWrapper(
      sectionId: 'projects',
      title: l10n.projectsTitle,
      subtitle: l10n.projectsSubtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (columns == 1) {
            // Mobile: Horizontal Carousel
            final cardWidth = constraints.maxWidth > 400
                ? 340.0
                : constraints.maxWidth - 48;

            return HorizontalCarousel(
              itemHeight: 500,
              viewportFraction: 0.88,
              items: projects.map((project) {
                return CodePeekWrapper(
                  componentCode: ComponentCodes.projectCard,
                  child: ProjectCard3D(
                    title: l10n.translate(project.titleKey),
                    description: l10n.translate(project.descriptionKey),
                    imageUrl: project.imageUrl,
                    techStack: project.techStack,
                    role: project.role,
                    width: cardWidth,
                    onViewLive: project.liveUrl != null
                        ? () => _launchUrl(project.liveUrl!)
                        : null,
                    onViewCode: project.codeUrl != null
                        ? () => _launchUrl(project.codeUrl!)
                        : null,
                  ),
                );
              }).toList(),
            );
          }

          // Desktop: Grid
          return Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            alignment: WrapAlignment.center,
            children: projects.map((project) {
              return CodePeekWrapper(
                componentCode: ComponentCodes.projectCard,
                child: ProjectCard3D(
                  title: l10n.translate(project.titleKey),
                  description: l10n.translate(project.descriptionKey),
                  imageUrl: project.imageUrl,
                  techStack: project.techStack,
                  role: project.role,
                  onViewLive: project.liveUrl != null
                      ? () => _launchUrl(project.liveUrl!)
                      : null,
                  onViewCode: project.codeUrl != null
                      ? () => _launchUrl(project.codeUrl!)
                      : null,
                ),
              );
            }).toList(),
          );
        },
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
