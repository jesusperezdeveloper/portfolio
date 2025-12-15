class ProjectData {
  const ProjectData({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.role,
    required this.techStack,
    this.imageUrl = '',
    this.liveUrl,
    this.codeUrl,
    this.featured = false,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String role;
  final List<String> techStack;
  final String imageUrl;
  final String? liveUrl;
  final String? codeUrl;
  final bool featured;
}

abstract class ProjectsData {
  static const List<ProjectData> projects = [
    ProjectData(
      id: 'paddock-manager',
      titleKey: 'project_paddock_title',
      descriptionKey: 'project_paddock_description',
      role: 'Founder & Lead Developer',
      techStack: ['Flutter', 'Firebase', 'BLoC', 'Clean Architecture', 'i18n'],
      liveUrl: 'https://paddockmanager.app',
      featured: true,
    ),
    ProjectData(
      id: 'kpntv',
      titleKey: 'project_kpntv_title',
      descriptionKey: 'project_kpntv_description',
      role: 'Flutter Developer @ Accenture',
      techStack: ['Flutter', 'GraphQL', 'Video Player', 'Analytics'],
      featured: true,
    ),
    ProjectData(
      id: 'bit2me',
      titleKey: 'project_bit2me_title',
      descriptionKey: 'project_bit2me_description',
      role: 'Flutter Developer',
      techStack: ['Flutter', 'Secure Auth', 'Crypto APIs', 'BLoC'],
      liveUrl: 'https://bit2me.com',
      featured: true,
    ),
    ProjectData(
      id: 'risk-engineers',
      titleKey: 'project_risk_title',
      descriptionKey: 'project_risk_description',
      role: 'Software Developer @ SlashMobility',
      techStack: ['Flutter', 'Clean Architecture', 'BLoC', 'REST APIs'],
      featured: true,
    ),
  ];

  static List<ProjectData> get featuredProjects =>
      projects.where((p) => p.featured).toList();
}
