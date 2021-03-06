import 'worldData.dart';
import './timeSeriesModel.dart';

class CountryTimeSeries {
  final List<TimeSeries> casesData;
  final List<TimeSeries> deathsData;

  CountryTimeSeries({this.casesData, this.deathsData});

  factory CountryTimeSeries.fromJson(Map<String, dynamic> jsonTs) {
    List totalCases = (jsonTs['cases'].values).toList();
    List totalDeaths = (jsonTs['deaths'].values).toList();
    List dates = (jsonTs['cases'].keys).toList();
    // print(dates);
    List<TimeSeries> tempCases = [];
    List<TimeSeries> tempDeaths = [];
    // print(totalCases.length);
    for (int i = 1; i < totalCases.length; i++) {
      int newInfections = totalCases[i] - totalCases[i - 1];
      int newDeaths = totalDeaths[i] - totalDeaths[i - 1];
      int month = int.parse(dates[i].substring(0, dates[i].indexOf('/')));
      // print(month);
      int day = int.parse(dates[i]
          .substring(dates[i].indexOf('/') + 1, dates[i].indexOf('/', 3)));
      int year =
          2000 + int.parse(dates[i].substring(dates[i].indexOf('/', 3) + 1));
      // print(day);
      // print(dates[29]);
      tempCases.add(TimeSeries(
          variable: newInfections, date: DateTime(year, month, day)));
      tempDeaths.add(
          TimeSeries(variable: newDeaths, date: DateTime(year, month, day)));
    }

    return CountryTimeSeries(casesData: tempCases, deathsData: tempDeaths);
  }
}
