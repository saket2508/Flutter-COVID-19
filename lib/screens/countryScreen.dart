import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/countryData.dart';
import '../models/countryTimeSeries.dart';
import '../charts/donutPieChart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../charts/casesLineChart.dart';
import '../charts/deathsLineChart.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

Future<CountryTimeSeries> getData(var countryName, var url) async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Map jsonTs = json.decode(response.body);
    if (jsonTs['message'] ==
        "Country not found or doesn't have any historical data") {
      throw new Exception('Could not get historical data for ' + countryName);
    } else {
      return CountryTimeSeries.fromJson(jsonTs['timeline']);
    }
  }
}

class _CountryPageState extends State<CountryPage> {
  Future<CountryTimeSeries> _timeseriesdata;
  Country _selectedCountry;
  var selectedVariable = "New Infections";
  var timeline = "30 Days";
  bool _checkConfiguration() => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_checkConfiguration()) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          Country _selectedCountry = ModalRoute.of(context).settings.arguments;
          var deltaDays =
              (new DateTime.now().difference(new DateTime(2020, 3, 14))).inDays;
          // print(deltaDays);
          _timeseriesdata = getData(_selectedCountry.country_name,
              "https://corona.lmao.ninja/v3/covid-19/historical/${_selectedCountry.country_name}/?lastdays=${deltaDays}");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Country data = ModalRoute.of(context).settings.arguments;
    var f = new NumberFormat("###,###", "en_US");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 24,
              child: Image(
                image: NetworkImage(data.flag_img),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                data.country_name,
                style: Theme.of(context).appBarTheme.textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
      body: Container(
          child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: DonutPieChart.withSampleData(
                      [data.active, data.recovered, data.deaths]),
                ),
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
                                  color: Colors.grey[700],
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              f.format(data.casespermillion),
                              style: GoogleFonts.openSans(
                                  // color: Colors.grey[700],
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
                                  color: Colors.grey[700],
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              f.format(data.deathspermillion),
                              style: GoogleFonts.openSans(
                                  // color: Colors.grey[700],
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Tests/M',
                              style: GoogleFonts.openSans(
                                  letterSpacing: 1.0,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              f.format(data.testspermillion),
                              style: GoogleFonts.openSans(
                                  // color: Colors.grey[700],
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Confirmed',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  f.format(data.cases),
                                  style: GoogleFonts.openSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
                                data.new_cases != 0
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          '+' + f.format(data.new_cases),
                                          style: GoogleFonts.openSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]),
                                        ),
                                      )
                                    : Text('')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Deaths',
                                style: GoogleFonts.openSans(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                f.format(data.deaths),
                                style: GoogleFonts.openSans(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              data.new_deaths != 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        '+' + f.format(data.new_deaths),
                                        style: GoogleFonts.openSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700]),
                                      ))
                                  : Text('')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: FutureBuilder<CountryTimeSeries>(
              future: _timeseriesdata,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                                selectedColor: Colors.blue[100],
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
                                selectedColor: Colors.blue[100],
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
                                    const EdgeInsets.fromLTRB(10, 0, 10, 3),
                                child: selectedVariable == "New Infections"
                                    ? CasesLineChart.withSampleData(
                                        snapshot.data.casesData, false)
                                    : DeathsLineChart.withSampleData(
                                        snapshot.data.deathsData, false),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 3),
                                child: selectedVariable == "New Infections"
                                    ? CasesLineChart.withSampleData(
                                        snapshot.data.casesData.sublist(
                                            snapshot.data.casesData.length -
                                                30),
                                        false)
                                    : DeathsLineChart.withSampleData(
                                        snapshot.data.deathsData.sublist(
                                            snapshot.data.casesData.length -
                                                30),
                                        false),
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
                                selected: selectedVariable == 'New Infections',
                                selectedColor: Colors.blue[100],
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
                                selectedColor: Colors.blue[100],
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
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.width * 0.7,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 3),
                            child: Center(
                              child: Text('Time Series data not available',
                                  style: GoogleFonts.openSans(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          )),
                      Padding(padding: const EdgeInsets.all(2))
                    ],
                  );
                }
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.7,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Text(''),
                    )
                  ],
                );
              },
            ),
          )
        ],
      )),
    );
  }
}
