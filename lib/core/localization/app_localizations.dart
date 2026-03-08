import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:portfolio_jps/core/localization/locale_cubit.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('es'),
    Locale('en'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  // ===========================================================================
  // TRADUCCIONES
  // ===========================================================================

  static final Map<String, Map<String, String>> _localizedValues = {
    'es': {
      // Navigation
      'nav_home': 'Inicio',
      'nav_about': 'Sobre Mí',
      'nav_projects': 'Proyectos',
      'nav_experience': 'Experiencia',
      'nav_skills': 'Habilidades',
      'nav_contact': 'Contacto',

      // Hero Section
      'hero_greeting': 'Hola, soy',
      'hero_name': 'Jesús Pérez',
      'hero_role': 'Senior Flutter Developer',
      'hero_tagline':
          'Transformo ideas en aplicaciones móviles excepcionales. '
              '+10 años creando experiencias de alto rendimiento con Flutter y arquitectura limpia.',
      'hero_cta_contact': 'Hablemos',
      'hero_cta_projects': 'Ver Portfolio',
      'hero_available': 'Disponible para nuevos proyectos',

      // About Section
      'about_title': 'Sobre Mí',
      'about_subtitle': 'Conoce un poco más sobre mi trayectoria',
      'about_description_1':
          'Soy un desarrollador de software apasionado con más de 10 años de experiencia '
              'creando aplicaciones móviles y soluciones tecnológicas innovadoras. '
              'Mi especialidad es Flutter, donde combino rendimiento excepcional con interfaces elegantes.',
      'about_description_2':
          'He tenido el privilegio de trabajar con empresas de primer nivel como Accenture, '
              'desarrollando aplicaciones con millones de usuarios activos. También he fundado '
              'mis propios proyectos, lo que me ha dado una visión completa del ciclo de vida del software.',
      'about_description_3':
          'Mi filosofía es simple: código limpio, arquitectura sólida y experiencias de usuario excepcionales. '
              'Creo firmemente en Clean Architecture y en las mejores prácticas que hacen que el software sea mantenible y escalable.',
      'about_stats_years': 'Años de experiencia',
      'about_stats_projects': 'Proyectos entregados',
      'about_stats_technologies': 'Tecnologías clave',
      'about_stats_languages': 'Idiomas hablados',

      // Projects Section
      'projects_title': 'Proyectos Destacados',
      'projects_subtitle':
          'Una selección de los proyectos en los que he trabajado',
      'projects_view_more': 'Ver más',
      'projects_view_live': 'Ver en vivo',
      'projects_view_code': 'Ver código',
      'projects_tech_stack': 'Stack tecnológico',

      // Project: Paddock Manager
      'project_paddock_title': 'Paddock Manager',
      'project_paddock_description':
          'Plataforma completa de gestión para motorsport. Desarrollada para RFME/ESBK, soporta 6 idiomas y gestiona competiciones, equipos y pilotos en tiempo real.',
      'project_paddock_role': 'Fundador & Lead Developer',

      // Project: FutBase
      'project_futbase_title': 'FutBase',
      'project_futbase_description':
          'La plataforma de gestión deportiva más completa. Gestiona equipos, jugadores, entrenamientos, partidos y estadísticas en tiempo real desde cualquier lugar.',
      'project_futbase_role': 'Founder & Lead Developer',

      // Project: KPNTV+
      'project_kpntv_title': 'KPNTV+',
      'project_kpntv_description':
          'Aplicación de streaming con más de 7 millones de usuarios activos. Desarrollada en Accenture con arquitectura escalable y reproducción de video optimizada.',
      'project_kpntv_role': 'Flutter Developer',

      // Project: Bit2Me
      'project_bit2me_title': 'Bit2Me',
      'project_bit2me_description':
          'Plataforma de trading de criptomonedas con autenticación segura y APIs financieras de alto rendimiento.',
      'project_bit2me_role': 'Flutter Developer',

      // Project: Risk Engineers
      'project_risk_title': 'Risk Engineers',
      'project_risk_description':
          'Aplicación para el sector asegurador de UK/USA. Gestión de riesgos y evaluaciones con arquitectura limpia y BLoC.',
      'project_risk_role': 'Senior Flutter Engineer',

      // Experience Section
      'experience_title': 'Experiencia Profesional',
      'experience_subtitle': 'Mi trayectoria en el desarrollo de software',
      'experience_present': 'Presente',

      // Skills Section
      'skills_title': 'Habilidades Técnicas',
      'skills_subtitle': 'Tecnologías y herramientas que domino',
      'skills_languages': 'Lenguajes',
      'skills_frameworks': 'Frameworks',
      'skills_tools': 'Herramientas',
      'skills_cloud': 'Cloud',

      // Contact Section
      'contact_title': 'Contacto',
      'contact_subtitle': '¿Tienes un proyecto en mente? ¡Hablemos!',
      'contact_name': 'Nombre',
      'contact_email': 'Email',
      'contact_message': 'Mensaje',
      'contact_send': 'Enviar mensaje',
      'contact_sending': 'Enviando...',
      'contact_success': '¡Mensaje enviado correctamente!',
      'contact_error': 'Error al enviar el mensaje',
      'contact_location': 'Ubicación',
      'contact_availability': 'Disponibilidad',
      'contact_available_freelance': 'Disponible para freelance',

      // Footer
      'footer_rights': 'Todos los derechos reservados',
      'footer_built_with': 'Construido con Flutter',

      // Terminal Easter Egg
      'terminal_welcome': 'Bienvenido al terminal de Jesús',
      'terminal_help': 'Escribe "help" para ver los comandos disponibles',
      'terminal_cmd_help': 'Muestra los comandos disponibles',
      'terminal_cmd_about': 'Información sobre mí',
      'terminal_cmd_skills': 'Lista mis habilidades',
      'terminal_cmd_experience': 'Mi experiencia profesional',
      'terminal_cmd_contact': 'Información de contacto',
      'terminal_cmd_projects': 'Lista mis proyectos',
      'terminal_cmd_clear': 'Limpia el terminal',
      'terminal_not_found': 'Comando no encontrado',

      // Misc
      'theme_light': 'Modo claro',
      'theme_dark': 'Modo oscuro',
      'theme_auto': 'Automático',
      'language': 'Idioma',
      'view_source': 'Ver código fuente',
      'loading': 'Cargando...',
      'error': 'Error',
      'retry': 'Reintentar',
    },
    'en': {
      // Navigation
      'nav_home': 'Home',
      'nav_about': 'About',
      'nav_projects': 'Projects',
      'nav_experience': 'Experience',
      'nav_skills': 'Skills',
      'nav_contact': 'Contact',

      // Hero Section
      'hero_greeting': "Hi, I'm",
      'hero_name': 'Jesús Pérez',
      'hero_role': 'Senior Flutter Developer',
      'hero_tagline':
          'I transform ideas into exceptional mobile applications. '
              '+10 years crafting high-performance experiences with Flutter and clean architecture.',
      'hero_cta_contact': "Let's Talk",
      'hero_cta_projects': 'View Portfolio',
      'hero_available': 'Available for new projects',

      // About Section
      'about_title': 'About Me',
      'about_subtitle': 'Learn a bit more about my journey',
      'about_description_1':
          "I'm a passionate software developer with over 10 years of experience "
              'building mobile applications and innovative tech solutions. '
              'My specialty is Flutter, where I combine exceptional performance with elegant interfaces.',
      'about_description_2':
          "I've had the privilege of working with top-tier companies like Accenture, "
              'developing applications with millions of active users. I have also founded '
              'my own projects, giving me a complete view of the software lifecycle.',
      'about_description_3':
          'My philosophy is simple: clean code, solid architecture, and exceptional user experiences. '
              'I firmly believe in Clean Architecture and best practices that make software maintainable and scalable.',
      'about_stats_years': 'Years of experience',
      'about_stats_projects': 'Projects delivered',
      'about_stats_technologies': 'Key technologies',
      'about_stats_languages': 'Languages spoken',

      // Projects Section
      'projects_title': 'Featured Projects',
      'projects_subtitle': "A selection of projects I've worked on",
      'projects_view_more': 'View more',
      'projects_view_live': 'View live',
      'projects_view_code': 'View code',
      'projects_tech_stack': 'Tech stack',

      // Project: Paddock Manager
      'project_paddock_title': 'Paddock Manager',
      'project_paddock_description':
          'Complete motorsport management platform. Built for RFME/ESBK, supports 6 languages and manages competitions, teams, and riders in real-time.',
      'project_paddock_role': 'Founder & Lead Developer',

      // Project: FutBase
      'project_futbase_title': 'FutBase',
      'project_futbase_description':
          'The most complete sports management platform. Manage teams, players, trainings, matches and real-time statistics from anywhere.',
      'project_futbase_role': 'Founder & Lead Developer',

      // Project: KPNTV+
      'project_kpntv_title': 'KPNTV+',
      'project_kpntv_description':
          'Streaming app with over 7 million active users. Developed at Accenture with scalable architecture and optimized video playback.',
      'project_kpntv_role': 'Flutter Developer',

      // Project: Bit2Me
      'project_bit2me_title': 'Bit2Me',
      'project_bit2me_description':
          'Cryptocurrency trading platform with secure authentication and high-performance financial APIs.',
      'project_bit2me_role': 'Flutter Developer',

      // Project: Risk Engineers
      'project_risk_title': 'Risk Engineers',
      'project_risk_description':
          'UK/USA insurance sector application. Risk management and assessments with clean architecture and BLoC.',
      'project_risk_role': 'Senior Flutter Engineer',

      // Experience Section
      'experience_title': 'Professional Experience',
      'experience_subtitle': 'My journey in software development',
      'experience_present': 'Present',

      // Skills Section
      'skills_title': 'Technical Skills',
      'skills_subtitle': 'Technologies and tools I master',
      'skills_languages': 'Languages',
      'skills_frameworks': 'Frameworks',
      'skills_tools': 'Tools',
      'skills_cloud': 'Cloud',

      // Contact Section
      'contact_title': 'Contact',
      'contact_subtitle': "Have a project in mind? Let's talk!",
      'contact_name': 'Name',
      'contact_email': 'Email',
      'contact_message': 'Message',
      'contact_send': 'Send message',
      'contact_sending': 'Sending...',
      'contact_success': 'Message sent successfully!',
      'contact_error': 'Error sending message',
      'contact_location': 'Location',
      'contact_availability': 'Availability',
      'contact_available_freelance': 'Available for freelance',

      // Footer
      'footer_rights': 'All rights reserved',
      'footer_built_with': 'Built with Flutter',

      // Terminal Easter Egg
      'terminal_welcome': "Welcome to Jesús's terminal",
      'terminal_help': 'Type "help" to see available commands',
      'terminal_cmd_help': 'Show available commands',
      'terminal_cmd_about': 'Information about me',
      'terminal_cmd_skills': 'List my skills',
      'terminal_cmd_experience': 'My professional experience',
      'terminal_cmd_contact': 'Contact information',
      'terminal_cmd_projects': 'List my projects',
      'terminal_cmd_clear': 'Clear terminal',
      'terminal_not_found': 'Command not found',

      // Misc
      'theme_light': 'Light mode',
      'theme_dark': 'Dark mode',
      'theme_auto': 'Automatic',
      'language': 'Language',
      'view_source': 'View source code',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Accesores rápidos para traducciones comunes
  String get navHome => translate('nav_home');
  String get navAbout => translate('nav_about');
  String get navProjects => translate('nav_projects');
  String get navExperience => translate('nav_experience');
  String get navSkills => translate('nav_skills');
  String get navContact => translate('nav_contact');

  String get heroGreeting => translate('hero_greeting');
  String get heroName => translate('hero_name');
  String get heroRole => translate('hero_role');
  String get heroTagline => translate('hero_tagline');
  String get heroCtaContact => translate('hero_cta_contact');
  String get heroCtaProjects => translate('hero_cta_projects');
  String get heroAvailable => translate('hero_available');

  String get projectsTitle => translate('projects_title');
  String get projectsSubtitle => translate('projects_subtitle');

  String get experienceTitle => translate('experience_title');
  String get experienceSubtitle => translate('experience_subtitle');
  String get experiencePresent => translate('experience_present');

  String get skillsTitle => translate('skills_title');
  String get skillsSubtitle => translate('skills_subtitle');

  String get contactTitle => translate('contact_title');
  String get contactSubtitle => translate('contact_subtitle');
  String get contactName => translate('contact_name');
  String get contactEmail => translate('contact_email');
  String get contactMessage => translate('contact_message');
  String get contactSend => translate('contact_send');
  String get contactSuccess => translate('contact_success');
  String get contactError => translate('contact_error');

  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension para acceso fácil desde BuildContext
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  LocaleCubit get localeCubit => read<LocaleCubit>();
  bool get isSpanish => watch<LocaleCubit>().isSpanish;
  bool get isEnglish => watch<LocaleCubit>().isEnglish;
}
