import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeUTheme {
  static const Color _colRoxoEscuro = Color(0xFF281b43);
  static const Color _colRoxoVibrante = Color(0xFF8c02b6);
  static const Color _colLilasClaro = Color(0xFFe2a4ff);
  static const Color _colLilasBackground = Color(0xFFd6c0ff);
  static const Color _colCianoNeon = Color(0xFF00ffff);
  
  static const Color _colBranco = Color(0xFFFFFFFF);
  static const Color _colCinzaClaro = Color(0xFFe0e0e0);
  static const Color _colCinzaEscuro = Color(0xFF333333);
  static const Color _colPreto = Color(0xFF1a1a1a);
  
  static TextTheme _buildTextTheme({required bool isDark}) {
    Color primaryColor = isDark ? _colBranco : _colCinzaEscuro;
    Color secondaryColor = isDark ? _colCinzaClaro : _colRoxoEscuro;
    GoogleFonts.arimoTextTheme(); // Arimo é metrica compatível com Arial

    GoogleFonts.orbitronTextTheme();

    return TextTheme(
      displayLarge: GoogleFonts.orbitron(
        fontSize: 48,
        fontWeight: FontWeight.w700, // Bold
        height: 1.2,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.orbitron(
        fontSize: 36,
        fontWeight: FontWeight.w700, // Bold
        height: 1.2,
        color: primaryColor,
      ),
      displaySmall: GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w400, // Regular
        height: 1.3,
        color: isDark ? _colCianoNeon : _colRoxoVibrante, // Destaque visual
      ),
      headlineMedium: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.w400, // Regular
        height: 1.3,
        color: primaryColor,
      ),
      bodyLarge: GoogleFonts.arimo( // Fallback para Arial
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5, 
        color: primaryColor,
      ),
      bodyMedium: GoogleFonts.arimo(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryColor,
      ),
      labelLarge: GoogleFonts.orbitron(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _colRoxoEscuro,
      
      colorScheme: const ColorScheme.dark(
        primary: _colRoxoVibrante,
        onPrimary: _colBranco,
        secondary: _colCianoNeon,
        onSecondary: _colPreto,
        surface: _colRoxoEscuro,
        onSurface: _colBranco,
        onSurfaceVariant: _colLilasClaro,
        error: Color(0xFFCF6679),
      ),

      textTheme: _buildTextTheme(isDark: true),

      // Botões com Efeito Neon (Seção 1.4)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colRoxoVibrante,
          foregroundColor: _colBranco,
          elevation: 10,
          shadowColor: _colCianoNeon.withAlpha(150), // Glow Neon
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return _colCianoNeon.withAlpha(77);
            return null;
          }),
        ),
      ),
      
      // Inputs com borda Neon no foco (Seção 3.1.2)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _colPreto.withAlpha(77),
        labelStyle: const TextStyle(color: _colCinzaClaro),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _colLilasClaro.withAlpha(77)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _colCianoNeon, width: 2.0), // Foco Neon
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _colLilasBackground,

      colorScheme: const ColorScheme.light(
        primary: _colRoxoEscuro,
        onPrimary: _colBranco,
        secondary: _colRoxoVibrante,
        onSecondary: _colBranco,
        surface: _colLilasBackground,
        onSurface: _colCinzaEscuro,
      ),

      textTheme: _buildTextTheme(isDark: false),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _colRoxoEscuro,
          foregroundColor: _colBranco,
          elevation: 4,
          shadowColor: _colRoxoVibrante.withAlpha(102),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _colBranco,
        labelStyle: const TextStyle(color: _colRoxoEscuro),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _colRoxoVibrante, width: 2.0),
        ),
      ),
    );
  }
}
