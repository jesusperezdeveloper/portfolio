abstract class AppConfig {
  static const String appName = 'Jesús Pérez | Sofware Developer';
  static const String appTitle = 'Portfolio';

  // Version Info
  static const String appVersion = '1.0.4';
  static const int buildNumber = 5;
  static const String releaseDate = '2025-12-15';
  static const String versionFull = '$appVersion+$buildNumber';

  // Personal Info
  static const String fullName = 'Jesús Pérez';
  static const String role = 'Software Developer';
  static const String tagline = 'Building beautiful, performant mobile experiences';
  static const String email = 'jesus.perez.developer@gmail.com';
  static const String phone = '+34 654564278';
  static const String location = 'Jerez de la Frontera, Cádiz, Spain';

  // Social Links
  static const String githubUrl = 'https://github.com/jesusperezdeveloper';
  static const String linkedInUrl = 'https://www.linkedin.com/in/jesus-perez-sanchez-dev/';
  static const String twitterUrl = 'https://x.com/_jpsdeveloper';

  // External URLs
  static const String resumeUrl = 'https://example.com/resume.pdf';
  static const String calendlyUrl = 'https://calendly.com/jesusperezsan';

  // API Endpoints
  static const String githubApiBase = 'https://api.github.com';
  static const String githubUsername = 'jpsdeveloper';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableTerminalEasterEgg = true;
  static const bool enableViewSourceMode = true;
  static const bool enableDynamicTheme = true;

  // Animation Durations (milliseconds)
  static const int defaultAnimationDuration = 300;
  static const int longAnimationDuration = 600;
  static const int pageTransitionDuration = 400;

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double wideBreakpoint = 1440;
}
