import 'package:flutter/material.dart';
import '../models/worldObject.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CasesLineChart extends StatelessWidget {
  List<charts.Series> seriesList;
  final bool animate;
  final List<WorldTimeSeries> chartData;

  CasesLineChart(this.chartData, {this.animate}) {
    seriesList = getChartData(chartData);
  }

  factory CasesLineChart.withSampleData(
      List<WorldTimeSeries> data, bool darkmode) {
    return new CasesLineChart(
      data,
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new charts.TimeSeriesChart(
        seriesList,
        animate: false,
        defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 3),
        // It is recommended that default interactions be turned off if using bar
        // renderer, because the line point highlighter is the default for time
        // series chart.
        // defaultInteractions: false,
        // If default interactions were removed, optionally add select nearest
        // and the domain highlighter that are typical for bar charts.
        // behaviors: [
        //   new charts.SelectNearest(),
        //   new charts.DomainHighlighter()
        // ],
        domainAxis: new charts.EndPointsTimeAxisSpec(
          tickProviderSpec:
              charts.DayTickProviderSpec(increments: [chartData.length ~/ 4]),
          renderSpec: new charts.SmallTickRendererSpec(
              // labelRotation: 340,
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
                  fontFamily: 'Open Sans',
                  color: charts.MaterialPalette.black),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.gray.shade300)),
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(
              format: 'MMM dd',
              transitionFormat: 'MMM dd',
            ),
          ),
          // showAxisLine: true,
        ),
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec:
                new charts.BasicNumericTickProviderSpec(desiredTickCount: 6),
            renderSpec: new charts.GridlineRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12,
                    fontFamily: 'Open Sans',
                    color: charts.MaterialPalette.black),
                lineStyle: new charts.LineStyleSpec(
                    color: charts.MaterialPalette.gray.shade200))),
      ),
    );
  }

  static List<charts.Series<WorldTimeSeries, DateTime>> getChartData(
      List<WorldTimeSeries> chartData) {
    final data = chartData;
    print(data.length);
    return [
      new charts.Series<WorldTimeSeries, DateTime>(
        id: 'New Infections',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        domainFn: (WorldTimeSeries item, _) => item.date,
        measureFn: (WorldTimeSeries item, _) => item.variable,
        data: data,
      )
    ];
  }
}
