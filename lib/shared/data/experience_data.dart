class ExperienceData {
  const ExperienceData({
    required this.company,
    required this.role,
    required this.startDate,
    required this.description,
    required this.achievements,
    this.endDate,
    this.logoUrl,
    this.companyUrl,
  });

  final String company;
  final String role;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final List<String> achievements;
  final String? logoUrl;
  final String? companyUrl;

  bool get isCurrent => endDate == null;

  String get dateRange {
    final start = '${_monthName(startDate.month)} ${startDate.year}';
    final end = endDate != null
        ? '${_monthName(endDate!.month)} ${endDate!.year}'
        : 'Presente';
    return '$start - $end';
  }

  static String _monthName(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return months[month - 1];
  }
}

abstract class ExperiencesData {
  static final List<ExperienceData> experiences = [
    ExperienceData(
      company: 'SlashMobility',
      role: 'Software Developer',
      startDate: DateTime(2025, 5),
      description: 'Revamp de app Zurich Onsite para ingenieros de riesgos de UK/USA para iPad.',
      achievements: [
        'Arquitectura Monorepo Flutter Modular',
        'HIVE con Socket IO',
        'Golden Tests',
        'CI/CD con Azure Pipelines',
      ],
      companyUrl: 'https://slashmobility.com',
    ),
    ExperienceData(
      company: 'Paddock Manager',
      role: 'Founder & Lead Developer',
      startDate: DateTime(2023),
      description: 'Plataforma completa de gestión para motorsport. Desarrollada para RFME/ESBK.',
      achievements: [
        'Gestión de competiciones, equipos y pilotos',
        'Soporte para 6 idiomas',
        'Live timing y resultados en tiempo real',
        'App Oficial ESBK 2025',
      ],
      companyUrl: 'https://paddockmanager.app',
    ),
    ExperienceData(
      company: 'Bit2Me',
      role: 'Flutter Developer',
      startDate: DateTime(2022, 6),
      endDate: DateTime(2023),
      description: 'Plataforma de trading de criptomonedas líder en España.',
      achievements: [
        'Participación en el área de Onboarding de nuevos clientes',
        'Implementación de Calculadora de Crypto',
        'Mejoras en el proceso de Trading',
        'Mejoras en programa de fidelización Space Center',
      ],
      companyUrl: 'https://bit2me.com',
    ),
    ExperienceData(
      company: 'Accenture',
      role: 'Flutter Developer',
      startDate: DateTime(2020, 3),
      description: 'Desarrollo de aplicaciones enterprise para grandes clientes.',
      endDate: DateTime(2022, 6),
      achievements: [
        'KPNTV+ - App de streaming con 7M de usuarios',
        'QEDU - Plataforma Educativa del Gobierno de España',
        'SGS - Aplicación de Inspecciones de contenedores marítimos',
        'Zurich - App de Geofencing y cuidado de familiares menores de edad',
      ],
      companyUrl: 'https://accenture.com',
    ),
  ];
}
