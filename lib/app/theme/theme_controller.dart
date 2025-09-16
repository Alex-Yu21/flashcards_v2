import 'package:flutter/material.dart';

import 'app_colors.dart';

enum CustomTheme { rose, forest, ocean }

class ThemeController extends ValueNotifier<CustomTheme?> {
  ThemeController([super.fixed]) : _mode = ThemeMode.system;

  ThemeMode _mode;
  ThemeMode get themeMode => _mode;
  void setMode(ThemeMode m) {
    if (_mode == m) return;
    _mode = m;
    notifyListeners();
  }

  void followSystem() => setMode(ThemeMode.system);
  void forceLight() => setMode(ThemeMode.light);
  void forceDark() => setMode(ThemeMode.dark);

  void setCustom(CustomTheme? id) => value = id;

  ThemeData get theme => _build(Brightness.light);
  ThemeData get darkTheme => _build(Brightness.dark);

  ThemeData _build(Brightness b) {
    final seed = switch (value) {
      null => const Color(0xFF230C8A),
      CustomTheme.rose => const Color(0xFFE88DA9),
      CustomTheme.forest => const Color(0xFF124022),
      CustomTheme.ocean => const Color(0xFF35538A),
    };
    final base = ColorScheme.fromSeed(seedColor: seed, brightness: b);
    final scheme = AppColors.apply(base, brightness: b, custom: value?.name);
    return ThemeData(useMaterial3: true, colorScheme: scheme);
  }
}



/* TODO: дать пользователю настройку из юай
heme.setCustom(CustomTheme.rose); -  выбрать кастомный seed
theme.followSystem();              - яркость по системе
theme.forceLight();                - всегда светлая
theme.forceDark();                 - всегда тёмная 
*/ 