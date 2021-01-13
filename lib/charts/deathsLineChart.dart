import 'package:flutter/material.dart';
import '../models/worldObject.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DeathsLineChart extends StatelessWidget {
  List<charts.Series> seriesList;
  final bool animate;
  final List<WorldTimeSeries> chartData;
  // final bool darkmode;

  DeathsLineChart(this.chartData, {this.animate}) {
    seriesList = getChartData(chartData);
  }

  factory DeathsLineChart.withSampleData(
      List<WorldTimeSeries> data, bool darkmode) {
    return new DeathsLineChart(
      data,
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // var brigthness = MediaQuery.of(context).platformBrightness;
    // bool darkMode = brigthness == Brightness.dark;
    int length = chartData.length;
    if (length != 30) {
      //returns line-chart
      return Container(
        child: new charts.TimeSeriesChart(
          seriesList,
          animate: false,
          defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 3),
          // defaultRenderer: new charts.BarRendererConfig<DateTime>(),
          // It is recommended that default interactions be turned off if using bar
          // renderer, because the line point highlighter is the default for time
          // series chart.
          // defaultInteractions: false,
          // If default interactions were removed, optionally add select nearest
          // and the domain highlighter that are typical for bar charts.
          // behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
          domainAxis: new charts.DateTimeAxisSpec(
            tickProviderSpec:
                charts.DayTickProviderSpec(increments: [chartData.length ~/ 4]),
            renderSpec: new charts.SmallTickRendererSpec(
                // minimumPaddingBetweenLabelsPx: ,
                // labelRotation: 340,
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12,
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
              // showAxisLine: true,
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 6),
              renderSpec: new charts.GridlineRendererSpec(
                  // Tick and Label styling here.
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: 12, // size in Pts.
                      fontFamily: 'Open Sans',
                      color: charts.MaterialPalette.black),

                  // Change the line colors to match text color.
                  lineStyle: new charts.LineStyleSpec(
                      color: charts.MaterialPalette.gray.shade200))),
        ),
      );
    } else {
      return Container(
        child: new charts.TimeSeriesChart(
          seriesList,
          animate: false,
          // defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 3),
          defaultRenderer: new charts.BarRendererConfig<DateTime>(),
          // It is recommended that default interactions be turned off if using bar
          // renderer, because the line point highlighter is the default for time
          // series chart.
          defaultInteractions: false,
          // If default interactions were removed, optionally add select nearest
          // and the domain highlighter that are typical for bar charts.
          behaviors: [
            new charts.SelectNearest(),
            new charts.DomainHighlighter()
          ],
          domainAxis: new charts.DateTimeAxisSpec(
            tickProviderSpec:
                charts.DayTickProviderSpec(increments: [chartData.length ~/ 4]),
            renderSpec: new charts.SmallTickRendererSpec(
                // minimumPaddingBetweenLabelsPx: ,
                // labelRotation: 340,
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12,
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
              // showAxisLine: true,
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(desiredTickCount: 6),
              renderSpec: new charts.GridlineRendererSpec(
                  // Tick and Label styling here.
                  labelStyle: new charts.TextStyleSpec(
                      fontSize: 12, // size in Pts.
                      fontFamily: 'Open Sans',
                      color: charts.MaterialPalette.black),

                  // Change the line colors to match text color.
                  lineStyle: new charts.LineStyleSpec(
                      color: charts.MaterialPalette.gray.shade200))),
        ),
      );
    }
  }

  static List<charts.Series<WorldTimeSeries, DateTime>> getChartData(
      List<WorldTimeSeries> chartData) {
    final data = chartData;
    return [
      new charts.Series<WorldTimeSeries, DateTime>(
        id: 'New Deaths',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.grey.shade700),
        domainFn: (WorldTimeSeries item, _) => item.date,
        measureFn: (WorldTimeSeries item, _) => item.variable,
        data: data,
      )
    ];
  }
}
