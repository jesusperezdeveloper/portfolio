import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';
  static const String _dynamicThemeKey = 'dynamic_theme_enabled';

  bool _isDynamicThemeEnabled = true;

  bool get isDynamicThemeEnabled => _isDynamicThemeEnabled;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDynamicThemeEnabled = prefs.getBool(_dynamicThemeKey) ?? true;

    if (_isDynamicThemeEnabled && AppConfig.enableDynamicTheme) {
      _applyDynamicTheme();
    } else {
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme != null) {
        emit(_themeFromString(savedTheme));
      }
    }
  }

  void _applyDynamicTheme() {
    final hour = DateTime.now().hour;
    // 6:00 - 18:00 = Light mode
    // 18:00 - 6:00 = Dark mode
    if (hour >= 6 && hour < 18) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _themeToString(mode));
    await prefs.setBool(_dynamicThemeKey, false);
    _isDynamicThemeEnabled = false;
    emit(mode);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newMode);
  }

  Future<void> enableDynamicTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dynamicThemeKey, true);
    _isDynamicThemeEnabled = true;
    _applyDynamicTheme();
  }

  Future<void> disableDynamicTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dynamicThemeKey, false);
    _isDynamicThemeEnabled = false;
  }

  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _themeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
}

// Extension for easy access in widgets
extension ThemeCubitContext on BuildContext {
  ThemeCubit get themeCubit => read<ThemeCubit>();
  ThemeMode get currentThemeMode => watch<ThemeCubit>().state;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
