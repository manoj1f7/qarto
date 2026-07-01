import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  // Start with the system's default theme
  ThemeCubit() : super(ThemeMode.system);

  // Pass in whether the UI is currently dark, and emit the opposite
  void toggleTheme(bool isCurrentlyDark) {
    emit(isCurrentlyDark ? ThemeMode.light : ThemeMode.dark);
  }
}
