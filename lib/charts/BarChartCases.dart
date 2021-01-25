import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/timeSeriesModel.dart';

class BarChartCases extends StatefulWidget {
  @override
  _BarChartCasesState createState() => _BarChartCasesState();

  final List<TimeSeries> chartData;
  final bool darkMode;

  const BarChartCases({Key key, this.chartData, this.darkMode})
      : super(key: key);
}

class _BarChartCasesState extends State<BarChartCases> {
  @override
  Widget build(BuildContext context) {
    double min_y = double.maxFinite;
    double max_y = double.minPositive;
    double y_divider = 0;
    double max_x = 0;
    double min_x = 0;

    List<BarChartGroupData> _values = const [];

    int touchedIndex;

    _values = widget.chartData.map((data) {
      if (max_y < data.variable) {
        max_y = data.variable.toDouble();
      }
      if (min_y > data.variable) {
        min_y = data.variable.toDouble();
      }
      return BarChartGroupData(x: data.date.millisecondsSinceEpoch, barRods: [
        BarChartRodData(
          y: data.variable.toDouble(),
          colors: [widget.darkMode ? Colors.redAccent : Colors.red],
          width: 8,
        ),
      ]);
    }).toList();
    if (max_y < 100000) {
      y_divider = (((max_y - min_y) / 5) / 10000).ceilToDouble() * 10000;
    } else {
      y_divider = (((max_y - min_y) / 5) / 100000).ceilToDouble() * 100000;
    }

    min_y = (min_y / y_divider).floorToDouble() * y_divider;
    max_y = (max_y / y_divider).ceilToDouble() * y_divider;

    double y_interval = ((max_y - min_y) / (5)).floorToDouble();
    min_x = _values.first.x.toDouble();
    max_x = _values.last.x.toDouble();

    return AspectRatio(
      aspectRatio: 1.0,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: widget.darkMode
                    ? Colors.grey[700].withOpacity(0.8)
                    : Colors.white.withOpacity(0.8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  DateTime date =
                      DateTime.fromMillisecondsSinceEpoch(group.x.toInt());
                  return BarTooltipItem(
                      DateFormat('MMMd').format(date) +
                          "\n" +
                          NumberFormat('#,###').format(rod.y) +
                          " New Infections",
                      GoogleFonts.openSans(
                          color: widget.darkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 10));
                }),
            touchCallback: (barTouchResponse) {
              setState(() {
                if (barTouchResponse.spot != null &&
                    barTouchResponse.touchInput is! FlPanEnd &&
                    barTouchResponse.touchInput is! FlLongPressEnd) {
                  touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
                } else {
                  touchedIndex = -1;
                }
              });
            },
          ),
          maxY: max_y,
          minY: min_y,
          borderData: FlBorderData(
            border: Border.all(
                color: widget.darkMode ? Colors.grey[800] : Colors.grey[200],
                width: 1),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: widget.darkMode ? Colors.grey[800] : Colors.grey[200],
                strokeWidth: 1,
              );
            },
            checkToShowHorizontalLine: (value) {
              return (value - min_y) % y_interval == 0;
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              rotateAngle: 340,
              showTitles: true,
              getTextStyles: (value) => TextStyle(
                color: widget.darkMode ? Colors.white : Colors.black,
                fontSize: 12,
              ),
              margin: 4,
              getTitles: (value) {
                final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                // print(value);
                if (value == _values[4].x ||
                    value == _values[9].x ||
                    value == _values[14].x ||
                    value == _values[19].x ||
                    value == _values[24].x ||
                    value == _values[29].x) {
                  return DateFormat('MMMd').format(date);
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTextStyles: (value) => TextStyle(
                color: widget.darkMode ? Colors.white : Colors.black,
                fontSize: 12,
              ),
              margin: 6,
              getTitles: (double value) {
                return NumberFormat.compact().format(value);
              },
              interval: y_interval,
            ),
          ),
          barGroups: _values,
        ),
      ),
    );
  }

  List<BarChartGroupData> getBarChartData(chartData, touchedIndex) {
    int mapIndex = -1;
    // List<BarChartGroupData> _values = const [];
    return chartData.map((data) {
      mapIndex += 1;
      return BarChartGroupData(x: data.date.millisecondsSinceEpoch, barRods: [
        BarChartRodData(
          y: data.variable.toDouble(),
          colors: [
            widget.darkMode
                ? mapIndex == touchedIndex
                    ? Colors.red[100]
                    : Colors.red
                : mapIndex == touchedIndex
                    ? Colors.redAccent[100]
                    : Colors.redAccent
          ],
          width: 8,
        ),
      ]);
    }).toList();
  }
}
