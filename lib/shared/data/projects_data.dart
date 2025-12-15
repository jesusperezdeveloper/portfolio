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
    // Featured projects (orden: PaddockManager, FutBase, KPNTV+)
    ProjectData(
      id: 'paddock-manager',
      titleKey: 'project_paddock_title',
      descriptionKey: 'project_paddock_description',
      role: 'Founder & Lead Developer',
      techStack: ['Flutter', 'Firebase', 'BLoC', 'Clean Architecture'],
      liveUrl: 'https://paddockmanager.com/',
      featured: true,
    ),
    ProjectData(
      id: 'futbase',
      titleKey: 'project_futbase_title',
      descriptionKey: 'project_futbase_description',
      role: 'CoFounder & Developer',
      techStack: ['Flutter', 'Firebase', 'Real-time Stats', 'BLoC'],
      liveUrl: 'https://futbase.es',
      featured: true,
    ),
    ProjectData(
      id: 'kpntv',
      titleKey: 'project_kpntv_title',
      descriptionKey: 'project_kpntv_description',
      role: 'Flutter Developer @ Accenture',
      techStack: ['Flutter', 'Algolia', 'Video Player', 'TV Streaming'],
      featured: true,
    ),
    // Non-featured projects
    ProjectData(
      id: 'bit2me',
      titleKey: 'project_bit2me_title',
      descriptionKey: 'project_bit2me_description',
      role: 'Flutter Developer',
      techStack: ['Flutter', 'Secure Auth', 'Crypto APIs', 'BLoC'],
      liveUrl: 'https://bit2me.com',
    ),
    ProjectData(
      id: 'risk-engineers',
      titleKey: 'project_risk_title',
      descriptionKey: 'project_risk_description',
      role: 'Software Developer @ SlashMobility',
      techStack: ['Flutter', 'Clean Architecture', 'BLoC', 'REST APIs'],
    ),
  ];

  static List<ProjectData> get featuredProjects =>
      projects.where((p) => p.featured).toList();
}
