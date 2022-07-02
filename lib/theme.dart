import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CinemaTheme {
  static TextStyle get textStyle {
    return GoogleFonts.rubik(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
  }

  static TextStyle get detailsTextStyle {
    return GoogleFonts.rubik(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    );
  }

  static Color get backgroundColor => const Color(0xFF15141F);
  static BorderRadius get cardBorderRadius => BorderRadius.circular(8.0);
}
