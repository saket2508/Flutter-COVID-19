import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DonutPieChart extends StatelessWidget {
  List<charts.Series> seriesList;
  final bool animate;
  final List<int> chartData;

  DonutPieChart(this.chartData, {this.animate}) {
    final provided_data = [
      new CountryPieDataLabel(
          'Active', chartData[0], charts.ColorUtil.fromDartColor(Colors.blue)),
      new CountryPieDataLabel('Recovered', chartData[1],
          charts.ColorUtil.fromDartColor(Colors.lightGreen)),
      new CountryPieDataLabel(
        'Deaths',
        chartData[2],
        charts.ColorUtil.fromDartColor(Colors.red),
      )
    ];

    seriesList = getChartData(provided_data);
  }

  factory DonutPieChart.withSampleData(List<int> data) {
    return new DonutPieChart(
      data,
      // Disable animations for image tests.
      // darkmode: darkmode,
      animate: false,
    );
  }

  static List<charts.Series<CountryPieDataLabel, String>> getChartData(
      List<CountryPieDataLabel> _provided_data) {
    return [
      new charts.Series<CountryPieDataLabel, String>(
        id: 'Stats',
        domainFn: (CountryPieDataLabel stats, _) => stats.label,
        measureFn: (CountryPieDataLabel stats, _) => stats.value,
        colorFn: (CountryPieDataLabel stats, _) => stats.color,
        data: _provided_data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // var brigthness = MediaQuery.of(context).platformBrightness;
    // bool darkMode = brigthness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: new charts.PieChart(seriesList,
              animate: animate,
              defaultRenderer: new charts.ArcRendererConfig(arcWidth: 30)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightGreen),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Recovered',
                          style: GoogleFonts.openSans(
                              // fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' (' +
                                    (chartData[1] *
                                            100 ~/
                                            (chartData[0] +
                                                chartData[1] +
                                                chartData[2]))
                                        .toStringAsFixed(1) +
                                    '%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    color: Colors.grey[700])),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.lightBlue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Active',
                          style: GoogleFonts.openSans(
                              // fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' (' +
                                    (chartData[0] *
                                            100 /
                                            (chartData[0] +
                                                chartData[1] +
                                                chartData[2]))
                                        .toStringAsFixed(1) +
                                    '%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    color: Colors.grey[700])),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Deaths',
                          style: GoogleFonts.openSans(
                              // fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' (' +
                                    (chartData[2] *
                                            100 /
                                            (chartData[0] +
                                                chartData[1] +
                                                chartData[2]))
                                        .toStringAsFixed(1) +
                                    '%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    color: Colors.grey[700])),
                          ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class CountryPieDataLabel {
  final String label;
  final int value;
  final charts.Color color;

  CountryPieDataLabel(this.label, this.value, this.color);
}
