import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _pref;
  bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  // the methods defined below save user theme preference
  // It will persist

  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref.setBool(key, _darkTheme);
  }
}

ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[100],
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.grey[700],
    appBarTheme: AppBarTheme(
        color: Color(0xff343a40),
        textTheme: TextTheme(
          headline6: GoogleFonts.openSans(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white)),
        )),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: InputDecorationTheme(fillColor: Colors.grey[300]),
    textTheme: TextTheme(
      headline5: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black)),
      subtitle1: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              // fontSize: 12,
              color: Colors.grey[700])),
      subtitle2: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              // fontStyle: FontStyle.italic,
              // fontSize: 14,
              color: Colors.grey[700])),
      bodyText1: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: Colors.grey[700])),
      headline6: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black)),
    ));

ThemeData dark = ThemeData(
    secondaryHeaderColor: Colors.white70,
    appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0,
        textTheme: TextTheme(
          headline6: GoogleFonts.openSans(
              textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white)),
        )),
    brightness: Brightness.dark,
    accentColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardTheme: CardTheme(color: Colors.grey[850]),
    scaffoldBackgroundColor: Colors.grey[900],
    inputDecorationTheme: InputDecorationTheme(fillColor: Colors.grey[850]),
    textTheme: TextTheme(
      headline5: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white70)),
      subtitle1: GoogleFonts.openSans(
          textStyle:
              TextStyle(fontWeight: FontWeight.w400, color: Colors.white70)),
      subtitle2: GoogleFonts.openSans(
          textStyle:
              TextStyle(fontWeight: FontWeight.w400, color: Colors.grey[300])),
      bodyText1: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: Colors.white70)),
      headline6: GoogleFonts.openSans(
          textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white70)),
    ));
