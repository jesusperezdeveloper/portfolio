import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('es')) {
    _loadLocale();
  }

  static const String _localeKey = 'locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);

    if (savedLocale != null) {
      emit(Locale(savedLocale));
    } else {
      // Detectar idioma del sistema
      final systemLocale = PlatformDispatcher.instance.locale;
      final languageCode = systemLocale.languageCode;

      // Soportamos ES y EN, default a ES si no es ninguno de los dos
      if (languageCode == 'en') {
        emit(const Locale('en'));
      } else {
        emit(const Locale('es'));
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    emit(locale);
  }

  Future<void> toggleLocale() async {
    final newLocale =
        state.languageCode == 'es' ? const Locale('en') : const Locale('es');
    await setLocale(newLocale);
  }

  bool get isSpanish => state.languageCode == 'es';
  bool get isEnglish => state.languageCode == 'en';
}
