import 'timeSeriesModel.dart';

class WorldObject {
  int cases;
  int new_cases;
  int deaths;
  int new_deaths;
  int recovered;
  int new_recoveries;
  var casespermillion;
  var deathspermillion;
  int active;
  DateTime lastUpdated;
  List<TimeSeries> casesData;
  List<TimeSeries> deathsData;

  WorldObject(
      {this.cases,
      this.deaths,
      this.recovered,
      this.active,
      this.new_cases,
      this.new_deaths,
      this.new_recoveries,
      this.lastUpdated,
      this.casesData,
      this.casespermillion,
      this.deathspermillion,
      this.deathsData});

  factory WorldObject.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> jsonTs) {
    List totalCases = (jsonTs['cases'].values).toList();
    List totalDeaths = (jsonTs['deaths'].values).toList();
    List dates = (jsonTs['cases'].keys).toList();
    List<TimeSeries> tempCases = [];
    List<TimeSeries> tempDeaths = [];
    for (int i = 1; i < totalCases.length; i++) {
      int newInfections = totalCases[i] - totalCases[i - 1];
      int newDeaths = totalDeaths[i] - totalDeaths[i - 1];
      int month = int.parse(dates[i].substring(0, dates[i].indexOf('/')));

      int day = int.parse(dates[i]
          .substring(dates[i].indexOf('/') + 1, dates[i].indexOf('/', 3)));

      int year =
          2000 + int.parse(dates[i].substring(dates[i].indexOf('/', 3) + 1));
      tempCases.add(new TimeSeries(
          date: new DateTime(year, month, day), variable: newInfections));
      tempDeaths.add(new TimeSeries(
          date: new DateTime(year, month, day), variable: newDeaths));
    }
    return WorldObject(
        cases: json['cases'],
        deaths: json['deaths'],
        recovered: json['recovered'],
        active: json['active'],
        new_cases: json['todayCases'],
        new_deaths: json['todayDeaths'],
        new_recoveries: json['todayRecovered'],
        casespermillion: json['casesPerOneMillion'],
        deathspermillion: json['deathsPerOneMillion'],
        casesData: tempCases,
        deathsData: tempDeaths,
        lastUpdated: new DateTime.fromMicrosecondsSinceEpoch(json['updated']));
  }
}
