import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import '../constants/strings.dart';
import '../services/database_service.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final _store = stringMapStoreFactory.store(AppStrings.settingsStoreName);
  final DatabaseService _dbService = DatabaseService.instance;

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final db = await _dbService.database;
      final savedData = await _store.record(AppStrings.themeModeKey).get(db);
      if (savedData != null) {
        final savedTheme = savedData['value'] as String?;
        if (savedTheme == 'light') {
          state = ThemeMode.light;
        } else if (savedTheme == 'dark') {
          state = ThemeMode.dark;
        } else {
          state = ThemeMode.system;
        }
      }
    } catch (_) {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final db = await _dbService.database;
      String val = 'system';
      if (mode == ThemeMode.light) val = 'light';
      if (mode == ThemeMode.dark) val = 'dark';
      await _store.record(AppStrings.themeModeKey).put(db, {'value': val});
    } catch (_) {}
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
