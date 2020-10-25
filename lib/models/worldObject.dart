class WorldTimeSeries {
  final DateTime date;
  final int variable;

  WorldTimeSeries({this.date, this.variable});
}

class WorldObject {
  int cases;
  int new_cases;
  int deaths;
  int new_deaths;
  int recovered;
  int new_recoveries;
  // var testspermillion;
  var casespermillion;
  var deathspermillion;
  // double tests_per_hundred;
  int active;
  DateTime lastUpdated;
  List<WorldTimeSeries> casesData;
  List<WorldTimeSeries> deathsData;

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
      // this.testspermillion,
      this.casespermillion,
      this.deathspermillion,
      this.deathsData});

  factory WorldObject.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> jsonTs) {
    List totalCases = (jsonTs['cases'].values).toList();
    List totalDeaths = (jsonTs['deaths'].values).toList();
    List dates = (jsonTs['cases'].keys).toList();
    // print(dates);
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
      // print(dates[29]);
      tempCases.add(new WorldTimeSeries(
          date: new DateTime(2020, month, day), variable: newInfections));
      tempDeaths.add(new WorldTimeSeries(
          date: new DateTime(2020, month, day), variable: newDeaths));
    }
    return WorldObject(
        cases: json['cases'],
        deaths: json['deaths'],
        recovered: json['recovered'],
        active: json['active'],
        new_cases: json['todayCases'],
        new_deaths: json['todayDeaths'],
        new_recoveries: json['todayRecovered'],
        // testspermillion: json['testsPerOneMillion'],
        casespermillion: json['casesPerOneMillion'],
        deathspermillion: json['deathsPerOneMillion'],
        casesData: tempCases,
        deathsData: tempDeaths,
        lastUpdated: new DateTime.fromMicrosecondsSinceEpoch(json['updated']));
  }
}
