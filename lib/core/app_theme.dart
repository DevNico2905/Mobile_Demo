import 'package:flutter/material.dart';

/// Colores y estilos compartidos de la app.
class AppTheme {
  AppTheme._();

  static const Color primaryBlue = Colors.blue;

  static const List<Color> gradientColors = [
    Color(0xFFEAF2FF),
    Color(0xFFD6E4FF),
  ];

  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: gradientColors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5),
    ],
  );

  static InputDecoration inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }
}
