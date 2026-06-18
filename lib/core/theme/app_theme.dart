import 'package:flutter/material.dart';

/// A centralized theme configuration class for the application.
/// 
/// This class encapsulates all visual style constants, ensuring consistent
/// branding and UI look-and-feel across different feature modules.
class AppTheme {
  
  /// Generates the global dark theme configuration for the application.
  /// 
  /// Implements a high-contrast dark color palette designed to match the 
  /// technical specification ("dark background, light text, accent color").
  static ThemeData get darkTheme {
    return ThemeData(
      // Establishes the base dark look-and-feel across default Material components
      brightness: Brightness.dark,
      
      // Strict hex-color mapping for deep dark layout screens
      scaffoldBackgroundColor: const Color(0xFF121212),
      
      // Global signature brand accent hue
      primaryColor: Colors.blueAccent,
      
      // Explicit configuration for sub-components (dialogs, sheets, textfields)
      colorScheme: const ColorScheme.dark(
        primary: Colors.blueAccent,
        surface: Color(0xFF1E1E1E), // Medium dark tone used for container backgrounds like Cards
      ),
      
      // Standardized text scaling hierarchy used across application text nodes
      textTheme: const TextTheme(
        // Massive bold numbers specifically tailored for the Pace Selector inputs
        displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
        
        // Default secondary font configuration for descriptions and subtitles
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }
}
