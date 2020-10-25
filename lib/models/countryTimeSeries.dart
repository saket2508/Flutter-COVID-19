import './worldObject.dart';

// class TimeSeries {
//   final int variable;
//   final DateTime date;

//   TimeSeries({this.date, this.variable});
// }

class CountryTimeSeries {
  final List<WorldTimeSeries> casesData;
  final List<WorldTimeSeries> deathsData;

  CountryTimeSeries({this.casesData, this.deathsData});

  factory CountryTimeSeries.fromJson(Map<String, dynamic> jsonTs) {
    List totalCases = (jsonTs['cases'].values).toList();
    List totalDeaths = (jsonTs['deaths'].values).toList();
    List dates = (jsonTs['cases'].keys).toList();
    print(dates);
    List<WorldTimeSeries> tempCases = [];
    List<WorldTimeSeries> tempDeaths = [];
    // print(totalCases.length);
    for (int i = 1; i < totalCases.length; i++) {
      int newInfections = totalCases[i] - totalCases[i - 1];
      int newDeaths = totalDeaths[i] - totalDeaths[i - 1];
      int month = int.parse(dates[i].substring(0, dates[i].indexOf('/')));
      // print(month);
      int day = int.parse(dates[i]
          .substring(dates[i].indexOf('/') + 1, dates[i].indexOf('/', 3)));

      // print(day);
      print(dates[29]);
      tempCases.add(WorldTimeSeries(
          variable: newInfections, date: DateTime(2020, month, day)));
      tempDeaths.add(WorldTimeSeries(
          variable: newDeaths, date: DateTime(2020, month, day)));
    }

    return CountryTimeSeries(casesData: tempCases, deathsData: tempDeaths);
  }
}
