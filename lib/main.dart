import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './widgets/countries.dart';
import './pages/countrypage.dart';
import './widgets/world.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: AppBarTheme(
              color: Color(0xff343a40),
              // color: Colors.blueGrey[900],
              textTheme: TextTheme(
                headline6: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white)),
              )),
          // primaryColor: Color(0xff343a40),
          // accentColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme:
              InputDecorationTheme(fillColor: Colors.grey[300]),
          textTheme: TextTheme(
            headline5: GoogleFonts.openSans(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black)),
            subtitle1: GoogleFonts.openSans(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey[700])),
            subtitle2: GoogleFonts.openSans(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Colors.grey[700])),
            bodyText1: GoogleFonts.openSans(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.grey[700])),
            headline6: GoogleFonts.openSans(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black)),
          )),
      // darkTheme: ThemeData(
      //     appBarTheme: AppBarTheme(
      //         color: Colors.black,
      //         elevation: 0,
      //         textTheme: TextTheme(
      //           headline6: GoogleFonts.openSans(
      //               textStyle: TextStyle(
      //                   fontWeight: FontWeight.w600,
      //                   fontSize: 16,
      //                   color: Colors.white)),
      //         )),
      //     brightness: Brightness.dark,
      //     // primaryColor: Colors.black,
      //     accentColor: Colors.white,
      //     visualDensity: VisualDensity.adaptivePlatformDensity,
      //     cardTheme: CardTheme(color: Colors.grey[850]),
      //     scaffoldBackgroundColor: Colors.grey[900],
      //     inputDecorationTheme:
      //         InputDecorationTheme(fillColor: Colors.grey[850]),
      //     textTheme: TextTheme(
      //       headline5: GoogleFonts.openSans(
      //           textStyle: TextStyle(
      //               fontWeight: FontWeight.w600,
      //               fontSize: 18,
      //               color: Colors.white)),
      //       subtitle1: GoogleFonts.openSans(
      //           textStyle: TextStyle(
      //               fontWeight: FontWeight.w400,
      //               fontSize: 12,
      //               color: Colors.amber[300])),
      //       subtitle2: GoogleFonts.openSans(
      //           textStyle: TextStyle(
      //               fontWeight: FontWeight.w400,
      //               fontStyle: FontStyle.italic,
      //               fontSize: 14,
      //               color: Colors.grey[300])),
      //       bodyText1: GoogleFonts.openSans(
      //           textStyle: TextStyle(
      //               fontWeight: FontWeight.w400,
      //               fontSize: 10,
      //               color: Colors.white)),
      //       headline6: GoogleFonts.openSans(
      //           textStyle: TextStyle(
      //               fontWeight: FontWeight.w600,
      //               fontSize: 16,
      //               color: Colors.white)),
      //     )),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/country': (context) => CountryPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          // backgroundColor: Colors.grey[100],
          appBar: AppBar(
            // backgroundColor: Colors.black,
            // elevation: 0,
            centerTitle: false,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Worldwide'),
                Tab(text: 'Countries'),
              ],
            ),
            title: Text(
              'COVID-19 Dashboard',
              style: Theme.of(context).appBarTheme.textTheme.headline6,
            ),
          ),
          body: TabBarView(children: [
            Container(child: World()),
            Container(child: Countries())
          ]),
          // body: Container(child: Countries())),
        ));
  }
}
