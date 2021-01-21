import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PieChartFlutter extends StatefulWidget {
  @override
  _PieChartFlutterState createState() => _PieChartFlutterState();

  final List<double> chartData;
  final bool darkMode;

  const PieChartFlutter({Key key, this.chartData, this.darkMode})
      : super(key: key);
}

List<PieChartSectionData> showingSections(
    List<double> chartData, bool darkMode) {
  final double radius = 40;

  return [
    PieChartSectionData(
      color: darkMode ? Colors.blueAccent : Colors.blue,
      value: chartData[0],
      radius: radius,
      title: '',
    ),
    PieChartSectionData(
      color: darkMode ? Colors.lightGreenAccent : Colors.green,
      value: chartData[1],
      radius: radius,
      title: '',
    ),
    PieChartSectionData(
      color: darkMode ? Colors.redAccent : Colors.red,
      value: chartData[2],
      radius: radius,
      title: '',
    ),
  ];
}

class _PieChartFlutterState extends State<PieChartFlutter> {
  Widget piechart(chartData, darkMode) => AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(widget.chartData, widget.darkMode),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: piechart(widget.chartData, widget.darkMode),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.darkMode
                            ? Colors.lightGreenAccent
                            : Colors.green),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: RichText(
                      text: TextSpan(
                          text: 'Recovered',
                          style: GoogleFonts.openSans(
                              color:
                                  widget.darkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' (' +
                                    (widget.chartData[1] *
                                            100 ~/
                                            (widget.chartData[0] +
                                                widget.chartData[1] +
                                                widget.chartData[2]))
                                        .toStringAsFixed(1) +
                                    '%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: widget.darkMode ? Colors.blueAccent : Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: RichText(
                      text: TextSpan(
                          text: 'Active',
                          style: GoogleFonts.openSans(
                              color:
                                  widget.darkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' (' +
                                    (widget.chartData[0] *
                                            100 /
                                            (widget.chartData[0] +
                                                widget.chartData[1] +
                                                widget.chartData[2]))
                                        .toStringAsFixed(1) +
                                    '%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: widget.darkMode ? Colors.redAccent : Colors.red,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: RichText(
                      text: TextSpan(
                          text: 'Deaths',
                          style: GoogleFonts.openSans(
                              color:
                                  widget.darkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' (' +
                                    (widget.chartData[2] *
                                            100 /
                                            (widget.chartData[0] +
                                                widget.chartData[1] +
                                                widget.chartData[2]))
                                        .toStringAsFixed(1) +
                                    '%)',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor)),
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
