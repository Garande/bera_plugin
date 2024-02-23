import 'package:flutter/material.dart';

import 'hex_color.dart';

class AppPalette {
  AppPalette._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyBlack = Color(0xFF213333);
  // static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color.fromRGBO(225, 228, 229, 1.0);
  static const Color nearlyDarkBlue = Color(0xFF4E54C8);

  static const Color nearlyBlue = Color(0xFF8F94FB);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);
  static const Color lightGrey = Color.fromRGBO(0, 0, 0, 0.05);

  static const Color favoritesGutterAccent = Color.fromRGBO(229, 55, 108, 1.0);

  static const instaRed = Color.fromRGBO(253, 29, 29, 1);
  static const instaViolet = Color.fromRGBO(193, 53, 132, 1);
  static const instaBlue = Color.fromRGBO(64, 93, 230, 1);
  static const instaDkYellow = Color.fromRGBO(252, 175, 69, 1);
  static const instaLtYellow = Color.fromRGBO(255, 220, 128, 1);

  static const Color darkText = Color.fromRGBO(0, 0, 0, 0.87);
  static const Color darkerText = Color(0xff0C233C); // Color(0xFF17262A);
  static const Color lightText = Color.fromRGBO(255, 255, 255, 0.87);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static const Color beige = Color(0xFFA8A878);
  static const Color black = Color(0xFF303943);
  static const Color blue = Color(0xFF429BED);
  static const Color brown = Color(0xFFB1736C);
  static const Color darkBrown = Color(0xD0795548);
  // static const Color grey = Color(0x64303943);
  static const Color indigo = Color(0xFF6C79DB);
  static const Color lightBlue = Color(0xFF58ABF6);
  static const Color lightBrown = Color(0xFFCA8179);
  static const Color lightCyan = Color(0xFF98D8D8);
  static const Color lightGreen = Color(0xFF78C850);
  static const Color lighterGrey = Color(0xFFF4F5F4);
  // static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color lightPink = Color(0xFFEE99AC);
  static const Color lightPurple = Color(0xFF9F5BBA);
  static const Color lightRed = Color(0xFFF7786B);
  static const Color lightTeal = Color(0xFF2CDAB1);
  static const Color lightYellow = Color(0xFFFFCE4B);
  static const Color lilac = Color(0xFFA890F0);
  static const Color pink = Color(0xFFF85888);
  static const Color purple = Color(0xFF7C538C);
  static const Color red = Color(0xFFFA6555);
  static const Color teal = Color(0xFF4FC1A6);
  static const Color yellow = Color(0xFFF6C747);
  static const Color violet = Color(0xD07038F8);

  static const Color primaryColor = Color(0xFF8F94FB);
  static const Color primaryColorDark = Color(0xFF4E54C8);

  static Color overlayDark = HexColor('#ebf5ed');

  static const Color lightColor = Color(0xffDBDDF4);

  static const Color titleTextColor = Color(0xFF303030);

  static const Color textLightColor = Color(0xFF959595);

  static const Color warningColor = Color(0xFFFF8748);

  static const Color dangerColor = Color(0xFFFF4848);

  static const Color successColor = Color(0xFF36C12C);

  static const String fontName = 'NunitoSans';

  static Color primaryBlack = HexColor('#323441');
  static Color primaryBlue = HexColor('#66AAFF');
  static Color primaryOrange = HexColor('#F8C060');
  static Color primaryRed = HexColor('#FF7F61');
  static Color primaryWhiteOrange = HexColor('#FFF2F2');
  static Color primaryNotWhite = HexColor('#FCFCFC');

  //card boxShadow
  static List<BoxShadow> boxShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          offset: const Offset(0.0, 3.0),
          blurRadius: 7.0,
        ),
      ];
  //icon boxShadow
  static List<BoxShadow> iconBoxShadow(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).shadowColor,
          offset: const Offset(1, 6.0),
          blurRadius: 15.0,
        ),
        BoxShadow(
          color: Theme.of(context).shadowColor,
          offset: const Offset(1, 6.0),
          blurRadius: 15.0,
        ),
      ];

  static Color textColor = HexColor('#3D2C1D');

  static final themeData = ThemeData(
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: Colors.grey[100],
    primarySwatch: Colors.blue,
    // primaryColor: HexColor('#FF6960'), // const Color(0xFF4E54C8),
    // primaryColorDark: HexColor('#FF6960'), // const Color(0xFF4E54C8),
    // primaryColorLight: HexColor('#FF968F'), // const Color(0xFF8F94FB),
    //
    primaryColor: const Color(0xFF4E54C8),
    primaryColorDark: const Color(0xFF4E54C8),
    primaryColorLight: const Color(0xFF8F94FB),

    //
    cardColor: Colors.white,
    shadowColor: HexColor('#ebf5ed'),
    fontFamily: fontName,
    iconTheme: IconThemeData(
      color: HexColor('#3D2C1D'),
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        fontFamily: fontName,
        color: Color(0xff0C233C),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      displayLarge: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0.27,
        color: Color(0xff0C233C),
      ),
      titleMedium: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: -0.04,
        color: darkText,
      ),
      titleSmall: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: -0.04,
        color: darkText,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontName,
        color: Color(0xff646464),
        fontSize: 13,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      secondary: HexColor('#FBA308'),
      secondaryContainer: HexColor('#fcb539'),
      primaryContainer: const Color(0xFF8F94FB),
      primary: const Color(0xFF4E54C8),
      // primaryContainer: HexColor('#FF968F'), // const Color(0xFF8F94FB),
      // primary: HexColor('#FF6960'), // const Color(0xFF4E54C8),
      background: Colors.grey[100],
    ),
  );
}
