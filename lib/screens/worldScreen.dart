import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/worldData.dart';
import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../charts/PieChart.dart';
import '../charts/LineChartDeaths.dart';
import '../charts/LineChartCases.dart';
import '../charts/BarChartCases.dart';
import '../charts/BarChartDeaths.dart';

class World extends StatefulWidget {
  @override
  _WorldState createState() => _WorldState();
}

Future<WorldObject> fetchData() async {
  var deltaDays =
      (new DateTime.now().difference(new DateTime(2020, 3, 14))).inDays;
  // print(deltaDays);
  var responses = await Future.wait([
    http.get('https://disease.sh/v3/covid-19/all'),
    http.get(
        'https://corona.lmao.ninja/v3/covid-19/historical/all/?lastdays=${deltaDays}'),
  ]);

  if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
    Map jsonResponse = json.decode(responses[0].body);
    Map jsonHistorical = json.decode(responses[1].body);
    // print(jsonHistorical['cases'].keys.toList().length);
    return WorldObject.fromJson(jsonResponse, jsonHistorical);
  }
}

class _WorldState extends State<World>
    with AutomaticKeepAliveClientMixin<World> {
  Future<WorldObject> data;
  var selectedVariable = 'New Infections';
  var timeline = "30 Days";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    data = fetchData();
    // print(data);
    super.initState();
    // data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // need to call super method.
    var f = new NumberFormat("###,###", "en_US");
    var brigthness = Theme.of(context).brightness;
    bool darkMode = brigthness == Brightness.dark;
    return FutureBuilder<WorldObject>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: PieChartFlutter(chartData: [
                              snapshot.data.active.toDouble(),
                              snapshot.data.recovered.toDouble(),
                              snapshot.data.deaths.toDouble()
                            ], darkMode: darkMode)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Cases/M',
                                      style: GoogleFonts.openSans(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      f.format(snapshot.data.casespermillion),
                                      style: GoogleFonts.openSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Deaths/M',
                                      style: GoogleFonts.openSans(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      f.format(snapshot.data.deathspermillion),
                                      style: GoogleFonts.openSans(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          children: [
                            Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Confirmed',
                                          style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          f.format(snapshot.data.cases),
                                          style: GoogleFonts.openSans(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        snapshot.data.new_cases != 0
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Text(
                                                  '+' +
                                                      f.format(snapshot
                                                          .data.new_cases),
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor),
                                                ))
                                            : Text('')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Deaths',
                                          style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          f.format(snapshot.data.deaths),
                                          style: GoogleFonts.openSans(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        snapshot.data.new_deaths != 0
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: Text(
                                                  '+' +
                                                      f.format(snapshot
                                                          .data.new_deaths),
                                                  style: GoogleFonts.openSans(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .secondaryHeaderColor),
                                                ),
                                              )
                                            : Text('')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ChoiceChip(
                                    label: Text('All Time',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600)),
                                    selected: timeline == 'All Time',
                                    selectedColor: darkMode
                                        ? Colors.grey[100]
                                        : Colors.blue[100],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        timeline = 'All Time';
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ChoiceChip(
                                    label: Text(
                                      '30 Days',
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    selected: timeline == '30 Days',
                                    selectedColor: darkMode
                                        ? Colors.grey[100]
                                        : Colors.blue[100],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        timeline = '30 Days';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: timeline == "All Time"
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(11, 5, 24, 5),
                                    child: selectedVariable == 'New Infections'
                                        ? LineChartCases(
                                            chartData: snapshot.data.casesData,
                                            darkMode: notifier.darkTheme,
                                          )
                                        : LineChartDeaths(
                                            chartData: snapshot.data.deathsData,
                                            darkMode: notifier.darkTheme,
                                          ),
                                  )
                                : Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(11, 5, 24, 5),
                                    child: selectedVariable == 'New Infections'
                                        ? BarChartCases(
                                            chartData: snapshot.data.casesData
                                                .sublist(snapshot
                                                        .data.casesData.length -
                                                    30),
                                            darkMode: notifier.darkTheme,
                                          )
                                        : BarChartDeaths(
                                            chartData: snapshot.data.deathsData
                                                .sublist(snapshot
                                                        .data.casesData.length -
                                                    30),
                                            darkMode: notifier.darkTheme,
                                          ),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ChoiceChip(
                                    label: Text('New Infections',
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w600)),
                                    selected:
                                        selectedVariable == 'New Infections',
                                    selectedColor: darkMode
                                        ? Colors.grey[100]
                                        : Colors.blue[100],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedVariable = 'New Infections';
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ChoiceChip(
                                    label: Text(
                                      'New Deaths',
                                      style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    selected: selectedVariable == 'New Deaths',
                                    selectedColor: darkMode
                                        ? Colors.grey[100]
                                        : Colors.blue[100],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedVariable = 'New Deaths';
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onRefresh: refreshData);
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<Null> refreshData() async {
    setState(() {
      data = fetchData();
    });
  }
}
