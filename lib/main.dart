import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/countriesView.dart';
import 'screens/countryScreen.dart';
import 'screens/worldScreen.dart';
import './theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter App',
            theme: notifier.darkTheme ? dark : light,
            initialRoute: '/',
            routes: {
              '/': (context) => MyHomePage(),
              '/country': (context) => CountryPage(),
            },
          );
        }));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var brightness = Theme.of(context).brightness;
    // bool darkMode = brightness == Brightness.dark;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
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
            actions: [
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => IconButton(
                    icon: notifier.darkTheme
                        ? Icon(FontAwesomeIcons.solidSun)
                        : Icon(FontAwesomeIcons.moon),
                    onPressed: () {
                      notifier.toggleTheme();
                    },
                    color: Colors.white),
              )
            ],
          ),
          body: TabBarView(children: [
            Container(child: World()),
            Container(child: Countries())
          ]),
        ));
  }
}
