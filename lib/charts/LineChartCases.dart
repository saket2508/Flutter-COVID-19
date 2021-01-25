import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/timeSeriesModel.dart';

class LineChartCases extends StatefulWidget {
  @override
  _LineChartCasesState createState() => _LineChartCasesState();

  final List<TimeSeries> chartData;
  final bool darkMode;

  const LineChartCases({Key key, this.chartData, this.darkMode})
      : super(key: key);
}

class _LineChartCasesState extends State<LineChartCases> {
  @override
  Widget build(BuildContext context) {
    double y_divider = 0;
    double y_label_count = 6;
    double min_y = double.maxFinite;
    double max_y = double.minPositive;
    double min_x = 0;
    double max_x = 0;
    List<FlSpot> _values = const [];

    _values = widget.chartData.map((datum) {
      if (max_y < datum.variable) {
        max_y = datum.variable.toDouble();
      }
      if (min_y > datum.variable) {
        min_y = datum.variable.toDouble();
      }
      return FlSpot(datum.date.millisecondsSinceEpoch.toDouble(),
          datum.variable.toDouble());
    }).toList();

    if (max_y < 100000) {
      y_divider = (((max_y - min_y) / 5) / 10000).ceilToDouble() * 10000;
    } else {
      y_divider = (((max_y - min_y) / 5) / 100000).ceilToDouble() * 100000;
    }

    min_x = _values.first.x;
    max_x = _values.last.x;

    min_y = (min_y / y_divider).floorToDouble() * y_divider;
    max_y = (max_y / y_divider).ceilToDouble() * y_divider;

    double y_interval = ((max_y - min_y) / (y_label_count - 1)).floorToDouble();

    return AspectRatio(
      aspectRatio: 1.0,
      child: LineChart(LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: widget.darkMode
                  ? Colors.grey[700].withOpacity(0.8)
                  : Colors.white.withOpacity(0.8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  DateTime date =
                      DateTime.fromMillisecondsSinceEpoch(barSpot.x.toInt());
                  return LineTooltipItem(
                    DateFormat('MMMd').format(date) +
                        '\n' +
                        NumberFormat('#,###').format(barSpot.y) +
                        ' New Infections',
                    GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        color: widget.darkMode ? Colors.white : Colors.black,
                        fontSize: 10),
                  );
                }).toList();
              }),
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              final FlSpot spot = barData.spots[spotIndex];
              return TouchedSpotIndicatorData(
                FlLine(
                    color: widget.darkMode
                        ? Colors.redAccent.withOpacity(0.8)
                        : Colors.red,
                    strokeWidth: 2),
                FlDotData(getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 8,
                    color: widget.darkMode ? Colors.grey[850] : Colors.white,
                    strokeWidth: 4,
                    strokeColor: widget.darkMode
                        ? Colors.redAccent.withOpacity(0.8)
                        : Colors.red,
                  );
                }),
              );
            }).toList();
          },
        ),
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
        minX: min_x,
        maxX: max_x,
        minY: min_y,
        maxY: max_y,
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            rotateAngle: 340,
            showTitles: true,
            getTextStyles: (value) => TextStyle(
              color: widget.darkMode ? Colors.white : Colors.black,
              fontSize: 12,
            ),
            getTitles: (value) {
              final DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(value.toInt());
              if (date.month == 3 || date.month == 1) {
                return DateFormat('MMM y').format(date);
              }
              return DateFormat('MMM').format(date);
            },
            margin: 4,
            interval: (max_x - min_x) / 5,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTextStyles: (value) => TextStyle(
              color: widget.darkMode ? Colors.white : Colors.black,
              fontSize: 12,
            ),
            getTitles: (value) => NumberFormat.compact().format(value),
            margin: 0,
            interval: y_interval,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _values,
            colors: widget.darkMode ? [Colors.redAccent] : [Colors.red],
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              colors: widget.darkMode
                  ? [Colors.redAccent[200].withOpacity(0.15)]
                  : [Colors.red[200].withOpacity(0.15)],
              gradientColorStops: const [0.25, 0.5, 0.75],
              gradientFrom: const Offset(0.5, 0),
              gradientTo: const Offset(0.5, 1),
            ),
          ),
        ],
      )),
    );
  }
}
