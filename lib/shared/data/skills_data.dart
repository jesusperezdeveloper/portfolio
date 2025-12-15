import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SkillLevel { beginner, intermediate, advanced, expert }

class SkillData {
  const SkillData({
    required this.name,
    required this.icon,
    required this.level,
    this.color,
  });

  final String name;
  final IconData icon;
  final SkillLevel level;
  final Color? color;

  double get levelValue => switch (level) {
        SkillLevel.beginner => 0.25,
        SkillLevel.intermediate => 0.5,
        SkillLevel.advanced => 0.75,
        SkillLevel.expert => 1.0,
      };
}

class SkillCategory {
  const SkillCategory({
    required this.nameKey,
    required this.skills,
    required this.icon,
  });

  final String nameKey;
  final List<SkillData> skills;
  final IconData icon;
}

abstract class SkillsData {
  static const List<SkillCategory> categories = [
    SkillCategory(
      nameKey: 'skills_languages',
      icon: Icons.code,
      skills: [
        SkillData(
          name: 'Dart',
          icon: FontAwesomeIcons.bullseye,
          level: SkillLevel.expert,
          color: Color(0xFF0175C2),
        ),
        SkillData(
          name: 'Kotlin',
          icon: FontAwesomeIcons.android,
          level: SkillLevel.intermediate,
          color: Color(0xFF7F52FF),
        ),
        SkillData(
          name: 'Swift',
          icon: FontAwesomeIcons.apple,
          level: SkillLevel.intermediate,
          color: Color(0xFFFA7343),
        ),
        SkillData(
          name: 'Python',
          icon: FontAwesomeIcons.python,
          level: SkillLevel.advanced,
          color: Color(0xFF3776AB),
        ),
      ],
    ),
    SkillCategory(
      nameKey: 'skills_frameworks',
      icon: Icons.widgets,
      skills: [
        SkillData(
          name: 'Flutter',
          icon: FontAwesomeIcons.mobile,
          level: SkillLevel.expert,
          color: Color(0xFF02569B),
        ),
        SkillData(
          name: 'BLoC/Cubit',
          icon: Icons.account_tree,
          level: SkillLevel.expert,
          color: Color(0xFF00D4FF),
        ),
        SkillData(
          name: 'Clean Architecture',
          icon: Icons.architecture,
          level: SkillLevel.expert,
          color: Color(0xFF6366F1),
        ),
        SkillData(
          name: 'Firebase',
          icon: FontAwesomeIcons.fire,
          level: SkillLevel.expert,
          color: Color(0xFFFFCA28),
        ),
        SkillData(
          name: 'n8n',
          icon: Icons.auto_awesome,
          level: SkillLevel.advanced,
          color: Color(0xFFEA4B71),
        ),
      ],
    ),
    SkillCategory(
      nameKey: 'skills_tools',
      icon: Icons.build,
      skills: [
        SkillData(
          name: 'Git/GitHub',
          icon: FontAwesomeIcons.github,
          level: SkillLevel.expert,
          color: Color(0xFF181717),
        ),
        SkillData(
          name: 'Figma',
          icon: FontAwesomeIcons.figma,
          level: SkillLevel.advanced,
          color: Color(0xFFF24E1E),
        ),
        SkillData(
          name: 'VS Code',
          icon: Icons.code,
          level: SkillLevel.expert,
          color: Color(0xFF007ACC),
        ),
        SkillData(
          name: 'Android Studio',
          icon: FontAwesomeIcons.android,
          level: SkillLevel.expert,
          color: Color(0xFF3DDC84),
        ),
        SkillData(
          name: 'Xcode',
          icon: FontAwesomeIcons.apple,
          level: SkillLevel.advanced,
          color: Color(0xFF147EFB),
        ),
      ],
    ),
    SkillCategory(
      nameKey: 'skills_cloud',
      icon: Icons.cloud,
      skills: [
        SkillData(
          name: 'Firebase',
          icon: FontAwesomeIcons.fire,
          level: SkillLevel.expert,
          color: Color(0xFFFFCA28),
        ),
        SkillData(
          name: 'Google Cloud',
          icon: FontAwesomeIcons.google,
          level: SkillLevel.advanced,
          color: Color(0xFF4285F4),
        ),
        SkillData(
          name: 'Supabase',
          icon: Icons.storage,
          level: SkillLevel.intermediate,
          color: Color(0xFF3ECF8E),
        ),
      ],
    ),
  ];
}
